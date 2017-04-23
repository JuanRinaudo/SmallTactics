package ludumdare38;

import kge.core.Game;
import kge.core.Graphic;
import kge.core.State;
import kge.ui.Button;
import kge.ui.Text;
import kha.Color;

class VersusMainState extends State 
{
	private static var GAMEGRID_WIDTH:Int = 11;
	private static var GAMEGRID_HEIGHT:Int = 11;
	
	private static var BACKGROUND_COLOR:Color = Color.fromBytes(45, 183, 89);
	
	private var gameGrid:GameGrid;
	private var gameUI:GameUI;
	private var player1Units:UnitList;
	private var player1Buildings:BuildingList;
	private var player2Units:UnitList;
	private var player2Buildings:BuildingList;
	private var player1Handler:PlayerHandler;
	private var player2Handler:PlayerHandler;
	
	private var castle1:Building;
	private var castle2:Building;
	
	public function new() 
	{
		super();
		
		var background:Graphic = new Graphic(0, 0, Game.width, Game.height);
		background.color = BACKGROUND_COLOR;
		
		gameGrid = new GameGrid(GAMEGRID_WIDTH, GAMEGRID_HEIGHT, true);
		gameUI = new GameUI();
		
		player1Units = new UnitList();
		player1Buildings = new BuildingList();
		
		player2Units = new UnitList();
		player2Buildings = new BuildingList();
		
		player1Handler = new PlayerHandler(player1Units, player1Buildings, gameGrid, gameUI);
		player2Handler = new PlayerHandler(player2Units, player2Buildings, gameGrid, gameUI);
		
		player1Handler.onTurnComplete.add(startPlayer2Turn);
		player2Handler.onTurnComplete.add(startPlayer1Turn);
		
		createCastle();
		
		add(background);
		add(player1Handler);
		add(player2Handler);
		add(gameGrid);
		add(gameUI);
		
		startPlayer1Turn();
	}
	
	private function createCastle() {
		player1Handler.addBuilding(0, 0, BuildingType.CASTLE);
		castle1 = player1Buildings.getBuildingByType(BuildingType.CASTLE)[0];
		castle1.onDestroy.add(endGameVersus.bind(GameTexts.GAME_END_PLAYER1_WON));
		player2Handler.addBuilding(GAMEGRID_WIDTH - 1, GAMEGRID_HEIGHT - 1, BuildingType.CASTLE);
		castle2 = player2Buildings.getBuildingByType(BuildingType.CASTLE)[0];
		castle2.onDestroy.add(endGameVersus.bind(GameTexts.GAME_END_PLAYER1_WON));
	}
	
	private function endGameVersus(text:String) {
		player1Handler.onTurnComplete.remove(startPlayer2Turn);
		player2Handler.onTurnComplete.remove(startPlayer1Turn);
		
		castle1.onDestroy.removeAll();
		castle2.onDestroy.removeAll();
		Game.instance.changeState(new GameEndState(text));
	}
	
	private function startPlayer1Turn() {
		trace("PLAYER 1 TURN");
		player1Handler.startTurn();
		gameUI.turnStartText(GameTexts.TURN_PLAYER_1);
		gameUI.setPlayerHandler(player1Handler);
	}
	
	private function startPlayer2Turn() {
		trace("PLAYER 2 TURN");
		player2Handler.startTurn();
		gameUI.turnStartText(GameTexts.TURN_PLAYER_2);
		gameUI.setPlayerHandler(player2Handler);
	}
	
	override public function update() 
	{	
		super.update();
	}
	
}