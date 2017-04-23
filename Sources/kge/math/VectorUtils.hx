package kge.math;
import kha.math.Vector2;


class VectorUtils
{

	public static inline function distance(v:Vector2, v2:Vector2):Float {
		return v.sub(v2).length;
	}
	
}