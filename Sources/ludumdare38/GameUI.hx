package ludumdare38;

import kge.core.Basic;
import kge.core.Game;
import kge.core.Graphic;
import kge.core.Group;
import kge.core.Signal;
import kge.ui.Button;
import kge.ui.Text;
import kha.Assets;
import kha.Color;

using tweenxcore.Tools;

class GameUI extends Group<Basic>
{

	private var turnText:Text;
	private var turnTween:Float = 0;
	
	private var skipButton:Button;
	
	private var resourceUI:Group<Basic>;
	private var woodText:Text;
	private var ironText:Text;
	private var peopleText:Text;
	private var woodNeededText:Text;
	private var ironNeededText:Text;
	private var peopleNeededText:Text;
	
	private var creationUI:Group<Basic>;
	
	public var playerHandler:PlayerHandler;
	
	public var onCreationClick:Signal = new Signal();
	public var onCreationOver:Signal = new Signal();
	public var onCreationOut:Signal = new Signal();
	
	public function new()
	{
		super();
		
		createTurnText();
		createSkipButton();
		createResourcesUI();
		createCreationUI();
	}
	
	public function setPlayerHandler(playerHandler:PlayerHandler) {
		this.playerHandler = playerHandler;
		skipButton.onClick.removeAll();
		skipButton.onClick.add(skipTurn);
	}
	
	private function skipTurn() {
		if(turnTween <= 0.5) {
			playerHandler.skipTurn();
		}
	}
	
	public function clearCreationList() {
		for (child in creationUI) {
			child.exists = false;
			child.visible = false;
		}
	}
	
	public function drawUnitCreationList(building:Building, alpha:Float = 1) {
		var list:Array<UnitType> = building.getCreationList();
		
		var cell:GridCell = building.cell;
		
		var buttonXOffset:Float = cell.x - GridCell.CELL_WIDTH * (list.length - 1) * 0.5;
		var buttonYOffset:Float = cell.y - GridCell.CELL_HEIGHT + (cell.cellY == 0 ? 128 : 0);
		if (buttonXOffset < 0) {
			buttonXOffset = 0;
		} else if (buttonXOffset + list.length * GridCell.CELL_WIDTH > Game.width) {
			buttonXOffset = Game.width - list.length * GridCell.CELL_WIDTH;
		}
		
		var i = 0;
		var button:Button;
		for (uType in list) {
			button = cast(creationUI.childrens[i], Button);
			button.exists = true;
			button.visible = true;
			button.alpha = alpha;
			button.x = buttonXOffset + i * GridCell.CELL_WIDTH;
			button.y = buttonYOffset;
			button.imageLabel.setImage(Unit.getTypeAsset(list[i]));
			i++;
		}
	}
	
	public function drawBuildingCreationList(unit:Unit, alpha:Float = 1) {
		var list:Array<BuildingType> = unit.getCreationList();
		
		var cell:GridCell = unit.cell;
		
		var buttonXOffset:Float = cell.x - GridCell.CELL_WIDTH * (list.length - 1) * 0.5;
		var buttonYOffset:Float = cell.y - GridCell.CELL_HEIGHT + (cell.cellY == 0 ? 128 : 0);
		if (buttonXOffset < 0) {
			buttonXOffset = 0;
		} else if (buttonXOffset + list.length * GridCell.CELL_WIDTH > Game.width) {
			buttonXOffset = Game.width - list.length * GridCell.CELL_WIDTH;
		}
		
		var i = 0;
		var button:Button;
		for (uType in list) {
			button = cast(creationUI.childrens[i], Button);
			button.exists = true;
			button.visible = true;
			button.alpha = alpha;
			button.x = buttonXOffset + i * GridCell.CELL_WIDTH;
			button.y = buttonYOffset;
			button.imageLabel.setImage(Building.getTypeAsset(list[i]));
			i++;
		}
	}
	
	private function createTurnText() {
		turnText = new Text(0, 0, Game.width, Game.height);
		turnText.fontSize = 100;
		turnText.textVerticalAlign = TextVerticalAlign.MIDDLE;
		turnText.textAlign = TextAlign.CENTER;
		turnText.alpha = 0;
		add(turnText);
	}
	
