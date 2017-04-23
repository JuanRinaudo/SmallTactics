package ludumdare38;
import kge.core.Basic;
import kge.core.Game;
import kge.core.Signal;
import kha.math.Vector2;


class PlayerHandler extends Basic
{
	public var onTurnComplete:Signal = new Signal();
	public var onTurn:Bool;
	
	public var playerUnits:UnitList;
	private var playerBuildings:BuildingList;
	private var gameGrid:GameGrid;
	private var gameUI:GameUI;
	
	private var unitSelected:Unit;
	private var buildingSelected:Building;
	
	private var playerResources:Resources;
	
	private var lastOveredIndex:Int;
	
	private static var clearResources:Resources = {wood: 0, iron:0, people: 0};
	
	public function new(playerUnits:UnitList, playerBuildings:BuildingList, gameGrid:GameGrid, gameUI:GameUI) 
	{
		super();
		
		this.playerUnits = playerUnits;
		this.playerBuildings = playerBuildings;
		this.gameGrid = gameGrid;
		this.gameUI = gameUI;
		
		playerResources = {wood: 100, iron: 100, people: 10};
	}
	
	public function addBuilding(x:Int, y:Int, type:BuildingType) {
		var building:Building = new Building(type, this);
		var cell:GridCell = gameGrid.getCell(x, y);
		cell.addBuilding(building);
		playerBuildings.addBuilding(building);
	}
	
	public function addUnit(x:Int, y:Int, type:UnitType) {
		var unit:Unit = new Unit(type);
		var cell:GridCell = gameGrid.getCell(x, y);
		cell.addUnit(unit);
		playerUnits.addUnit(unit);
	}
	
	public function addResources(resources:Resources) {
		playerResources.wood += resources.wood;
		playerResources.iron += resources.iron;
		playerResources.people += resources.people;
	}
	
	private function removeResources(resources:Resources) {
		playerResources.wood -= resources.wood;
		playerResources.iron -= resources.iron;
		playerResources.people -= resources.people;
	}
	
	private function onCreationClick(index:Int) {
		trace("CREATION CLICK: " + index);
		if (buildingSelected != null) {
			buildingCreateUnit(index);
		} else if (unitSelected != null) {
			unitCreateBuilding(index);
		}
		gameUI.refreshResourcesNeeded(clearResources, playerResources);
	}
	
	private function buildingCreateUnit(index:Int) {
		trace("BUILD UNIT: " + index);
		var cell:GridCell = buildingSelected.cell;
		var unitType:UnitType = buildingSelected.getCreationList()[index];
		var resources:Resources = Unit.resourceNeededUnit(unitType);
		if(!cell.hasUnit() && hasResources(resources)) {
			addUnit(cell.cellX, cell.cellY, unitType);
			removeResources(resources);
			buildingSelected.canBeUsed = false;
			buildingSelected = null;
			
			refreshResources();
		}
	}
	
	private function unitCreateBuilding(index:Int) {
		trace("BUILD BUILDING: " + index);
		var cell:GridCell = unitSelected.cell;
		var buildingType:BuildingType = unitSelected.getCreationList()[index];
		var resources:Resources = Building.resourceNeededBuilding(buildingType);
		var requiredCellType:CellType = Building.requiredCellType(buildingType);
		if(!cell.hasBuilding() && hasResources(resources) && (requiredCellType == NONE || requiredCellType == cell.cellType)) {
			addBuilding(cell.cellX, cell.cellY, buildingType);
			removeResources(resources);
			unitSelected.canDoAction = false;
			unitSelected.kill();
			unitSelected = null;
			
			refreshResources();
		}
	}
	
	private function hasResources(resources:Resources):Bool {
		return playerResources.wood >= resources.wood && playerResources.iron >= resources.iron && playerResources.people >= resources.people;
	}
	
	private function onCreationOver(index:Int) {
		lastOveredIndex = index;
		var resources:Resources = {wood: 0, iron: 0, people: 0};
		if (buildingSelected != null) {
			resources = Unit.resourceNeededUnit(buildingSelected.getCreationList()[index]);
		} else if (unitSelected != null) {
			resources = Building.resourceNeededBuilding(unitSelected.getCreationList()[index]);
		}
		gameUI.refreshResourcesNeeded(resources, playerResources);
	}
	
	private function onCreationOut(index:Int) {
		if(lastOveredIndex == index) {
			gameUI.refreshResourcesNeeded(clearResources, playerResources);
		}
	}
	
	public function startTurn() {
		onTurn = true;
		
		for (unit in playerUnits.units) {
			unit.onStartTurn();
		}
		
		for (building in playerBuildings.buildings) {
			building.onStartTurn();
		}
		
		gameUI.onCreationClick.add(onCreationClick);
		gameUI.onCreationOver.add(onCreationOver);
		gameUI.onCreationOut.add(onCreationOut);
		
		refreshResources();
	}
	
