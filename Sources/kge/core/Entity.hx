package kge.core;

import kge.math.Rectangle;

class Entity extends Graphic
{
	
	public var hitBox:Rectangle;

	public function new(x:Float, y:Float, width:Float, height:Float) 
	{
		super(x, y, width, height);
		
		hitBox = new Rectangle(x, y, width, height);
	}
	
	override public function update() 
	{
		super.update();
		
		hitBox.x = x;
		hitBox.y = y;
		hitBox.width = width;
		hitBox.height = height;
	}
	
}