package kge.core;

import kha.input.Mouse;
import kha.math.Vector2;

using kge.core.InputState;

typedef MouseButton = {
	button:Int,
	x:Int,
	y:Int
}

typedef MouseDelta = {
	x: Int,
	y: Int,
	dx: Int,
	dy: Int
}

typedef MouseWheelDelta = {
	delta: Int
}

class MouseInput extends CoreBase
{
	private var buttonData:Map<Int, InputState>;
	private var pressedQueue:Array<Int>;
	private var releasedQueue:Array<Int>;
	
	public var x(get, null):Float;
	public var y(get, null):Float;
	public var mousePosition(get, null):Vector2;
	public var mousePosDelta(get, null):Vector2;
	private var _mousePosition:Vector2;
	private var _mousePosDelta:Vector2;
	
	public var onMouseDown:Signal = new Signal();
	public var onMouseUp:Signal = new Signal();
	public var onMouseMove:Signal = new Signal();
	public var onMouseWheel:Signal = new Signal();
	
	public var mouseWheel(get, null):Int;

	public function new() 
	{
		super("Mouse Input");
		
		_mousePosition = new Vector2();
		_mousePosDelta = new Vector2();
		
		buttonData = new Map();
		pressedQueue = [];
		releasedQueue = [];
		
		Mouse.get().notify(mouseDownListener, mouseUpListener, mouseMoveListener, mouseWheelListener);
	}
	
	private function mouseDownListener(index:Int, x:Int, y:Int) {
		_mousePosition.x = x;
		_mousePosition.y = y;
		_mousePosDelta.x = 0;
		_mousePosDelta.y = 0;
		buttonData.set(index, PRESSED);
		pressedQueue.push(index);
		onMouseDown.dispatch({index: index, x: x, y: y});
	}
	
	private function mouseUpListener(index:Int, x:Int, y:Int) {
		_mousePosition.x = x;
		_mousePosition.y = y;
		_mousePosDelta.x = 0;
		_mousePosDelta.y = 0;
		buttonData.set(index, RELEASED);
		releasedQueue.push(index);
		onMouseUp.dispatch({index: index, x: x, y: y});
	}
	
	private function mouseMoveListener(x:Int, y:Int, dx:Int, dy:Int) {
		_mousePosition.x = x;
		_mousePosition.y = y;
		_mousePosDelta.x = dx;
		_mousePosDelta.y = dy;
		onMouseMove.dispatch({x: x, y: y, dx: dx, dy: dy});
	}
	
	private function mouseWheelListener(delta:Int) {
		mouseWheel = delta;
		onMouseWheel.dispatch({delta: delta});
	}
	
	public function buttonDown(buttonValue:Int):Bool {
		var state:InputState = buttonData.get(buttonValue);
		return state == DOWN || state == PRESSED;
	}
	
	public function buttonUp(buttonValue:Int):Bool {
		var state:InputState = buttonData.get(buttonValue);
		return state == UP || state == RELEASED;
	}
	
	public function buttonPressed(buttonValue:Int):Bool {
		return buttonData.get(buttonValue) == PRESSED;
	}
	
	public function buttonReleased(buttonValue:Int):Bool {
		return buttonData.get(buttonValue) == RELEASED;
	}
	
	override public function update() {
		super.update();
		
		checkQueue(releasedQueue, UP);
		checkQueue(pressedQueue, DOWN);
		
		mouseWheel = 0;
	}
	
	private function checkQueue(queue:Array<Int>, state:InputState) {
		var key:String;
		while (queue.length > 0) {
			var key = queue.pop();
			if (buttonData.exists(key)) {
				buttonData.set(key, state);
			}
		}
	}
	
	public function get_x():Float {
		return _mousePosition.x / Game.gameScaleX;
	}

	public function get_y():Float {
		return _mousePosition.y / Game.gameScaleY;
	}

	public function get_mousePosition():Vector2 {
		return new Vector2((_mousePosition.x - Game.gameOffsetX) / Game.gameScaleX, (_mousePosition.y - Game.gameOffsetY) / Game.gameScaleY);
	}

	public function get_mousePosDelta():Vector2 {
		return new Vector2(_mousePosDelta.x / Game.gameScaleX, _mousePosDelta.y / Game.gameScaleY);
	}
	
	public function get_mouseWheel():Int {
		return this.mouseWheel;
	}
	
	public function clearInput() {
		var buttons = buttonData.keys();
		for (button in buttons) {
			buttonData.set(button, UP);
		}
		
		while (releasedQueue.length > 0) {
			releasedQueue.pop();
		}
		while (pressedQueue.length > 0) {
			pressedQueue.pop();
		}
	}
}