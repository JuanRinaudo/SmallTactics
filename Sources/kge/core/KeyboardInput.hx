package kge.core;

import kha.Key;
import kha.input.Keyboard;

using kge.core.InputState;

typedef KeyboardKey = {
	key: Key,
	value: String
}

class KeyboardInput extends CoreBase
{
	private var keyData:Map<String, InputState>;
	private var pressedQueue:Array<String>;
	private var releasedQueue:Array<String>;
	
	public var onKeyDown:Signal;
	public var onKeyUp:Signal;
	public var onKeyChange:Signal;
	
	public function new() 
	{
		super("Keyboard Input");
		
		keyData = new Map();
		pressedQueue = [];
		releasedQueue = [];
		
		onKeyDown = new Signal();
		onKeyUp = new Signal();
		onKeyChange = new Signal();
		
		Keyboard.get().notify(keyDownListener, keyUpListener);
	}
	
	private function keyDownListener(key:Key, value:String) {
		var mapKey:String = key.getName() + value;
		
		onKeyDown.dispatch({key: key, value: value});
		
		keyData.set(mapKey, PRESSED);
		pressedQueue.push(mapKey);
	}
	
	private function keyUpListener(key:Key, value:String) {
		var mapKey:String = key.getName() + value;
		
		onKeyUp.dispatch({key: key, value: value});
		
		keyData.set(mapKey, RELEASED);
		releasedQueue.push(mapKey);
	}
	
	public function keyDown(keyValue:String, caseSensitive:Bool = false, keyType:Key = null):Bool {
		if (keyType == null) { keyType = Key.CHAR; }
		
		if (!caseSensitive) {
			var stateLow:InputState = keyData.get(keyType + keyValue.toLowerCase());
			var stateUp:InputState = keyData.get(keyType + keyValue.toUpperCase());
			return stateLow == DOWN || stateLow == PRESSED
				|| stateUp == DOWN || stateUp == PRESSED;			
		} else {
			var state:InputState = keyData.get(keyType + keyValue);
			return state == DOWN || state == PRESSED;
		}
	}
	
	public function keyUp(keyValue:String, caseSensitive:Bool = false, keyType:Key = null):Bool {
		if (keyType == null) { keyType = Key.CHAR; }
		
		if (!caseSensitive) {
			var stateLow:InputState = keyData.get(keyType + keyValue.toLowerCase());
			var stateUp:InputState = keyData.get(keyType + keyValue.toUpperCase());
			return stateLow == UP || stateLow == RELEASED
				|| stateUp == UP || stateUp == RELEASED;			
		} else {
			var state:InputState = keyData.get(keyType + keyValue);
			return state == UP || state == RELEASED;
		}
	}
	
	public function keyPressed(keyValue:String, caseSensitive:Bool = false, keyType:Key = null):Bool {
		if (keyType == null) { keyType = Key.CHAR; }
		
		if (!caseSensitive) {
			return keyData.get(keyType + keyValue.toLowerCase()) == PRESSED
				|| keyData.get(keyType + keyValue.toUpperCase()) == PRESSED;
		} else {
			return keyData.get(keyType + keyValue) == PRESSED;
		}
	}
	
	public function keyReleased(keyValue:String, caseSensitive:Bool = false, keyType:Key = null):Bool {
		if (keyType == null) { keyType = Key.CHAR; }		
		
		if (!caseSensitive) {
			return keyData.get(keyType + keyValue.toLowerCase()) == RELEASED
				|| keyData.get(keyType + keyValue.toUpperCase()) == RELEASED;
		} else {
			return keyData.get(keyType + keyValue) == RELEASED;
		}
	}
	
	override public function update() {
		super.update();
		
		checkQueue(releasedQueue, UP);
		checkQueue(pressedQueue, DOWN);
	}
	
	private function checkQueue(queue:Array<String>, state:InputState) {
		var key:String;
		while (queue.length > 0) {
			var key = queue.pop();
			if (keyData.exists(key)) {
				keyData.set(key, state);
			}
		}
	}
	
	public function clearInput() {
		var keys = keyData.keys();
		for (key in keys) {
			keyData.set(key, UP);
		}
		
		while (releasedQueue.length > 0) {
			releasedQueue.pop();
		}
		while (pressedQueue.length > 0) {
			pressedQueue.pop();
		}
	}
	
}