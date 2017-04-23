package ludumdare38;
import kge.core.Basic;
import kge.core.Game;
import kge.core.Signal;
import kge.math.MathUtils;


class EnemyHandler extends Basic
{
	public var onTurnComplete:Signal = new Signal();
	public var onTurn:Bool;

	public var thinkingTime:Float;
	
	private var createZombies:Int;
	
	private var enemyUnits:UnitList;
	private var playerUnits:UnitList;
	private var playerBuildings:BuildingList;
	private var gameGrid:GameGrid;
	
	private var turnCount:Int;
	
	public function new(enemyUnits:UnitList, playerUnits:UnitList, playerBuildings:BuildingList, gameGrid:GameGrid) 
	{
		super();
		
		this.enemyUnits = enemyUnits;
		this.playerUnits = playerUnits;
		this.playerBuildings = playerBuildings;
		this.gameGrid = gameGrid;
	}
	
	public function startTurn() {
		onTurn = true;
		createZombies = Math.floor(MathUtils.clamp(Math.floor(turnCount / 5), turnCount > 2 ? 1 : 0, 15));
		if (turnCount % 2 != 0) {
			createZombies = Math.floor(createZombies / 2);
		}
		thinkingTime = 2;
		
		turnCount++;
		
		for (unit in enemyUnits.units) {
			unit.onStartTurn();
		}
	}
	
	public function addUnit(x:Int, y:Int, type:UnitType) {
		var unit:Unit = new Unit(type);
		var cell:GridCell = gameGrid.getCell(x, y);
		if (cell.hasUnit()) {
			cell.getUnit().kill();
		}
		cell.addUnit(unit);
		enemyUnits.addUnit(unit);
	}
	
	public function endTurn() {
		onTurn = false;
		onTurnComplete.dispatch();
		
		for (unit in enemyUnits.units) {
			unit.onEndTurn();
		}
	}
	
	override public function update() 
	{
		super.update();
		
		if(onTurn) {
			thinkingTime -= Game.deltaTime;
			if (thinkingTime < 0) {
				thinkingTime = 0.2;
				if (createZombies > 0) {
					var x = 0;
					var y = 0;
					if (Math.random() > 0.5) { //Vertical
						x = Math.random() > 0.5 ? 0 : MainState.GAMEGRID_WIDTH - 1;
						y = Math.floor(Math.random() * (MainState.GAMEGRID_HEIGHT - 1));
					} else { //Horizontal
						x = Math.floor(Math.random() * (MainState.GAMEGRID_WIDTH - 1));
						y = Math.random() > 0.5 ? 0 : MainState.GAMEGRID_HEIGHT - 1;						
					}
					addUnit(x, y, UnitType.ZOMBIE);
					createZombies--;
				} if (enemyUnits.availableUnits().length > 0) {
					var unit:Unit = enemyUnits.availableUnits().pop();
					var target:Building = playerBuildings.getBuildingByType(BuildingType.CASTLE)[0];
					if(target != null) {
						var targetCell:GridCell = target.cell;
						var cell = unit.cell;
						var deltaX:Int = targetCell.cellX != cell.cellX ? (targetCell.cellX - cell.cellX > 0 ? 1 : -1) : 0;
						var deltaY:Int = targetCell.cellY != cell.cellY ? (targetCell.cellY - cell.cellY > 0 ? 1 : -1) : 0;
						var nextCell = gameGrid.getCell(cell.cellX + deltaX, cell.cellY + deltaY);
						if(!nextCell.hasUnit() && !nextCell.hasBuilding() && unit.canMove) {
							gameGrid.moveUnit(unit, nextCell);
						} else if (nextCell.hasUnit() && unit.unitList != nextCell.getUnit().unitList && unit.canDoAction) {
							gameGrid.attackUnit(unit, nextCell.getUnit());
						} else if (nextCell.hasBuilding() && unit.canDoAction) {						
							gameGrid.attackBuilding(unit, nextCell.getBuilding());
						} else {
							unit.canMove = false;
							unit.canDoAction = false;
						}
					} else {
						unit.canMove = false;
						unit.canDoAction = false;
					}
				}
				else {
					endTurn();
				}
			}
		}
	}
	
}