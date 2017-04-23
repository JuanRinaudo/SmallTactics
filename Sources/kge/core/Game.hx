package kge.core;

import haxe.Constraints.Function;
import kge.config.DefaultData;
import kge.config.DefaultFontStyle;
import kge.core.State;
import kha.Assets;
import kha.Image;
import kha.Scaler;
import kha.System;
import kha.math.FastMatrix3;
import kha.math.Vector2;

import kha.Scheduler;

import kha.Framebuffer;
import kha.Color;
import kha.graphics2.ImageScaleQuality;
import kha.graphics4.DepthStencilFormat;
import kha.ScreenRotation;

#if js
import js.Browser;
import js.html.Document;
import js.html.Element;
import js.html.Event;
#end

enum ResizeStrategy 
{
	NONE;
	FIT_SCREEN;
	SCALE_RATIO;
	RESIZE_CANVAS;
}

class Game extends Group<Basic>
{
	public static var instance:Game;
	
	public static var width:Int;
	public static var height:Int;
	
	public static var title:String;
	
	public static var initialState:Class<Dynamic>;
	
	public static var time:Float = 0;
	public static var deltaTime:Float = 1 / 60;
	public static var currentFrame:Int = 0;
	
	public static var paused:Bool = false;
	public static var pauseOnBlur:Bool = true;
	
	public static var resizeFunction:Function;
	public static var resizeStrategy(default, set):ResizeStrategy;
	public static var onResize:Signal = new Signal();
	
	public static var input:Input;
	
	public static var audio:AudioManager;
	
	private static var mainLoopID:Int;
	
	private static var screenTransform:FastMatrix3;
	
	public static var backbuffer:Image;
	
	private static var lastID:Int = 0;
	
	public static var onRenderBegin:Signal = new Signal();
	public static var onRenderEnd:Signal = new Signal();
	
	public static var loading:Bool = false;
	public static var onLoadComplete:Signal = new Signal();
	
	public static var gameOffsetX:Float = 0;
	public static var gameOffsetY:Float = 0;
	public static var gameScaleX:Float = 1;
	public static var gameScaleY:Float = 1;
	
	public static var backbufferScaleQuality:ImageScaleQuality = ImageScaleQuality.Low;
	
	private var lastState:State;
	
	#if debug
	public var debug:Debug;
	#end
	
	#if js
	public static var canvas:Element;
	#end
	
	public function new(initialState:Class<Dynamic>, width:Int, height:Int, title:String = "Game") {
		super();
		
		instance = this;
		
		Game.width = width != 0 ? width : getScreenWidth();
		Game.height = height != 0 ? height : getScreenHeight();
		
		Game.title = title;
		
		Game.initialState = initialState;
		
		time = 0;
		
		screenTransform = FastMatrix3.identity();
		
		System.init({title: title, width: width, height: height}, initLoader);
		
		#if js
		canvas = Browser.document.getElementById("khanvas");
		
		Browser.window.onblur = pause;
		Browser.window.onfocus = resume;
		canvas.onblur = pause;
		canvas.onfocus = resume;
		
		Browser.window.onresize = resize;
		#end
		
		resizeStrategy = NONE;
	}
	
	public static function pause():Void {
		audio.pauseAll();
		
		input.clearInput();
		
		paused = true && pauseOnBlur;
	}
	
	public static function resume():Void {
		audio.resumeAll();
		
		paused = false;
	}
	
	#if js
	public static function resize(event:Event):Void {
		resizeFunction();
		onResize.dispatch();
	}
	#else
	public static function resize(event:Dynamic):Void {
		
	}
	#end
	
	public static function getNextID():Int {
		return lastID++;
	}
	
	private function initLoader():Void {		
		Game.backbuffer = Image.createRenderTarget(width, height);
		
		System.notifyOnRender(renderPass);
		
		Assets.loadEverything(initGame);
		loading = true;
		
		input = new Input();
		audio = new AudioManager();
	}
	
	private function initGame():Void {
		loading = false;
		Game.onLoadComplete.dispatch();
		
		new DefaultFontStyle(Assets.fonts.KenPixel);
		new DefaultData();
		
		mainLoopID = Scheduler.addTimeTask(update, 0, deltaTime);
		
		lastState = Type.createInstance(initialState, []);
		add(lastState);
		
		#if debug
		debug = new Debug();
		add(debug);
		#end
	}
	
	public function changeState(state:State, destroy:Bool = true) {
		remove(lastState);
		lastState = state;
		addAt(lastState, 0);
	}

