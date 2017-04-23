package kge.core;

class Input extends CoreBase
{

	public var keyboad:KeyboardInput;
	public var mouse:MouseInput;
	public var touch:TouchInput;
	
	public function new() 
	{
		super();
		
		keyboad = new KeyboardInput();
		mouse = new MouseInput();
		touch = new TouchInput();
	}
	
	override public function update() {
		super.update();
		
		keyboad.update();
		mouse.update();
		touch.update();
	}
	
	public function clearInput() {
		keyboad.clearInput();
		mouse.clearInput();
	}
	
}