	private function refreshResources() {
		gameUI.refreshResources(playerResources);
	}
	
	public function endTurn() {
		gameUI.clearCreationList();
		
		for (unit in playerUnits.units) {
			unit.onEndTurn();
		}
		
		gameUI.onCreationClick.remove(onCreationClick);
		gameUI.onCreationOver.remove(onCreationOver);
		gameUI.onCreationOut.remove(onCreationOut);
		
		unitSelected = null;
		buildingSelected = null;
		
		onTurn = false;
		onTurnComplete.dispatch();
	}
	
	public function skipTurn() {
		if(onTurn) {
			endTurn();
		}
	}
	
	override public function update() 
	{
		super.update();
		
		if (onTurn) {
			var mouseClicked:Bool = Game.input.mouse.buttonPressed(0);
			var mousePos:Vector2 = Game.input.mouse.mousePosition;
			
			//Unit logic
			gameGrid.clearOverlay();
			if (unitSelected != null && buildingSelected == null) {
				//When unit selected
				gameUI.clearCreationList();
				//Draw attack or movement overlay
				if(unitSelected.canMove) {
					gameGrid.drawMovementOverlay(unitSelected);
					
					if (mouseClicked) {	
						var gridPosition:Vector2 = gameGrid.screenPosToGridPos(mousePos.x, mousePos.y);
						var cell:GridCell = gameGrid.getCell(Math.floor(gridPosition.x), Math.floor(gridPosition.y));
						if (cell != null && !cell.hasUnit() && !(cell.hasBuilding() && cell.getBuilding().playerHandler != this)) {
							gameGrid.moveUnit(unitSelected, cell);
						} else if (cell == unitSelected.cell) {
							unitSelected.canMove = false;
						}
						unitSelected = null;
					}
				} else if (unitSelected.canDoAction) {
					if(unitSelected.attackRange > 0) {
						gameGrid.drawAttackOverlay(unitSelected);
						
						if (mouseClicked) {
							var gridPosition:Vector2 = gameGrid.screenPosToGridPos(mousePos.x, mousePos.y);
							var cell:GridCell = gameGrid.getCell(Math.floor(gridPosition.x), Math.floor(gridPosition.y));
							if (cell != null && cell != unitSelected.cell) {
								if (cell.hasUnit()) { gameGrid.attackUnit(unitSelected, cell.getUnit()); }
								else if (cell.hasBuilding()) { gameGrid.attackBuilding(unitSelected, cell.getBuilding()); }
							}
							unitSelected = null;
						}
					} else {
						if (unitSelected.type == UnitType.BUILDER) {
							gameUI.drawBuildingCreationList(unitSelected);
						}
					}
				}
				
				//Deselect
				if (mouseClicked && unitSelected != null && !unitSelected.pointOver(mousePos.x, mousePos.y)) {
					unitSelected = null;
				}
			} else if (buildingSelected != null) {
				//When building selected
				gameUI.drawUnitCreationList(buildingSelected);
				//Deselect
				if (mouseClicked && !buildingSelected.pointOver(mousePos.x, mousePos.y)) {
					buildingSelected = null;
				}
			} else {				
				//Building logic
				gameUI.clearCreationList();
				//Select buildings
				for (building in playerBuildings.availableBuildings()) {
					if (building.pointOver(mousePos.x, mousePos.y)) {
						//If building can be used preview list
						if (building.canBeUsed) {
							gameUI.drawUnitCreationList(building, 0.5);
							//On click
							if (mouseClicked) {
								unitSelected = null;
								buildingSelected = building;
							}
						}
					}
				}
				
				for (unit in playerUnits.availableUnits()) {
					if (unit.pointOver(mousePos.x, mousePos.y)) {
						if (unit.canMove || unit.canDoAction) {
							gameUI.clearCreationList();
							//Draw attack or movement overlay
							if(unit.canMove) {
								gameGrid.drawMovementOverlay(unit);
							} else if(unit.canDoAction) {
								if(unit.attackRange > 0) {
									gameGrid.drawAttackOverlay(unit);
								} else {
									if (unit.type == UnitType.BUILDER) {
										gameUI.drawBuildingCreationList(unit, 0.5);
									}
								}
							}
							//On click select unit
							if (mouseClicked) {
								unitSelected = unit;
								buildingSelected = null;
							}
						}
					}
				}
			}
			
			if (playerUnits.availableUnits().length == 0 && playerBuildings.availableBuildings().length == 0) {
				endTurn();
			}
		}
	}
	
}