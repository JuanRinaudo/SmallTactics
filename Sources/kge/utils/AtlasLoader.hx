package kge.utils;

import kha.Blob;
import kge.math.Rectangle;
import kha.Image;

class AtlasFrame {
	public var name:String;
	public var rectangle:Rectangle;
	public var atlas:AtlasSheet;
	
	public function new(name:String, rectangle:Rectangle, atlas:AtlasSheet) {
		this.name = name;
		this.rectangle = rectangle;
		this.atlas = atlas;
	}
	
	public function toString() {
		return "{name: " + name + ", rectangle: " + rectangle + "}"; 
	}
}

class AtlasSheet {
	public var frames:Map<String, AtlasFrame>;
	public var texture:Image;

    public function new(xml:Xml, texture:Image) {
		this.texture = texture;
		
		var subtextures = xml.elementsNamed("TextureAtlas").next().elementsNamed("SubTexture");
		
		if(frames == null) {
			frames = new Map<String, AtlasFrame>();
		}
		
		for (sub in subtextures) {
			var name:String = sub.get("name");
			frames.set(name, new AtlasFrame(name, new Rectangle(
				Std.parseFloat(sub.get("x")),
				Std.parseFloat(sub.get("y")),
				Std.parseFloat(sub.get("width")),
				Std.parseFloat(sub.get("height"))
			), this));
		}
	}
	
	public function toString() {
		var string:String = "[\n";
		for (frame in frames) {
			string += frame.toString() + "," + "\n";
		}
		string += "]";
		return string;
	}
}

class AtlasLoader 
{
	private static var frames:Map<String, AtlasFrame>;
	
	public static function parseXMLAtlas(xmlData:Blob, image:Image):AtlasSheet {
		var atlasSheet:AtlasSheet = new AtlasSheet(XMLLoader.parse(xmlData), image);
		
		if (frames == null) {
			frames = new Map<String, AtlasFrame>();
		}
		
		for (frame in atlasSheet.frames) {
			frames.set(frame.name, frame);
		}
		
		return atlasSheet;
	}
	
	public static function getFrame(name:String):AtlasFrame {
		if (frames.exists(name)) {
			return frames.get(name);
		} else {
			trace("The frame: " + name + " does not exists.");
			return null;
		}
	}
	
}