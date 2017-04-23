package;

import ludumdare38.MenuState;
import kge.core.Game;
import kge.core.State;

#if js
import js.Browser;
#end

class Main {
	private static var game:Game;
	private static var GAME_WIDTH:Int = 800;
	private static var GAME_HEIGHT:Int = 800;
	
	public static function main() {
		game = new Game(MenuState, GAME_WIDTH, GAME_HEIGHT);
	}
}