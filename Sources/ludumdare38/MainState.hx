package ludumdare38;

import kge.core.AudioManager;
import kge.core.Game;
import kge.core.Graphic;
import kge.core.State;
import kge.ui.Button;
import kge.ui.Text;
import kha.Assets;
import kha.Color;
import kha.Sound;

class MainState extends State 
{
	public static var GAMEGRID_WIDTH:Int = 11;
	public static var GAMEGRID_HEIGHT:Int = 11;
	
	private static var BACKGROUND_COLOR:Color = Color.fromBytes(45, 183, 89);
	
	private var gameGrid:GameGrid;
	private var gameUI:GameUI;
	private var playerUnits:UnitList;
	private var enemyUnits:UnitList;
	private var playerBuildings:BuildingList;
	private var playerHandler:PlayerHandler;
	private var enemyHandler:EnemyHandler;
	
	private var gameTurns:Int = 0;
	private var castle:Building;
	
	public function new() 
	{
		super();
		
		var background:Graphic = new Graphic(0, 0, Game.width, Game.height);
		background.color = BACKGROUND_COLOR;
		
		gameGrid = new GameGrid(GAMEGRID_WIDTH, GAMEGRID_HEIGHT);
		gameUI = new GameUI();
		
		playerUnits = new UnitList();
		playerBuildings = new BuildingList();
		
		enemyUnits = new UnitList();
		
		playerHandler = new PlayerHandler(playerUnits, playerBuildings, gameGrid, gameUI);
		gameUI.setPlayerHandler(playerHandler);
		
		enemyHandler = new EnemyHandler(enemyUnits, playerUnits, playerBuildings, gameGrid);
		
		playerHandler.onTurnComplete.add(startEnemyTurn);
		enemyHandler.onTurnComplete.add(startPlayerTurn);
		
		createCastle();
		
		add(background);
		add(playerHandler);
		add(enemyHandler);
		add(gameGrid);
		add(gameUI);
		
		startPlayerTurn();
	}
	
	private function createCastle() {
		playerHandler.addBuilding(Math.floor(GAMEGRID_WIDTH * 0.5), Math.floor(GAMEGRID_HEIGHT * 0.5), BuildingType.CASTLE);
		castle = playerBuildings.getBuildingByType(BuildingType.CASTLE)[0];
		castle.onDestroy.add(endGameSurvival);
	}
	
	private function endGameSurvival() {
		playerHandler.onTurnComplete.remove(startEnemyTurn);
		enemyHandler.onTurnComplete.remove(startPlayerTurn);
		
		castle.onDestroy.removeAll();
		Game.instance.changeState(new GameEndState(GameTexts.GAME_END_SURVIVAL_PREFIX + gameTurns + GameTexts.GAME_END_SURVIVAL_POSTFIX));
	}
	
	private function startPlayerTurn() {
		trace("PLAYER TURN");
		gameTurns++;
		playerHandler.startTurn();
		gameUI.turnStartText(GameTexts.TURN_PLAYER);
	}
	
	private function startEnemyTurn() {
		trace("ENEMY TURN");
		enemyHandler.startTurn();
		gameUI.turnStartText(GameTexts.TURN_ENEMY);
	}
	
	override public function update() 
	{	
		super.update();
	}
	
}