	override public function update():Void {
		if(!paused) {
			super.update();
			
			++currentFrame;
			time += deltaTime;
		}
		
		input.update();
		audio.update();
		
		#if debug
		Debug.updateCalls = 0;
		Debug.transformUpdates = 0;
		#end
	}
	
	public function renderPass(framebuffer:Framebuffer) {
		onRenderBegin.dispatch(framebuffer);
		
		backbuffer.g2.begin();
		
		backbuffer.g2.transformation = FastMatrix3.identity();
		render(backbuffer);
		
		if (loading) {
			backbuffer.g2.color = Color.fromFloats(0, 0, 0, 0.5);
			backbuffer.g2.fillRect(0, 0, width, height);
			
			backbuffer.g2.color = Color.fromFloats(1, 1, 1, 0.5);
			backbuffer.g2.fillRect(0, Game.height * 0.4, Game.width * Assets.progress, Game.height * 0.2);
			backbuffer.g2.color = Color.White;
		}
		
		if (paused) {
			backbuffer.g2.color = Color.fromFloats(0, 0, 0, 0.5);
			backbuffer.g2.fillRect(0, 0, width, height);
			
			backbuffer.g2.color = Color.fromFloats(1, 1, 1, 0.5);
			backbuffer.g2.fillTriangle(	width * 0.33, height * 0.33,
										width * 0.33, height * 0.66,
										width * 0.66, height * 0.5);
			backbuffer.g2.color = Color.White;
		}
		
		backbuffer.g2.end();
		
		framebuffer.g2.imageScaleQuality = backbufferScaleQuality;
		framebuffer.g2.begin();
		
		framebuffer.g2.transformation = Game.screenTransform;
		framebuffer.g2.drawImage(backbuffer, 0, 0);
		
		framebuffer.g2.end();
		
		onRenderEnd.dispatch(framebuffer);
	}

	override public function render(framebuffer:Image):Void {
		#if debug
		Debug.drawCalls = 0;
		#end
		
		super.render(backbuffer);
	}
	
	public function setCamera(scaleX:Float, scaleY:Float, offsetX:Float, offsetY:Float)
	{		
		Game.screenTransform._00 = scaleX;
		Game.screenTransform._11 = scaleY;
		
		Game.screenTransform._20 = offsetX;
		Game.screenTransform._21 = offsetY;
	}
	
	private function getScreenWidth():Int {
		#if js
		return canvas.clientWidth;
		#else
		//TODO: LOOK FOR BETTER OPTION
		return backbuffer.width;
		#end
	}
	
	private function getScreenHeight():Int {
		#if js
		return canvas.clientHeight;
		#else
		//TODO: LOOK FOR BETTER OPTION
		return backbuffer.height;
		#end		
	}
	
	private static function set_resizeStrategy(value:ResizeStrategy):ResizeStrategy {
		#if js
		canvas.style.width = "";
		canvas.style.height = "";
		#else
		
		#end
		
		switch (value) {
			case NONE:
				resizeFunction = noResizeFunction;
			case FIT_SCREEN:
				resizeFunction = fitScreenResizeFunction;				
			case SCALE_RATIO:
				resizeFunction = scaleRatioResizeFunction;				
			case RESIZE_CANVAS:
				resizeFunction = canvasResizeFunction;
		}
		resizeFunction();
		
		return resizeStrategy = value;
	}
	
	private static function noResizeFunction() {
		gameScaleX = 1;
		gameScaleY = 1;
		return;
	}
	
	private static function fitScreenResizeFunction() {
		#if js
		gameScaleX = canvas.clientWidth / width;
		gameScaleY = canvas.clientHeight / height;
		#else
		//TODO: IMPLEMENT
		#end
		Game.instance.setCamera(gameScaleX, gameScaleY, 0, 0);
	}
	
	private static function scaleRatioResizeFunction() {
		#if js
		gameScaleX = Math.min(canvas.clientWidth / width, canvas.clientHeight / height);
		gameScaleY = gameScaleX;
		gameOffsetX = (canvas.clientWidth - width * gameScaleX) * 0.5;
		gameOffsetY = (canvas.clientHeight - height * gameScaleY) * 0.5;
		#else
		//TODO: IMPLEMENT
		#end
		Game.instance.setCamera(gameScaleX, gameScaleY, gameOffsetX, gameOffsetY);
	}
	
	private static function canvasResizeFunction() {
		#if js
		canvas.style.width = "100%";
		canvas.style.height = "100%";
		width = Browser.window.innerWidth;
		height = Browser.window.innerHeight;
		backbuffer = Image.createRenderTarget(width, height);
		#end
	}
	
}