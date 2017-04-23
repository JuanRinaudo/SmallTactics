package ludumdare38;

import kge.core.Basic;
import kge.core.Game;
import kge.core.Graphic;
import kge.core.Group;
import kge.core.State;
import kge.ui.Button;
import kge.ui.Text;
import kha.Assets;
import kha.Color;
import kha.Image;


class HelpState extends State 
{
	var background:Graphic;
	var pages:Group<Group<Basic>>;
	
	var backButton:Button;
	var nextPageButton:Button;
	var prevPageButton:Button;

	var pageIndex:Int = 0;
	
	public function new() 
	{
		super();
		
		background = new Graphic(0, 0, Game.width, Game.height);
		background.setImage(Assets.images.MenuBackground);
		add(background);
		
		var pageBackground:Graphic = new Graphic(Game.width * 0.05, Game.height * 0.05, Game.width * 0.9, Game.height * 0.9);
		pageBackground.color = Color.fromFloats(0.9, 0.9, 0.8);
		add(pageBackground);
		
		pages = new Group();
		add(pages);
		
		createBasicsPage();
		createUnits();
		createBuildings();
		
		backButton = new Button(Game.width * 0.05, Game.height * 0.05, Game.width * 0.1, Game.height * 0.1, "X", MenuButtonStyle.instance);
		backButton.onClick.add(gotoMainState);
		add(backButton);
		
		prevPageButton = new Button(Game.width * 0, Game.height * 0.45, Game.width * 0.1, Game.height * 0.1, "<", MenuButtonStyle.instance);
		prevPageButton.onClick.add(gotoPreviusPage);
		add(prevPageButton);
		
		nextPageButton = new Button(Game.width - Game.width * 0.1, Game.height * 0.45, Game.width * 0.1, Game.height * 0.1, ">", MenuButtonStyle.instance);
		nextPageButton.onClick.add(gotoNextPage);
		add(nextPageButton);
		
		showPage();
	}
	
	private function gotoPreviusPage() {
		pageIndex = pageIndex - 1;
		if (pageIndex < 0) { pageIndex = pages.childrens.length - 1; };
		showPage();
	}
	
	private function gotoNextPage() {
		pageIndex = pageIndex + 1;
		if (pageIndex > pages.childrens.length - 1) { pageIndex = 0; };
		showPage();
	}
	
	private function showPage() {
		var i = 0;
		for (page in pages.childrens) {
			page.exists = page.visible = pageIndex == i;
			i++;
		}
	}
	
	private function createBasicsPage() {
		var page:Group<Basic> = new Group();
		
		pageAddTitle(page, GameTexts.HELP_BASICS_TITLE);
		pageAddText(page, Game.width * 0.15, Game.height * 0.1, Game.width * 0.7, Game.height * 0.2, GameTexts.HELP_BASIC_UNITS);
		pageAddImage(page, Game.width * 0.15, Game.height * 0.35, 0.6, 0.6, Assets.images.MovementHelp);
		pageAddImage(page, Game.width * 0.4, Game.height * 0.35, 0.6, 0.6, Assets.images.AttackHelp);
		pageAddImage(page, Game.width * 0.65, Game.height * 0.35, 0.6, 0.6, Assets.images.BuildingCreateHelp);
		pageAddText(page, Game.width * 0.15, Game.height * 0.425, Game.width * 0.7, Game.height * 0.2, GameTexts.HELP_BASIC_BUILDINGS);
		pageAddImage(page, Game.width * 0.4, Game.height * 0.675, 0.6, 0.6, Assets.images.CreateHelp);
		pageAddText(page, Game.width * 0.15, Game.height * 0.75, Game.width * 0.7, Game.height * 0.2, GameTexts.HELP_BASIC_RESOURCES);
		
		pages.add(page);
	}
	
