package kge.core;


class CoreBase
{
	
	public var exists(default, set):Bool;
	
	private var name:String = "";
	
	public var ID:Int;

	public function new(name:String = "") {
		this.name = name;
		
		ID = Game.getNextID();
	}
	
	public function update() {
		#if debug
		++Debug.updateCalls;
		#end
	}
	
	private function set_exists(value:Bool):Bool {
		return exists = value;
	}
	
}