package ludumdare38;

import kge.config.DefaultButtonStyle;
import kge.config.DefaultFontStyle;
import kge.core.Game;
import kge.core.Graphic;
import kge.core.State;
import kge.ui.Button;
import kge.ui.Text;
import kha.Assets;
import kha.audio1.AudioChannel;

class MenuState extends State
{
	var background:Graphic;
	
	var title:Text;
	var startButton:Button;
	var versusButton:Button;
	var helpButton:Button;
	var credits:Text;
	
	private static var audio:AudioChannel;
	
	public function new() 
	{
		super();
		
		playMainMusic();
		
		DefaultFontStyle.font = Assets.fonts.Anton;
		
		background = new Graphic(0, 0, Game.width, Game.height);
		background.setImage(Assets.images.MenuBackground);
		add(background);
		
		//title = new Text(0, 0, Game.width, Game.height * 0.5, GameTexts.GAME_TITLE);
		//title.fontSize = 100;
		//title.textVerticalAlign = TextVerticalAlign.MIDDLE;
		//title.textAlign = TextAlign.CENTER;
		//add(title);
		
		startButton = new Button(0, Game.height * 0.5, Game.width, Game.height * 0.1, GameTexts.GAME_START, MenuButtonStyle.instance);
		startButton.onClick.add(gotoMainState);
		add(startButton);
		
		versusButton = new Button(0, Game.height * 0.6, Game.width, Game.height * 0.1, GameTexts.GAME_VERSUS, MenuButtonStyle.instance);
		versusButton.onClick.add(gotoVersusMainState);
		add(versusButton);
		
		helpButton = new Button(0, Game.height * 0.7, Game.width, Game.height * 0.1, GameTexts.GAME_HELP, MenuButtonStyle.instance);
		helpButton.onClick.add(gotoHelpState);
		add(helpButton);
		
		credits = new Text(0, Game.height * 0.85, Game.width, Game.height * 0.15, GameTexts.GAME_CREDITS);
		credits.textVerticalAlign = TextVerticalAlign.BOTTOM;
		credits.textAlign = TextAlign.RIGHT;
		add(credits);
	}
	
	private function gotoMainState() {
		removeAll();
		Game.instance.changeState(new MainState());
	}
	
	private function gotoVersusMainState() {
		removeAll();
		Game.instance.changeState(new VersusMainState());
	}
	
	private function gotoHelpState() {
		removeAll();
		Game.instance.changeState(new HelpState());
	}
	
	private function removeAll() {
		startButton.onClick.removeAll();
		versusButton.onClick.removeAll();
		helpButton.onClick.removeAll();
	}
	
	private function playMainMusic() {
		if(audio == null) {
			audio = Game.audio.playSound(Assets.sounds.gameMusic, true);
			audio.volume = 0.03;
		}
	}
	
}