	private function createUnits() {
		var page:Group<Basic> = new Group();
		
		pageAddTitle(page, GameTexts.HELP_UNITS_TITLE);
		pageAddText(page, Game.width * 0.15, Game.height * 0.1, Game.width * 0.7, Game.height * 0.2, GameTexts.HELP_UNITS_BUILDER);
		pageAddImage(page, Game.width * 0.45, Game.height * 0.22, 1, 1, Assets.images.Human1);
		pageAddImage(page, Game.width * 0.45, Game.height * 0.22, 1, 1, Assets.images.Builder);
		pageAddText(page, Game.width * 0.15, Game.height * 0.25, Game.width * 0.7, Game.height * 0.2, GameTexts.HELP_UNITS_LANCER);
		pageAddImage(page, Game.width * 0.45, Game.height * 0.37, 1, 1, Assets.images.Human2);
		pageAddImage(page, Game.width * 0.45, Game.height * 0.37, 1, 1, Assets.images.Lancer);
		pageAddText(page, Game.width * 0.15, Game.height * 0.4	, Game.width * 0.7, Game.height * 0.2, GameTexts.HELP_UNITS_ARCHER);
		pageAddImage(page, Game.width * 0.45, Game.height * 0.52, 1, 1, Assets.images.Human3);
		pageAddImage(page, Game.width * 0.45, Game.height * 0.52, 1, 1, Assets.images.Archer);
		pageAddText(page, Game.width * 0.15, Game.height * 0.55, Game.width * 0.7, Game.height * 0.2, GameTexts.HELP_UNITS_ZOMBIE);
		pageAddImage(page, Game.width * 0.45, Game.height * 0.67, 1, 1, Assets.images.Zombie);
		
		pages.add(page);
	}
	
	private function createBuildings() {
		var page:Group<Basic> = new Group();
		
		pageAddTitle(page, GameTexts.HELP_BUILDINGS_TITLE);
		pageAddText(page, Game.width * 0.15, Game.height * 0.05, Game.width * 0.7, Game.height * 0.2, GameTexts.HELP_BUILDINGS_CASTLE);
		pageAddImage(page, Game.width * 0.45, Game.height * 0.24, 1, 1, Assets.images.Castle);
		pageAddText(page, Game.width * 0.15, Game.height * 0.25, Game.width * 0.7, Game.height * 0.2, GameTexts.HELP_BUILDINGS_LUMBERMILL);
		pageAddImage(page, Game.width * 0.45, Game.height * 0.37, 1, 1, Assets.images.Lumbermill_Icon);
		pageAddText(page, Game.width * 0.15, Game.height * 0.37, Game.width * 0.7, Game.height * 0.2, GameTexts.HELP_BUILDINGS_MINE);
		pageAddImage(page, Game.width * 0.45, Game.height * 0.49, 1, 1, Assets.images.Mine_Icon);
		pageAddText(page, Game.width * 0.15, Game.height * 0.49, Game.width * 0.7, Game.height * 0.2, GameTexts.HELP_BUILDINGS_HOUSE);
		pageAddImage(page, Game.width * 0.45, Game.height * 0.61, 1, 1, Assets.images.House);
		pageAddText(page, Game.width * 0.15, Game.height * 0.61, Game.width * 0.7, Game.height * 0.2, GameTexts.HELP_BUILDINGS_BARRACK);
		pageAddImage(page, Game.width * 0.45, Game.height * 0.73, 1, 1, Assets.images.Barrack);
		pageAddText(page, Game.width * 0.15, Game.height * 0.73, Game.width * 0.7, Game.height * 0.2, GameTexts.HELP_BUILDINGS_WALL);
		pageAddImage(page, Game.width * 0.45, Game.height * 0.85, 1, 1, Assets.images.Wall);
		
		pages.add(page);
	}
	
	private function pageAddTitle(page:Group<Basic>, text:String) {
		var text = new Text(Game.width * 0.1, Game.height * 0, Game.width * 0.8, Game.height * 0.2, text);
		text.fontSize = 80;
		text.color = Color.Black;
		text.textAlign = TextAlign.CENTER;
		text.textVerticalAlign = TextVerticalAlign.MIDDLE;
		page.add(text);
	}
	
	private function pageAddText(page:Group<Basic>, x:Float, y:Float, width:Float, height:Float, text:String) {
		var text = new Text(x, y, width, height, text);
		text.color = Color.Black;
		text.textAlign = TextAlign.LEFT;
		text.textVerticalAlign = TextVerticalAlign.MIDDLE;
		page.add(text);
	}
	
	private function pageAddImage(page:Group<Basic>, x:Float, y:Float, scaleX:Float, scaleY:Float, asset:Image) {
		var image:Graphic = new Graphic(x, y, 0, 0);
		image.setImage(asset);
		image.scale.x = scaleX;
		image.scale.y = scaleY;
		page.add(image);
	}
	
	private function gotoMainState() {
		Game.instance.changeState(new MenuState());
		backButton.onClick.removeAll();
		nextPageButton.onClick.removeAll();
		prevPageButton.onClick.removeAll();
	}
	
}