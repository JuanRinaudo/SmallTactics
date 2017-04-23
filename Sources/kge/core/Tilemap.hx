package kge.core;
import js.html.PopupBlockedEvent;
import kha.Blob;
import kha.Image;
import kha.math.Vector2;

class Tilemap extends Entity
{

	public var tiledata:Array<Int>;
	private var tileset:Image;
	
	private var tilesetWidth:Int;
	private var tilesetHeight:Int;
	
	public var tileWidth:Int;
	public var tileHeight:Int;
	
	public var tileMapWidth:Int;
	public var tileMapHeigth:Int;
	
	public var collisionIndex:Int;
	
	private var tilesetPositions:Array<Vector2>;
	
	public function new() {
		super(0, 0, 0, 0);
		
		collisionIndex = 0;
		
		setCustomDrawFunction(drawTileset);
	}
	
	public function setup(tiledata:String, tileset:Image, tileWidth:Int, tileHeight:Int, collisionIndex:Int = 0) {
		parseTiles(tiledata);
		this.tileset = tileset;
		
		tilesetWidth = Math.floor(tileset.width / tileWidth);
		tilesetHeight = Math.floor(tileset.height / tileHeight);
		
		tilesetPositions = [];
		for (i in 0...(tilesetWidth * tilesetHeight)) {
			tilesetPositions[i] = new Vector2((i * tileWidth) % tileset.width, Math.floor(i / tilesetWidth) * tileHeight);
		}
		
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		
		this.collisionIndex = collisionIndex;
	}
	
	private function parseTiles(string:String) {
		tiledata = [];
		var lines = string.split("\n");
		lines.remove("");
		var tiles = [];
		for (i in 0...lines.length) {
			tiles = lines[i].split(",");
			for (j in 0...tiles.length) {
				tiledata[Math.floor(i * tiles.length + j)] = Std.parseInt(tiles[j]);
			}
		}
		tileMapWidth = tiles.length;
		tileMapHeigth = lines.length;
	}
	
	private function drawTileset(framebuffer:Image) {
		var tile:Int;
		for (i in 0...tileMapHeigth) {
			for (j in 0...tileMapWidth) {
				tile = tiledata[Math.floor(i * tileMapWidth + j)];
				if(tile > -1) {
					framebuffer.g2.drawSubImage(tileset, _origin.x + j * tileWidth, _origin.y + i * tileHeight
						, tilesetPositions[tile].x, tilesetPositions[tile].y, tileWidth, tileHeight);
				}
			}
		}
	}
	
}