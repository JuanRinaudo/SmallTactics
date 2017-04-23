package kge.core;

import kha.Framebuffer;
import kha.Image;

class Group<T:Basic> extends Basic
{
	
	private var childrens:Array<T>;
	public var length(get, null):Int;
	
	public function new() 
	{
		childrens = [];
		
		super(0, 0);
	}
	
	public function add(child:T) {
		childrens.push(child);
	}
	
	public function addAt(child:T, index:Int) {
		childrens.insert(index, child);
	}
	
	public function remove(child:T) {
		childrens.remove(child);
	}
	
	override public function update() 
	{
		super.update();
		
		for (child in childrens) {
			if (child.exists) {
				child.update();
			}
		}
	}
	
	override public function render(framebuffer:Image) 
	{
		super.render(framebuffer);
		
		framebuffer.g2.pushTransformation(transform.multmat(framebuffer.g2.transformation));
		
		for (child in childrens) {
			if (child.visible) {
				child.render(framebuffer);				
			}
		}
		
		framebuffer.g2.popTransformation();
	}
	
	override public function destroy() 
	{
		super.destroy();
		
		for (child in childrens) {
			child.destroy();
		}
		childrens = null;
	}
	
	public function get_length():Int {
		return childrens.length;
	}
	
	public function iterator()
	{
		return childrens.iterator();
	}
	
}