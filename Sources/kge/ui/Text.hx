package kge.ui;

import kge.config.DefaultFontStyle;
import kge.ui.Text.TextVerticalAlign;
import kha.Assets;
import kha.Color;
import kha.Font;
import kha.Framebuffer;
import kge.core.Graphic;
import kha.Image;
import kha.math.Vector2;

@:enum
abstract TextAlign(Int) {
  var LEFT = 0;
  var CENTER = 1;
  var RIGHT = 2;
}

@:enum
abstract TextVerticalAlign(Int) {
  var TOP = 0;
  var MIDDLE = 1;
  var BOTTOM = 2;
}

class Text extends Graphic
{
	
	public var text(default, set):String = DefaultFontStyle.text;
	private var _lines:Array<String>;
	public var fontSize:Int = DefaultFontStyle.fontSize;
	public var lineHeight:Int = DefaultFontStyle.lineHeight;
	
	public var textAlign(default, set):TextAlign = DefaultFontStyle.textAlign;
	public var textVerticalAlign(default, set):TextVerticalAlign = DefaultFontStyle.textVerticalAlign;

	private var drawOffsetsX:Array<Float>;
	private var drawOffsetY:Float;
	
	public var font:Font = DefaultFontStyle.font;
	
	public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0, text:String = "")
	{
		super(x, y, width, height);
		
		drawOffsetsX = [];
		
		_lines = [];
		
		this.text = text;
		
		setCustomDrawFunction(drawText);
	}
	
	private function recalculateText() {
		for(i in 0..._lines.length) {
			if (drawOffsetsX[i] == null) {
				drawOffsetsX.push(0);
			}
			drawOffsetsX[i] = getHorizontalPosition(_lines[i]);
		}
		
		drawOffsetY = getVerticalPosition();
	}
	
	private function getHorizontalPosition(textLine:String):Float {
		switch(textAlign) {
			case TextAlign.LEFT:
				return 0;
			case TextAlign.CENTER:
				return width * 0.5 - font.width(fontSize, textLine) * 0.5;
			case TextAlign.RIGHT:
				return width - font.width(fontSize, textLine);				
			default:
				return 0;
		}
	}
	
	private function getVerticalPosition():Float {
		switch(textVerticalAlign) {
			case TextVerticalAlign.TOP:
				return 0;
			case TextVerticalAlign.MIDDLE:
				return height * 0.5 - font.height(fontSize) * 0.5;
			case TextVerticalAlign.BOTTOM:
				return height - font.height(fontSize);				
			default:
				return 0;
		}
	}
	
	private function set_text(value:String) {
		dirty = true;
		_lines = value.split("\n");
		return text = value;
	}
	
	private function set_textAlign(value:TextAlign) {
		dirty = true;
		return textAlign = value;
	}
	
	private function set_textVerticalAlign(value:TextVerticalAlign) {
		dirty = true;
		return textVerticalAlign = value;
	}
	
	private function drawText(framebuffer:Image) {
		if (dirty) {
			recalculateText();
		}
		
		framebuffer.g2.font = font;
		framebuffer.g2.fontSize = fontSize;
		for(i in 0..._lines.length) {
			framebuffer.g2.drawString(_lines[i], drawOffsetsX[i], drawOffsetY + lineHeight * i);
		}
	}
	
}