	private function createSkipButton() {
		skipButton = new Button(0, 0, 96, 96, GameTexts.GAME_UI_SKIP, MenuButtonStyle.instance);
		skipButton.text.fontSize = 45;
		skipButton.text.y = -16;
		add(skipButton);
	}
	
	private function createResourcesUI() {
		resourceUI = new Group();
		resourceUI.x = 96;
		add(resourceUI);
		
		var background:Graphic = new Graphic(0, 0, Game.width - resourceUI.x, 96);
		background.color = Color.fromFloats(0.5, 0.4, 0);
		background.setRectangle(background.width, background.height);
		resourceUI.add(background);
		
		woodText = new Text(resourceUI.x + 64, 0, Game.width, 32, "");
		add(woodText);
		ironText = new Text(resourceUI.x + 64, 32, Game.width, 32, "");
		add(ironText);
		peopleText = new Text(resourceUI.x + 64, 64, Game.width, 32, "");
		add(peopleText);
		
		woodNeededText = new Text(resourceUI.x + 320, 0, Game.width, 32, "");
		add(woodNeededText);
		ironNeededText = new Text(resourceUI.x + 320, 32, Game.width, 32, "");
		add(ironNeededText);
		peopleNeededText = new Text(resourceUI.x + 320, 64, Game.width, 32, "");
		add(peopleNeededText);
	}
	
	public function refreshResources(resources:Resources) {
		woodText.text = GameTexts.GAME_UI_WOOD + ": " + Math.floor(resources.wood);
		ironText.text = GameTexts.GAME_UI_IRON + ": " + Math.floor(resources.iron);
		peopleText.text = GameTexts.GAME_UI_PEOPLE + ": " + Math.floor(resources.people);
	}
	
	public function refreshResourcesNeeded(resources:Resources, playerResources:Resources) {
		woodNeededText.text = resources.wood > 0 ? "-" + Math.floor(resources.wood) : "";
		woodNeededText.color = playerResources.wood >= resources.wood ? Color.Green : Color.Red;
		ironNeededText.text = resources.iron > 0 ? "-" + Math.floor(resources.iron) : "";
		ironNeededText.color = playerResources.iron >= resources.iron ? Color.Green : Color.Red;
		peopleNeededText.text = resources.people > 0 ? "-" + Math.floor(resources.people) : "";
		peopleNeededText.color = playerResources.people >= resources.people ? Color.Green : Color.Red;
	}
	
	private function createCreationUI() {
		creationUI = new Group();
		add(creationUI);
		
		var button:Button;
		for(i in 0...10) {
			button = new Button(0, 0, GridCell.CELL_WIDTH, GridCell.CELL_HEIGHT, "", MenuButtonStyle.instance);
			button.exists = false;
			button.visible = false;
			button.onClick.add(onCreationClick.dispatch.bind(i));
			button.onOver.add(onCreationOver.dispatch.bind(i));
			button.onOut.add(onCreationOut.dispatch.bind(i));
			creationUI.add(button);
		}
	}
	
	private function getUnitLetter(unitType:UnitType) {
		switch (unitType) 
		{
			case UnitType.BUILDER:
				return "B";
			case UnitType.ARCHER:
				return "A";
			case UnitType.LANCER:
				return "L";
			default:
				return "";
		}
	}
	
	private function getBuildingLetter(buildingType:BuildingType) {
		switch (buildingType) 
		{
			case BuildingType.HOUSE:
				return "H";
			case BuildingType.LUMBERMILL:
				return "L";
			case BuildingType.MINE:
				return "M";
			case BuildingType.BARRACK:
				return "B";
			case BuildingType.WALL:
				return "W";
			default:
				return "";
		}
	}
	
	public function turnStartText(text:String) {
		turnText.text = text;
		turnTween = 1.5;
	}
	
	override public function update() 
	{
		super.update();
		
		if (turnTween >= 0) {
			turnTween = Math.max(turnTween - Game.deltaTime, 0);
			turnText.alpha = turnTween < 1 ? turnTween.quadIn().lerp(0, 1) : 1;
		}
	}
	
}