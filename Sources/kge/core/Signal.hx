package kge.core;
import haxe.Constraints.Function;

class Signal
{
	
	private var listeners:Array<Function>;

	public function new() {
		listeners = [];
	}
	
	public function add(listener:Function) {
		if(listeners.indexOf(listener) == -1) { listeners.push(listener); }
	}
	
	public function remove(listener:Function) {
		while (listeners.indexOf(listener) > -1) {
			listeners.remove(listener);
		}
	}
	
	public function removeAll() {
		for (listener in listeners) {
			remove(listener);
		}
	}
	
	public function dispatch(params:Dynamic = null) {
		for (listener in listeners) {
			listener(params);
		}
	}
	
}