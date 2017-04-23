package kge.math;

import kha.math.Vector2;

class MathUtils
{
	
	public static function circleLineCol(circlePos:Vector2, circleRadius:Float, lineStart:Vector2, lineEnd:Vector2)
	{
		var d:Vector2 = lineEnd.sub(lineStart);
		var f:Vector2 = lineStart.sub(circlePos);
		
		var a:Float = d.dot(d);
		var b:Float = 2 * f.dot(d);
		var c:Float = f.dot(f) - circleRadius * circleRadius;
		
		var discriminant = b * b - 4 * a * c;
		if (discriminant < 0) {
			return false;
		} else {
			discriminant = Math.sqrt(discriminant);
			
			var t1:Float = ( -b - discriminant) / (2 * a);
			var t2:Float = ( -b + discriminant) / (2 * a);
			
			if (t1 >= 0 && t1 <= 1) {
				return true;
			} else if (t2 >= 0 && t2 <= 1) {
				return true;
			}
			
			return false;
		}
	}
	
	public static inline function clamp(value:Float, min:Float, max:Float):Float {
		return Math.max(Math.min(value, max), min);
	}
	
}