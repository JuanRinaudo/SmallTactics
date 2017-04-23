package ludumdare38;

import kge.core.Graphic;
import kge.core.Group;
import kha.Assets;
import kha.Color;
import kha.Image;
import kha.math.Vector2;

class Unit 
{
	public var health(get, null):Float;
	private var _health:Float;
	private var maxHealth:Float;
	
	public var cell:GridCell;
	
	public var damage:Float;
	public var attackRange:Float;
	public var movementRange:Float;
	
	public var canMove(default, set):Bool;
	public var canDoAction(default, set):Bool;
	
	public var humanSprite:Graphic;
	public var typeSprite:Graphic;
	public var healthBar:Graphic;
	
	public var type:UnitType;
	
	public var unitList:UnitList;
	
	public function new(unitType:UnitType) 
	{
		var offsetX:Float = Math.random() * 8 - 4;
		var offsetY:Float = Math.random() * 8 - 4;
		humanSprite = new Graphic(offsetX, offsetY, GridCell.CELL_WIDTH, GridCell.CELL_HEIGHT);
		
		typeSprite = new Graphic(offsetX, offsetY, GridCell.CELL_WIDTH, GridCell.CELL_HEIGHT);
		
		healthBar = new Graphic(1, 1, GridCell.CELL_WIDTH - 2, GridCell.CELL_HEIGHT * 0.1);
		healthBar.color = Color.Green;
		
		type = unitType;
		refreshUnitType();
		
		canMove = false;
		canDoAction = false;
	}
	
	private function getRandomSprite():Image {
		var humanAssets:Array<Image> = [Assets.images.Human1, Assets.images.Human2, Assets.images.Human3, Assets.images.Human4];
		return humanAssets[Math.floor(humanAssets.length * Math.random())];
	}
	
	public function onStartTurn() {
		canMove = true;
		canDoAction = true;
	}
	
	public function onEndTurn() {
		canDoAction = true;
	}
	
	private function refreshUnitType() {
		humanSprite.setImage(getRandomSprite());
		switch (type) 
		{
			case UnitType.BUILDER:
				maxHealth = 1;
				movementRange = 3;
				damage = 0;
				attackRange = 0;
				typeSprite.setImage(Assets.images.Builder);
			case UnitType.LANCER:
				maxHealth = 5;
				movementRange = 3;
				damage = 2;
				attackRange = 1.5;
				typeSprite.setImage(Assets.images.Lancer);
			case UnitType.ARCHER:
				maxHealth = 5;
				movementRange = 2;
				damage = 1;
				attackRange = 3;
				typeSprite.setImage(Assets.images.Archer);
			case UnitType.ZOMBIE:
				maxHealth = 3;
				damage = 1;
				movementRange = 2;
				attackRange = 1.5;
				typeSprite.setImage(Assets.images.Zombie);
			default:
				
		}
		_health = maxHealth;
	}
	
	public function getCreationList():Array<BuildingType> {
		var temp:Array<BuildingType>;
		switch (type) 
		{
			case UnitType.BUILDER:
				temp = [BuildingType.LUMBERMILL, BuildingType.MINE, BuildingType.HOUSE, BuildingType.BARRACK, BuildingType.WALL];
			default:
				temp = [];
		}
		return temp;
	}
	
	public function isAlive():Bool {
		return _health > 0;
	}
	
	public function hit(damage:Float) {
		_health -= damage;
		healthBar.setRectangle((_health / maxHealth) * (GridCell.CELL_WIDTH - 2), healthBar.height);
		if (health <= 0) {
			kill();
		}
	}
	
	public function kill() {		
		unitList.removeUnit(this);
		cell.removeUnit();
	}
	
	public function pointOver(x:Float, y:Float) {
		return cell.pointOver(x, y);
	}
	
	public function get_health():Float {
		return _health;
	}
	
	public static function resourceNeededUnit(unitType:UnitType):Resources {
		switch (unitType) 
		{
			case UnitType.BUILDER:
				return {wood: 10, iron: 10, people: 1};
			case UnitType.ARCHER:
				return {wood: 40, iron: 10, people: 1};
			case UnitType.LANCER:
				return {wood: 10, iron: 30, people: 1};
			default:
				return {wood: 0, iron: 0, people: 0};
		}
	}
	
	public static function getTypeAsset(type:UnitType) {
		switch (type) 
		{
			case UnitType.BUILDER:
				return Assets.images.Builder;
			case UnitType.LANCER:
				return Assets.images.Lancer;
			case UnitType.ARCHER:
				return Assets.images.Archer;
			default:
				return Assets.images.Builder;
		}		
	}
	
	private function refreshAlpha() {
		humanSprite.alpha = typeSprite.alpha = (canMove || canDoAction ? 1 : 0.5);
	}
	
	public function set_canMove(value:Bool):Bool {
		canMove = value;
		refreshAlpha();
		return canMove;
	}
	
	public function set_canDoAction(value:Bool):Bool {
		canDoAction = value;
		refreshAlpha();
		return canDoAction;
	}
	
}