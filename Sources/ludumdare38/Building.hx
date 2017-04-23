package ludumdare38;
import kge.core.Graphic;
import kge.core.Signal;
import kha.Assets;
import kha.Color;


class Building 
{
	public var health(get, null):Float;
	private var _health:Float;
	private var maxHealth:Float;
	
	public var cell:GridCell;
	
	public var canBeUsed:Bool;
	
	public var graphic:Graphic;
	public var healthBar:Graphic;
	
	public var type:BuildingType;
	
	public var playerHandler:PlayerHandler;
	
	public var buildingList:BuildingList;
	
	public var onDestroy:Signal = new Signal();
	
	public function new(buildingType:BuildingType, playerHandler:PlayerHandler) 
	{
		type = buildingType;
		
		this.playerHandler = playerHandler;
		
		graphic = new Graphic(0, 0, GridCell.CELL_WIDTH, GridCell.CELL_HEIGHT);
		refreshBuildingType();
		
		healthBar = new Graphic(1, GridCell.CELL_HEIGHT * 0.9 - 1, GridCell.CELL_WIDTH - 2, GridCell.CELL_HEIGHT * 0.1);
		healthBar.color = Color.Green;
	}
	
	public function onStartTurn() { 
		canBeUsed = type == BuildingType.CASTLE || type == BuildingType.BARRACK;
		playerHandler.addResources(resourceGeneratedBuilding(type));
	}
	
	public function pointOver(x:Float, y:Float) {
		return cell.pointOver(x, y);
	}
	
	private function refreshBuildingType() {
		switch (type) 
		{
			case BuildingType.CASTLE:
				maxHealth = 5;
				graphic.setImage(Assets.images.Castle);
			case BuildingType.HOUSE:
				maxHealth = 2;
				graphic.setImage(Assets.images.House);
			case BuildingType.LUMBERMILL:
				maxHealth = 2;
				graphic.setImage(Assets.images.Lumbermill);
			case BuildingType.MINE:
				maxHealth = 2;
				graphic.setImage(Assets.images.Mine);
			case BuildingType.BARRACK:
				maxHealth = 3;
				graphic.setImage(Assets.images.Barrack);
			case BuildingType.WALL:
				maxHealth = 4;
				graphic.setImage(Assets.images.Wall);
			default:
				
		}
		_health = maxHealth;
	}
	
	public function getCreationList():Array<UnitType> {
		var temp:Array<UnitType>;
		switch (type) 
		{
			case BuildingType.CASTLE:
				temp = [UnitType.BUILDER, UnitType.LANCER, UnitType.ARCHER];
			case BuildingType.BARRACK:
				temp = [UnitType.LANCER, UnitType.ARCHER];
			default:
				temp = [];
		}
		return temp;
	}
	
	public function get_health():Float {
		return _health;
	}
	
	public function hit(damage:Float) {
		_health -= damage;
		healthBar.setRectangle((_health / maxHealth) * (GridCell.CELL_WIDTH - 2), healthBar.height);
		if (health <= 0) {
			kill();
		}
	}
	
	public function kill() {		
		buildingList.removeBuilding(this);
		cell.removeBuilding();
		onDestroy.dispatch();
	}
	
	public static function resourceNeededBuilding(buildingType:BuildingType):Resources {
		switch (buildingType) 
		{
			case BuildingType.CASTLE:
				return {wood: 0, iron: 0, people: 0};
			case BuildingType.HOUSE:
				return {wood: 10, iron: 0, people: 0};
			case BuildingType.LUMBERMILL:
				return {wood: 5, iron: 10, people: 3};
			case BuildingType.MINE:
				return {wood: 10, iron: 5, people: 3};
			case BuildingType.BARRACK:
				return {wood: 20, iron: 5, people: 0};
			case BuildingType.WALL:
				return {wood: 40, iron: 10, people: 0};
			default:
				return {wood: 0, iron: 0, people: 0};
		}
	}
	
	public static function requiredCellType(buildingType:BuildingType):CellType {
		switch (buildingType) 
		{
			case BuildingType.CASTLE:
				return CellType.NONE;
			case BuildingType.HOUSE:
				return CellType.GRASS;
			case BuildingType.LUMBERMILL:
				return CellType.FOREST;
			case BuildingType.MINE:
				return CellType.CAVE;
			case BuildingType.BARRACK:
				return CellType.GRASS;
			case BuildingType.WALL:
				return CellType.NONE;
			default:
				return CellType.NONE;
		}
	}
	
	public static function getTypeAsset(type:BuildingType) {
		switch (type) 
		{
			case BuildingType.CASTLE:
				return Assets.images.Castle;
			case BuildingType.HOUSE:
				return Assets.images.House;
			case BuildingType.LUMBERMILL:
				return Assets.images.Lumbermill_Icon;
			case BuildingType.MINE:
				return Assets.images.Mine_Icon;
			case BuildingType.BARRACK:
				return Assets.images.Barrack;
			case BuildingType.WALL:
				return Assets.images.Wall;
			default:
				return Assets.images.Castle;
		}		
	}
	
	public static function resourceGeneratedBuilding(buildingType:BuildingType):Resources {
		switch (buildingType) 
		{
			case BuildingType.CASTLE:
				return {wood: 5, iron: 5, people: 0.35};
			case BuildingType.HOUSE:
				return {wood: 0, iron: 0, people: 0.35};
			case BuildingType.LUMBERMILL:
				return {wood: 10, iron: 0, people: 0};
			case BuildingType.MINE:
				return {wood: 0, iron: 10, people: 0};
			default:
				return {wood: 0, iron: 0, people: 0};
		}
	}
	
}