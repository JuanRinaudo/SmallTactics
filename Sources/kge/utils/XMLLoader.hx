package kge.utils;

import kha.Blob;

class XMLLoader
{

	public static function parse(data:Blob):Xml {
		return Xml.parse(data.toString());
	}
	
}