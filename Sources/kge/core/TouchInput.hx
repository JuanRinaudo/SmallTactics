package kge.core;

import kha.input.Surface;

using kge.core.InputState;

class TouchInput extends CoreBase
{
	private var touchData:Map<Int, InputState>;
	private var pressedQueue:Array<Int>;
	private var releasedQueue:Array<Int>;
	
	public var onTouchStart:Signal = new Signal();
	public var onTouchEnd:Signal = new Signal();
	public var onTouchMove:Signal = new Signal();

	public function new() 
	{
		super("Touch Input");
		
		touchData = new Map<Int, InputState>();
		pressedQueue = [];
		releasedQueue = [];
		
		Surface.get(0).notify(touchStartListener, touchEndListener, touchMoveListener);
	}
	
	private function touchStartListener(index:Int, x:Int, y:Int) {
		touchData.set(index, PRESSED);
		pressedQueue.push(index);
		
		onTouchStart.dispatch({index: index, x: x, y: y});
	}
	
	private function touchEndListener(index:Int, x:Int, y:Int) {
		touchData.set(index, PRESSED);
		pressedQueue.push(index);
		
		onTouchEnd.dispatch({index: index, x: x, y: y});
	}
	
	private function touchMoveListener(index:Int, x:Int, y:Int) {
		onTouchMove.dispatch({index: index, x: x, y: y});
	}
	
	public function touchDown(touchValue:Int):Bool {
		var state:InputState = touchData.get(touchValue);
		return state == DOWN || state == PRESSED;
	}
	
	public function touchUp(touchValue:Int):Bool {
		var state:InputState = touchData.get(touchValue);
		return state == UP || state == RELEASED;
	}
	
	public function touchPressed(touchValue:Int):Bool {
		return touchData.get(touchValue) == PRESSED;
	}
	
	public function touchReleased(touchValue:Int):Bool {
		return touchData.get(touchValue) == RELEASED;
	}
	
	override public function update() {
		super.update();
		
		checkQueue(releasedQueue, UP);
		checkQueue(pressedQueue, DOWN);
	}
	
	private function checkQueue(queue:Array<Int>, state:InputState) {
		var key:Int;
		while (queue.length > 0) {
			var key = queue.pop();
			if (touchData.exists(key)) {
				touchData.set(key, state);
			}
		}
	}
	
}