package kge.config;

import kge.ui.Button.ButtonStyle;
import kge.ui.Text.TextAlign;
import kge.ui.Text.TextVerticalAlign;
import kha.Color;
import kha.math.Vector2;

class DefaultButtonStyle implements ButtonStyle
{

	public static var instance(get, null):DefaultButtonStyle;
	private static var _instance:DefaultButtonStyle;
	
	public var clickColor:Color = Color.Red;
	public var overColor:Color = Color.Blue;
	public var outColor:Color = Color.White;
	
	public var textColor:Color = Color.Black;
	public var textSize:Int = 0;
	public var textSizeModifier:Float = 0.8;
	public var textAlign:TextAlign = TextAlign.CENTER;
	public var textVerticalAlign:TextVerticalAlign = TextVerticalAlign.MIDDLE;
	public var textOffset:Vector2 = new Vector2(0, 0);
	
	private function new() {
		
	}

	static public function get_instance():DefaultButtonStyle {
		if (_instance == null) {
			_instance = new DefaultButtonStyle();
		}
		return _instance;
	}
	
}