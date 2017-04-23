package kge.ui;

import kge.config.DefaultButtonStyle;
import kge.core.Basic;
import kge.core.Entity;
import kge.core.Game;
import kge.core.Graphic;
import kge.core.Group;
import kge.core.Signal;
import kge.math.CollisionUtils;
import kge.math.Rectangle;
import kha.Color;
import kha.math.Vector2;
import kge.ui.Text.TextVerticalAlign;
import kge.ui.Text.TextAlign;

enum ButtonStates {
	OVER;
	OUT;
	CLICK;
}

interface ButtonStyle {
	public var clickColor:Color;
	public var overColor:Color;
	public var outColor:Color;
	
	public var textColor:Color;	
	public var textSize:Int;
	public var textSizeModifier:Float;
	public var textAlign:TextAlign;
	public var textVerticalAlign:TextVerticalAlign;
	public var textOffset:Vector2;
}

class Button extends Group<Basic>
{
	public var style:ButtonStyle = DefaultButtonStyle.instance;
	
	public var buttonState:ButtonStates;
	
	public var hitbox:Rectangle;
	
	public var graphic:Graphic;
	public var text:Text;
	public var imageLabel:Graphic;
	
	public var alpha(get, set):Float;
	
	public var onClick:Signal = new Signal();
	public var onOut:Signal = new Signal();
	public var onOver:Signal = new Signal();

	public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0, label:String = "", buttonStyle:ButtonStyle = null) {		
		hitbox = new Rectangle(x, y, width, height);
		
		super();
		
		this.x = x;
		this.y = y;
		
		if (buttonStyle != null) {
			style = buttonStyle;
		}
		
		graphic = new Graphic(0, 0, width, height);
		add(graphic);
		
		text = new Text(0, 0, width, height, label);
		text.textAlign = style.textAlign;
		text.textVerticalAlign = style.textVerticalAlign;
		text.fontSize = Math.floor(style.textSize > 0 ? style.textSize : height * style.textSizeModifier);
		text.color = Color.Black;
		add(text);
		
		imageLabel = new Graphic(0, 0, width, height);
		imageLabel.setRectangle(0, 0);
		add(imageLabel);
		
		setButtonState(OUT);
		
		addListeners();
	}
	
	private function checkClick() {
		if (buttonState == OVER) {
			onClick.dispatch();
		}
	}
	
	override public function update() {
		super.update();
	}
	
	private function setButtonState(state:ButtonStates) {		
		if(buttonState != state) {
			if (buttonState == OVER && state == OUT) {
				this.onOut.dispatch();
			} else if (buttonState == OUT && state == OVER) {
				this.onOver.dispatch();
			}
			
			buttonState = state;
			refreshButtonStyle();
		}
	}
	
	private function refreshButtonStyle() {
		if (buttonState == OUT) {
			graphic.color = style.outColor;
		} else if(buttonState == OVER) {
			graphic.color = style.overColor;
		} else {
			graphic.color = style.clickColor;
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
		Game.input.mouse.onMouseDown.add(checkMouseOver);
		Game.input.mouse.onMouseDown.add(checkClick);
		Game.input.mouse.onMouseMove.add(checkMouseOver);
	}
	
	private function removeListeners()
	{
		Game.input.mouse.onMouseDown.remove(checkMouseOver);
		Game.input.mouse.onMouseDown.remove(checkClick);
		Game.input.mouse.onMouseMove.remove(checkMouseOver);
	}
	
	override function set_x(value:Float):Float 
	{
		hitbox.x = value;
		return super.set_x(value);
	}
	
	override function set_y(value:Float):Float 
	{
		hitbox.y = value;
		return super.set_y(value);
	}
	
	public function get_alpha():Float {
		return graphic.alpha;
	}
	
	public function set_alpha(value:Float):Float {
		graphic.alpha = value;
		text.alpha = value;
		imageLabel.alpha = value;
		return value;
	}
	
	inline private function checkMouseOver() {
		if (CollisionUtils.pointInsideRect(Game.input.mouse.mousePosition, hitbox)) {
			setButtonState(OVER);//setButtonState(Game.input.mouse.buttonDown(0) ? CLICK : OVER);
		} else {
			setButtonState(OUT);
		}
	}
	
}