package kge.core;

import kge.ui.Button;
import kge.ui.ToggleButton;
import kha.Assets;
import kha.Color;
import kha.Image;
import kha.Key;
import kha.System;
import kha.math.Vector2;
import kge.ui.Text;

class Debug extends Group<Basic>
{
	public static var drawCalls:Int = 0;
	public static var updateCalls:Int = 0;
	public static var transformUpdates:Int = 0;
	
	private var lastTime:Float = 0;
	private var fps:Int = 0;

	private var debugActive(default, set):Bool = false;
	
	public static var drawBounds:Bool = false;
	
	private var background:Graphic;
	
	private var generalPanel:Group<Basic>;
	private var generalButton:Button;
	
	private var panels:Array<Group<Basic>> = [];
	
	private var debugText:Text;
	
	private static var buttonStyle:DebugButtonStyle = DebugButtonStyle.instance;
	
	public function new() 
	{
		super();
		
		background = new Graphic(0, 0, Game.width, Game.height);
		background.color = Color.fromFloats(0, 1, 0, 0.1);
		add(background);
		
		generalPanel = new Group();
		add(generalPanel);
		
		var backgroundDebugText:Graphic = new Graphic(0, 0, Game.width, 30);
		backgroundDebugText.color = Color.fromFloats(0, 0, 0, 0.5);
		backgroundDebugText.setRectangle(backgroundDebugText.width, backgroundDebugText.height);
		add(backgroundDebugText);
		
		debugText = new Text(0, 0, Game.width, Game.height, "");
		debugText.color = Color.fromFloats(1, 1, 1, 0.5);
		add(debugText);
		
		createPanelButton(generalPanel, generalButton, "General");
		
		var bounds:ToggleButton = new ToggleButton(5, 35, 240, 30, "Graphic Bounds");
		bounds.onSwitch.add(function() { if(debugActive) { drawBounds = !drawBounds; } });
		generalPanel.add(bounds);
		
		debugActive = false;
	}
	
	private function createPanelButton(panel:Group<Basic>, button:Button, label:String) {
		button = new Button(panels.length * buttonStyle.width, Game.height - buttonStyle.height, buttonStyle.width, 
			buttonStyle.height, label, buttonStyle);
		button.onClick.add(showPanel.bind(panel));
		add(button);
	}
	
	private function showPanel(selectedPanel:Group<Basic>) {
		for (panel in panels) {
			panel.visible = false;
		}
		selectedPanel.visible = true;
	}
	
	override public function update() 
	{
		super.update();
		
		if (Game.input.keyboad.keyDown("", Key.SHIFT) && Game.input.keyboad.keyPressed("D")) {
			debugActive = !debugActive;
		}
		
		if(debugActive) {
			fps = Math.floor(1 / (System.time - lastTime));
			lastTime = System.time;
			
			if (debugActive) {	
				debugText.text = "Updates: " + updateCalls +
					"   |   " + "Draws: " + drawCalls +
					"   |   " + "Transforms: " + transformUpdates +
					"   |   " + "FPS: " + fps;
			}
		}
	}
	
	private function set_debugActive(value:Bool):Bool {
		visible = value;
		return debugActive = value;
	}
	
}

class DebugButtonStyle implements ButtonStyle
{
	
	public static var instance(get, null):DebugButtonStyle;
	private static var _instance:DebugButtonStyle;
	
	public var clickColor:Color = Color.fromFloats(0, 0.5, 0, 0.5);
	public var overColor:Color = Color.fromFloats(0, 0.8, 0, 0.5);
	public var outColor:Color = Color.fromFloats(0, 1, 0, 0.5);
	
	public var textColor:Color = Color.Black;
	public var textSize:Int = 0;
	public var textSizeModifier:Float = 0.8;
	public var textAlign:TextAlign = TextAlign.CENTER;
	public var textVerticalAlign:TextVerticalAlign = TextVerticalAlign.MIDDLE;
	public var textOffset:Vector2 = new Vector2(0, 0);
	
	public var width:Float = 100;
	public var height:Float = 30;
	
	private function new() {
		
	}

	static public function get_instance():DebugButtonStyle {
		if (_instance == null) {
			_instance = new DebugButtonStyle();
		}
		return _instance;
	}
	
}