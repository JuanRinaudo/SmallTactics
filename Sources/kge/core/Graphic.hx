package kge.core;

import haxe.Constraints.Function;
import kge.math.Rectangle;
import kge.utils.AtlasLoader;
import kha.Blob;
import kha.Color;
import kha.Image;
import kha.graphics2.GraphicsExtension;
import kha.math.FastMatrix3;

class Graphic extends Basic
{
	public var width(get, set):Float;
	public var height(get, set):Float;
	private var _width:Float;
	private var _height:Float;
	
	public var color:Color;
	public var alpha:Float = 1;
	
	private var drawingFunction:Function;

	public function new(x:Float, y:Float, width:Float, height:Float) 
	{
		super(x, y);
		
		this._width = width;
		this._height = height;
		
		color = Color.White;
		
		setRectangle(width, height);
	}
	
	override public function render(framebuffer:Image) 
	{
		super.render(framebuffer);
		
		framebuffer.g2.pushTransformation(framebuffer.g2.transformation.multmat(transform));
		
		framebuffer.g2.color = Color.fromFloats(color.R, color.G, color.B, color.A * alpha);
		drawingFunction(framebuffer);
		
		framebuffer.g2.popTransformation();
		
		#if debug
		if (Debug.drawBounds) {
			//TODO
			framebuffer.g2.pushTransformation(framebuffer.g2.transformation.multmat(FastMatrix3.translation(x, y)).multmat(FastMatrix3.scale(scale.x, scale.y)));
			framebuffer.g2.color = Color.Red;
			framebuffer.g2.drawRect(0, 0, _width, _height);
			framebuffer.g2.popTransformation();
		}
		#end
	}
	
	public function setRectangle(width:Float, height:Float) {
		drawingFunction = drawRectangle.bind(_, width, height);
	}
	
	public function setCircle(radius:Float, segments:Int = 0) {
		drawingFunction = drawCircle.bind(_, radius, segments);
	}
	
	public function setImage(image:Image) {
		drawingFunction = drawImage.bind(_, image);
	}
	
	public function setAtlasImage(frameName:String, fitBox:Bool = false) {
		var frame:AtlasFrame = AtlasLoader.getFrame(frameName);
		if(fitBox) {
			this.drawingFunction = drawFittedSubImage.bind(_, frame.atlas.texture, frame.rectangle);
		} else {
			this.drawingFunction = drawSubImage.bind(_, frame.atlas.texture, frame.rectangle);
		}
	}
	
	public function setCustomDrawFunction(drawingFunction:Function) {
		this.drawingFunction = drawingFunction;
	}
	
	private function drawRectangle(framebuffer:Image, width:Float, height:Float) {
		framebuffer.g2.fillRect(0, 0, width, height);
	}
	
	private function drawCircle(framebuffer:Image, radius:Float, segments:Int = 0) {
		GraphicsExtension.fillCircle(framebuffer.g2, 0, 0, radius, segments);
	}
	
	private function drawImage(framebuffer:Image, image:Image) {
		framebuffer.g2.drawImage(image, 0, 0);
	}
	
	private function drawSubImage(framebuffer:Image, image:Image, subRect:Rectangle) {
		framebuffer.g2.drawSubImage(image, 0, 0, subRect.x, subRect.y, subRect.width, subRect.height);
	}
	
	private function drawFittedSubImage(framebuffer:Image, image:Image, subRect:Rectangle) {
		framebuffer.g2.drawScaledSubImage(image, subRect.x, subRect.y, subRect.width, subRect.height, 0, 0, width, height);
	}
	
	private function get_width():Float {
		return _width * scale.x;
	}
	private function set_width(value:Float):Float {
		return _width = value;
	}
	
	private function get_height():Float {
		return _height * scale.y;
	}
	private function set_height(value:Float):Float {
		return _height = value;
	}
}