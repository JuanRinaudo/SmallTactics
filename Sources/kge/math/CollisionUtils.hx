package kge.math;
import js.html.svg.Number;
import kge.core.Entity;
import kge.core.Tilemap;
import kha.math.Vector2;

class CollisionUtils
{

	public function new() 
	{
		
	}
	
	public static function collision() {
		
	}
	
	public static inline function pointInsideRect(point:Vector2, rect:Rectangle) {
		return point.x > rect.x &&
			point.x < rect.x + rect.width &&
			point.y > rect.y &&
			point.y < rect.y + rect.height;
	}
	
	public static inline function AABBOverlap(rect:Rectangle, rect2:Rectangle) {
		return rect.x < rect2.x + rect2.width &&
			rect.x + rect.width > rect2.x &&
			rect.y < rect2.y + rect2.height &&
			rect.y + rect.height > rect2.y;
	}
	
	public static function EntityTilemapOverlaps(entity:Entity, tilemap:Tilemap) {
		var rect:Rectangle;
		var tile:Int = 0;
		var initialI:Int = Math.floor((entity.x - tilemap.x) / tilemap.tileWidth);
		var initialJ:Int = Math.floor((entity.y - tilemap.y) / tilemap.tileHeight);
		var i:Int = initialI;
		var j:Int = initialJ;
		var width:Int = Math.floor(entity.width / tilemap.tileWidth);
		var height:Int = Math.floor(entity.height / tilemap.tileHeight);
		
		if (i < 0 || i > tilemap.tileMapWidth || j < 0 || j > tilemap.tileMapHeigth) {
			return false;
		}
		
		while (i <= initialI + width) {
			j = initialJ;
			while (j <= initialJ + height) {
				trace(i, j, width, height);
				tile = tilemap.tiledata[j * tilemap.tileMapWidth + i];
				if(tile > tilemap.collisionIndex) {
					rect = new Rectangle(tilemap.x + i * tilemap.tileWidth, tilemap.y + j * tilemap.tileHeight, tilemap.tileWidth, tilemap.tileHeight);
					if (AABBOverlap(entity.hitBox, rect)) {
						return true;
					}
				}
				j++;
			}
			i++;
		}
		return false;
	}
	
}