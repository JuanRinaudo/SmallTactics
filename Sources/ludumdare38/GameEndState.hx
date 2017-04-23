package ludumdare38;
import kge.core.State;

import kge.config.DefaultButtonStyle;
import kge.config.DefaultFontStyle;
import kge.core.Game;
import kge.core.Graphic;
import kge.core.State;
import kge.ui.Button;
import kge.ui.Text;
import kha.Assets;

class GameEndState extends State
{
	var background:Graphic;
	var title:Text;
	
	var menuButton:Button;

	public function new(text:String) 
	{
		super();
		
		background = new Graphic(0, 0, Game.width, Game.height);
		background.setImage(Assets.images.MenuBackground);
		add(background);
		
		title = new Text(0, Game.height * 0.4, Game.width, Game.height * 0.5, text);
		title.fontSize = 100;
		title.lineHeight = 100;
		title.textVerticalAlign = TextVerticalAlign.MIDDLE;
		title.textAlign = TextAlign.CENTER;
		add(title);
		
		menuButton = new Button(0, Game.height * 0.3, Game.width, Game.height * 0.1, GameTexts.GAME_MENU, MenuButtonStyle.instance);
		menuButton.onClick.add(gotoMenuState);
		add(menuButton);
	}
	
	private function gotoMenuState() {
		menuButton.onClick.removeAll();
		Game.instance.changeState(new MenuState());
	}
	
}