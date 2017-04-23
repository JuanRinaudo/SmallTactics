package ludumdare38;

import kge.core.Basic;
import kge.core.Game;
import kge.core.Group;
import kha.math.Vector2;

typedef CellTypeChance = {type: CellType, chance:Float};

class GameGrid extends Group<Basic>
{
	private var grid:Group<GridCell>;
	
	private var gridWidth:Int;
	private var gridHeight:Int;
	private var xOffset:Float;
	private var yOffset:Float;
	
	private var tileTypeGenerators:Array<CellTypeChance> = [];
	private var totalChance:Float;
	
	public function new(gridWidth:Int, gridHeight:Int, mirror:Bool = false) 
	{
		super();
		
		grid = new Group();
		add(grid);
		
		this.gridWidth = gridWidth;
		this.gridHeight = gridHeight;
		
		xOffset = (Game.width - gridWidth * GridCell.CELL_WIDTH) * 0.5;
		yOffset = Game.height - gridHeight * GridCell.CELL_HEIGHT;
		
		addCellType(CellType.GRASS, 60);
		addCellType(CellType.CAVE, 20);
		addCellType(CellType.FOREST, 20);
		
		if (mirror) {
			createMirrorGrid();
		} else {
			createRandomGrid();
		}
	}
	
	private function createMirrorGrid() {
		var cell:GridCell;
		var grassOnly:Bool;
		for (i in 0...gridWidth) {
			for (j in 0...gridHeight) {
				grassOnly = i == 0 || i == gridWidth - 1 || j == 0 || j == gridHeight - 1 || (i == Math.floor(gridWidth * 0.5) && j == Math.floor(gridHeight * 0.5));
				cell = new GridCell(grassOnly ? CellType.GRASS : getCellType(), i, j);
				cell.x = i * GridCell.CELL_WIDTH + xOffset;
				cell.y = j * GridCell.CELL_HEIGHT + yOffset;
				grid.add(cell);
			}
		}
		
		for (j in 0...gridHeight) {
			for (i in (gridWidth - j)...gridWidth) {
				trace(i, j);
				trace(getCell(i, j).cellType + " " + getCell(j, i).cellType);
				getCell(i, j).changeType(getCell(gridWidth - 1 - i, gridHeight - 1 - j).cellType);
				trace(getCell(i, j).cellType + " " + getCell(j, i).cellType);
			}
		}
	}
	
	private function createRandomGrid() {
		var cell:GridCell;
		var grassOnly:Bool;
		for (x in 0...gridWidth) {
			for (y in 0...gridHeight) {
				grassOnly = x == 0 || x == gridWidth - 1 || y == 0 || y == gridHeight - 1 || (x == Math.floor(gridWidth * 0.5) && x == Math.floor(gridHeight * 0.5));
				cell = new GridCell(grassOnly ? CellType.GRASS : getCellType(), x, y);
				cell.x = x * GridCell.CELL_WIDTH + xOffset;
				cell.y = y * GridCell.CELL_HEIGHT + yOffset;
				grid.add(cell);
			}
		}
	}
	
	public function addCellType(type:CellType, chance:Float) {
		tileTypeGenerators.push({type: type, chance: chance});
		totalChance += chance;
	}
	
	public function getCellType():CellType {
		var random:Float = Math.random() * totalChance;
		var i = 0;
		while (random - tileTypeGenerators[i].chance > 0) {
			random -= tileTypeGenerators[i].chance;
			i++;
		}
		return tileTypeGenerators[i].type;
	}
	
	public function getCell(x:Int, y:Int) {
		return grid.childrens[x * gridHeight + y];
	}
	
	public function screenPosToGridPos(x:Float, y:Float):Vector2 {
		return new Vector2(Math.floor((x - xOffset) / GridCell.CELL_WIDTH), Math.floor((y - yOffset) / GridCell.CELL_HEIGHT));
	}
	
	public function moveUnit(unit:Unit, to:GridCell) {
		if(unit.canMove && checkUnitDistanceToCell(unit, to, unit.movementRange)) {
			unit.cell.removeUnit();
			unit.canMove = false;
			to.addUnit(unit);
		}
	}
	
	public function attackUnit(unit:Unit, targetUnit:Unit) {
		if (unit.canDoAction && unit.unitList != targetUnit.unitList && checkUnitDistanceToCell(unit, targetUnit.cell, unit.attackRange)) {
			unit.canDoAction = false;
			targetUnit.hit(unit.damage);
			if (targetUnit.isAlive()) {
				attackUnit(targetUnit, unit);
			}
		}
	}
	
	public function attackBuilding(unit:Unit, building:Building) {
		if (unit.canDoAction && unit.unitList != building.playerHandler.playerUnits && checkUnitDistanceToCell(unit, building.cell, unit.attackRange)) {
			unit.canDoAction = false;
			building.hit(unit.damage);
		}
	}
	
	public function clearOverlay() {
		for (cell in grid) {
			cell.changeOverlay(CellType.NONE);
		}
	}
	
	public function drawMovementOverlay(unit:Unit) {
		for (cell in getCellsInReach(grid, unit.cell.cellX, unit.cell.cellY, unit.movementRange)) {
			cell.changeOverlay(CellType.MOVEMENT);
		}
	}
	
	public function drawAttackOverlay(unit:Unit) {
		for (cell in getCellsInReach(grid, unit.cell.cellX, unit.cell.cellY, unit.attackRange)) {
			cell.changeOverlay(CellType.ATTACK);
		}
	}
	
	private function getCellsInReach(cells:Group<GridCell>, x:Int, y:Int, reach:Float) {
		var temp:Array<GridCell> = [];
		for (cell in cells) {
			if(checkDistanceToCell(x, y, cell, reach)) { temp.push(cell); }
		}
		return temp;
	}
	
	private inline function distanceSquaredToCell(x:Int, y:Int, cell:GridCell) {
		var dx = cell.cellX - x;
		var dy = cell.cellY - y;
		return dx * dx + dy * dy;
	}
	
	private inline function checkDistanceToCell(x:Int, y:Int, cell:GridCell, reach:Float) {
		return distanceSquaredToCell(x, y, cell) <= reach * reach;
	}
	
	private inline function checkUnitDistanceToCell(unit:Unit, cell:GridCell, reach:Float) {
		return distanceSquaredToCell(unit.cell.cellX, unit.cell.cellY, cell) <= reach * reach;
	}
	
}