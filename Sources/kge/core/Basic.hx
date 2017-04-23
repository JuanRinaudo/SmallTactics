package kge.core;

import haxe.Constraints.Function;
import kha.Image;
import kha.math.FastMatrix3;
import kha.math.Vector2;

class Basic extends CoreBase
{
	public var lastX(get, null):Float;
	public var lastY(get, null):Float;
	private var _lastPosition:Vector2;
	public var x(default, set):Float;
	public var y(default, set):Float;
	
	private var transform:FastMatrix3;
	
	public var origin(get, set):Vector2;
	private var _origin:Vector2;
	public var offset(get, set):Vector2;
	private var _offset:Vector2;
	public var scale(get, set):Vector2;
	private var _scale:Vector2;
	public var angle(default, set):Float;
	
	public var transformationFunction:Function;
	public var noScaleTransform(default, set):Bool;
	
	public var visible(default, set):Bool;
	
	private var dirty:Bool;

	public function new(x:Float = 0, y:Float = 0) {
		super();
		_lastPosition = new Vector2(0, 0);
		
		
		this.x = x;
		this.y = y;
		
		transform = FastMatrix3.identity();
		
		_origin = new Vector2(0, 0);
		_offset = new Vector2(0, 0);
		_scale = new Vector2(1, 1);
		angle = 0;
		
		noScaleTransform = false;
		
		visible = true;
		exists = true;
	}
	
	override public function update() {
		if(dirty) {
			_lastPosition.x = x;
			_lastPosition.y = y;
		}
		
		super.update();
	}
	
	public function render(framebuffer:Image) {
		if(visible) {
			#if debug
			++Debug.drawCalls;
			#end
			
			if (dirty) {
				transformationFunction();
			}
		}
	}
	
	public function destroy() {
		
	}
	
	private function set_x(value:Float):Float {
		dirty = true;
		_lastPosition.x = x;
		return x = value;
	}
	private function set_y(value:Float):Float {
		dirty = true;
		_lastPosition.y = y;
		return y = value;
	}
	
	private function get_origin():Vector2 {
		dirty = true;
		return _origin;
	}	
	private function set_origin(value:Vector2):Vector2 {
		_origin.x = value.x;
		_origin.y = value.y;
		dirty = true;
		return _origin;
	}
	
	private function get_offset():Vector2 {
		dirty = true;
		return _offset;
	}
	private function set_offset(value:Vector2):Vector2 {
		_offset.x = value.x;
		_offset.y = value.y;
		dirty = true;
		return _offset;
	}
	
	private function get_scale():Vector2 {
		return _scale;
	}
	private function set_scale(value:Vector2) {
		_scale.x = value.x;
		_scale.y = value.y;
		dirty = true;
		return value;
	}
	
	private function get_angle():Float {
		return angle;
	}
	private function set_angle(value:Float):Float {
		angle = value;
		dirty = true;
		return angle;
	}
	
	private function get_lastX():Float {
		return _lastPosition.x;
	}
	private function get_lastY():Float {
		return _lastPosition.y;
	}
	
	private function set_noScaleTransform(value:Bool):Bool {
		transformationFunction = value ? noScaleTransfomation : fullTransformation;
		return noScaleTransform = value;
	}
	
	private function noScaleTransfomation() {
		setupTransformation(1, 1);
	}
	
	private function fullTransformation() {
		setupTransformation(_scale.x, _scale.y);
	}
	
	private function set_visible(value:Bool):Bool {
		return visible = value;
	}
	
	private inline function setupTransformation(sx:Float, sy:Float) {
		#if debug
		++Debug.transformUpdates;
		#end
		
		var cos = Math.cos(angle);
		var sin = Math.sin(angle);
		transform._20 = x + _offset.y * sy - cos * _origin.y * sy + sin * _origin.x * sx;
		transform._21 = y + _offset.x * sx - sin * _origin.y * sy - cos * _origin.x * sx;
		transform._00 = cos * sx;
		transform._10 = -sin * sx;
		transform._01 = sin * sy;
		transform._11 = cos * sy;
	}
	
}