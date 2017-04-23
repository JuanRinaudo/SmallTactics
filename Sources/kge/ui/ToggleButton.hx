package kge.ui;

import kge.core.Basic;
import kge.core.Game;
import kge.core.Graphic;
import kge.core.Group;
import kge.core.Signal;
import kge.math.CollisionUtils;
import kge.math.Rectangle;
import kge.ui.ToggleButton.ToggleButtonStates;
import kha.Color;
import kha.math.Vector2;
import kge.ui.Text.TextVerticalAlign;
import kge.ui.Text.TextAlign;

enum ToggleButtonStates {
	OVER;
	OUT;
	ON;
	OFF;
}

class ToggleButton extends Group<Basic>
{
	public var buttonState:ToggleButtonStates;
	private var lastState:ToggleButtonStates;
	
	public var buttonValue:Bool;
	
	public var hitbox:Rectangle;
	
	public var graphic:Graphic;
	public var text:Text;
	
	public var onSwitch:Signal = new Signal();
	public var onOut:Signal = new Signal();
	public var onOver:Signal = new Signal();

	public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0, label:String = "")
	{
		super();
		
		this.x = x;
		this.y = y;
		
		graphic = new Graphic(0, 0, width, height);
		add(graphic);
		
		text = new Text(0, 0, width, height, label);
		text.textVerticalAlign = TextVerticalAlign.MIDDLE;
		text.textAlign = TextAlign.CENTER;
		text.fontSize = Math.floor(height * 0.8);
		text.color = Color.Black;
		add(text);
		
		hitbox = new Rectangle(x, y, width, height);
		
		setButtonState(buttonValue ? ON : OFF);
	}
	
	private function checkClick() {
		if (buttonState == OVER) {
			buttonValue = !buttonValue;
			setButtonState(buttonValue ? ON : OFF);
			onSwitch.dispatch([buttonValue]);
		}
	}
	
	private function setButtonState(state:ToggleButtonStates) {
		if (buttonState != state) {
			if(state != ON && state != OFF) {
				if (buttonState == OVER && state == OUT) {
					this.onOut.dispatch();
				} else if (buttonState == OUT && state == OVER) {
					this.onOver.dispatch();
				}
				lastState = state;
			}
			
			buttonState = state;
			if (buttonState == ON) {
				graphic.color = Color.Green;
			} else if (buttonState == OFF) {
				graphic.color = Color.Red;
			}
		}
	}
	
	override function set_exists(value:Bool):Bool 
	{
		if (value) { addListeners(); }
		else { removeListeners(); }
		return super.set_exists(value);
	}
	
	private function addListeners()
	{
		Game.input.mouse.onMouseUp.add(checkClick);
		Game.input.mouse.onMouseMove.add(checkMouseOver);
	}
	
	private function removeListeners()
	{
		Game.input.mouse.onMouseUp.remove(checkClick);
		Game.input.mouse.onMouseMove.remove(checkMouseOver);
	}
	
	inline private function checkMouseOver() {
		var mousePos:Vector2 = Game.input.mouse.mousePosition;
		if (CollisionUtils.pointInsideRect(mousePos, hitbox)) {
			setButtonState(OVER);
		} else {
			setButtonState(OUT);
		}
	}
	
}