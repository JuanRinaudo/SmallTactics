package ludumdare38;

import kge.ui.Button.ButtonStyle;
import kha.Color;
import kha.math.Vector2;
import kge.ui.Text.TextAlign;
import kge.ui.Text.TextVerticalAlign;

class MenuButtonStyle implements ButtonStyle {
	public static var instance(get, null):MenuButtonStyle;
	private static var _instance:MenuButtonStyle;
	
	public var clickColor:Color = Color.fromFloats(0.5, 0, 0);
	public var overColor:Color = Color.fromFloats(0.8, 0.8, 0.8);
	public var outColor:Color = Color.fromFloats(1, 1, 1, 0.9);
	
	public var textColor:Color = Color.fromFloats(0, 0, 0);
	public var textSize:Int = 0;
	public var textSizeModifier:Float = 0.9;
	public var textAlign:TextAlign = TextAlign.CENTER;
	public var textVerticalAlign:TextVerticalAlign = TextVerticalAlign.MIDDLE;
	public var textOffset:Vector2 = new Vector2(0, 0);
	
	private function new() {}
	
	static public function get_instance():MenuButtonStyle {
		if (_instance == null) {
			_instance = new MenuButtonStyle();
		}
		return _instance;
	}
}