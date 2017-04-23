package ludumdare38;

import kge.core.Basic;
import kge.core.Graphic;
import kge.core.Group;
import kha.Assets;
import kha.Color;
import kha.Image;

class GridCell extends Group<Basic>
{
	public static var CELL_WIDTH:Int = 64;
	public static var CELL_HEIGHT:Int = 64;
	
	private var cellBackground:Graphic;
	private var cellSprite:Graphic;
	private var cellOverlaySprite:Graphic;
	
	public var cellType:CellType;
	public var cellOverlay:CellType;
	
	private var cellUnit:Unit;
	private var cellBuilding:Building;
	
	public var cellX:Int;
	public var cellY:Int;
	
	public function new(cellType:CellType, x:Int, y:Int) 
	{
		super();
		
		cellBackground = new Graphic(0, 0, CELL_WIDTH, CELL_HEIGHT);
		cellBackground.setCustomDrawFunction(drawTile.bind(_));
		add(cellBackground);
		
		cellSprite = new Graphic(0, 0, CELL_WIDTH, CELL_HEIGHT);
		add(cellSprite);
		
		cellOverlaySprite = new Graphic(0, 0, CELL_WIDTH, CELL_HEIGHT);
		cellOverlaySprite.setCustomDrawFunction(drawOverlay.bind(_));
		add(cellOverlaySprite);
		
		changeType(cellType);
		this.cellOverlay = CellType.NONE;
		this.cellX = x;
		this.cellY = y;
	}
	
	public function addUnit(unit:Unit) {
		addAt(unit.humanSprite, 4);
		addAt(unit.typeSprite, 5);
		addAt(unit.healthBar, 6);
		unit.cell = this;
		cellUnit = unit;
	}
	
	public function removeUnit() {
		remove(cellUnit.humanSprite);
		remove(cellUnit.typeSprite);
		remove(cellUnit.healthBar);
		cellUnit.cell = null;
		cellUnit = null;
	}
	
	public function addBuilding(building:Building) {
		addAt(building.graphic, 2);
		addAt(building.healthBar, 3);
		building.cell = this;
		cellBuilding = building;
	}
	
	public function removeBuilding() {
		remove(cellBuilding.graphic);
		remove(cellBuilding.healthBar);
		cellBuilding.cell = null;
		cellBuilding = null;
	}
	
	public function hasUnit():Bool {
		return cellUnit != null;
	}
	
	public function getUnit():Unit {
		return cellUnit;
	}
	
	public function hasBuilding():Bool {
		return cellBuilding != null;
	}
	
	public function getBuilding():Building {
		return cellBuilding;
	}
	
	public function changeType(cellType:CellType) {
		this.cellType = cellType;
		refreshCellSprite();
	}
	
	public function changeOverlay(cellOverlay:CellType) {
		this.cellOverlay = cellOverlay;
	}
	
	private function drawTile(framebuffer:Image) {		
		var cellColor:Color;
		
		switch (cellType) 
		{
			case CellType.GRASS:
				cellColor = Color.fromFloats(0.3, 0.6, 0.4);
			case CellType.CAVE:
				cellColor = Color.fromFloats(0.5, 0.5, 0.5);
			case CellType.FOREST:
				cellColor = Color.fromFloats(0.8, 0.5, 0);
			default:
				return;
		}
		
		//Back
		framebuffer.g2.color = Color.Black;
		framebuffer.g2.fillRect(0, 0, CELL_WIDTH, CELL_HEIGHT);
		
		//Cell color
		framebuffer.g2.color = cellColor;
		framebuffer.g2.fillRect(1, 1, CELL_WIDTH - 2, CELL_HEIGHT - 2);
	}
	
	private function refreshCellSprite() {
		switch (cellType) 
		{
			case CellType.GRASS:
				var grassAssets:Array<Image> = [Assets.images.Grass1, Assets.images.Grass2, Assets.images.Grass3, Assets.images.Grass4];
				cellSprite.setImage(grassAssets[Math.floor(grassAssets.length * Math.random())]);
			case CellType.CAVE:
				cellSprite.setImage(Assets.images.Cave);
			case CellType.FOREST:
				cellSprite.setImage(Assets.images.Forest);
			default:
				return;
		}
	}
	
	private function drawOverlay(framebuffer:Image) {	
		var overlayColor:Color;
		
		switch (cellOverlay) 
		{
			case CellType.MOVEMENT:
				overlayColor = Color.fromFloats(0, 0.8, 0, 0.5);
			case CellType.ATTACK:
				overlayColor = Color.fromFloats(0.8, 0, 0, 0.5);
			default:
				overlayColor = Color.fromFloats(0, 0, 0, 0);
		}
		
		//Overlay
		framebuffer.g2.color = overlayColor;
		framebuffer.g2.fillRect(0, 0, CELL_WIDTH, CELL_HEIGHT);
	}
	
	public function pointOver(x:Float, y:Float) {
		return x > this.x && x < this.x + CELL_WIDTH && y > this.y && y < this.y + CELL_HEIGHT;
	}
	
}