package kge.config;
import kge.ui.Text.TextAlign;
import kge.ui.Text.TextVerticalAlign;
import kha.Assets;
import kha.Font;

class DefaultFontStyle 
{

	public static var text:String = "";
	public static var fontSize:Int = 30;
	public static var textAlign:TextAlign = TextAlign.LEFT;
	public static var textVerticalAlign:TextVerticalAlign = TextVerticalAlign.TOP;
	public static var font:Font;
	public static var lineHeight:Int = fontSize;
	
	public function new(font:Font) {
		DefaultFontStyle.font = font;
	}
	
}