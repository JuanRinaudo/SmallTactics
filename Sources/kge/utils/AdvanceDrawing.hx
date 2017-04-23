package kge.utils;

import kge.math.Rectangle;
import kge.utils.AtlasLoader.AtlasFrame;
import kha.Image;
import kha.math.Vector2;

class AdvanceDrawing 
{

	public static function draw9Slice(framebuffer:Image, frameName:String, size:Vector2, innerRectangle:Rectangle) {
		var frame:AtlasFrame = AtlasLoader.getFrame(frameName);
		var texture:Image = frame.atlas.texture;
		var rectangle:Rectangle = frame.rectangle;
		framebuffer.g2.drawSubImage(texture, 0, 0, rectangle.x, rectangle.y,
			innerRectangle.x, innerRectangle.y); //Top Left
		var rX:Float = rectangle.x + innerRectangle.x;
		var tX:Float = size.x - innerRectangle.x;
		var trX:Float = tX - innerRectangle.x;
		framebuffer.g2.drawScaledSubImage(texture, rX, rectangle.y, innerRectangle.width, innerRectangle.y, 
			innerRectangle.x, 0, trX, innerRectangle.y); //Top
		framebuffer.g2.drawSubImage(texture, tX, 0, rX + innerRectangle.width, rectangle.y,
			innerRectangle.x, innerRectangle.y); //Top Right
		var rY:Float = rectangle.y + innerRectangle.y;
		var tY:Float = size.y - innerRectangle.y;
		var trY:Float = tY - innerRectangle.y;
		framebuffer.g2.drawScaledSubImage(texture, rectangle.x, rY, innerRectangle.x, innerRectangle.height, 
			0, innerRectangle.y, innerRectangle.x, trY); //Left
		framebuffer.g2.drawScaledSubImage(texture, rX, rY, innerRectangle.width, innerRectangle.height, 
			innerRectangle.x, innerRectangle.y, trX, trY); //Middle
		framebuffer.g2.drawScaledSubImage(texture, rX + innerRectangle.width, rY, innerRectangle.x, innerRectangle.height, 
			tX, innerRectangle.y, innerRectangle.x, trY); //Right
		framebuffer.g2.drawSubImage(texture, 0, tY, rectangle.x, rY + innerRectangle.height,
			innerRectangle.x, innerRectangle.y); //Bottom Left
		framebuffer.g2.drawScaledSubImage(texture, rX, rY + innerRectangle.height, innerRectangle.width, innerRectangle.y, 
			innerRectangle.x, tY, trX, innerRectangle.y); //Bottom
		framebuffer.g2.drawSubImage(texture, tX, tY, rX + innerRectangle.width, rY + innerRectangle.height,
			innerRectangle.x, innerRectangle.y); //Bottom Right
	}
	
}