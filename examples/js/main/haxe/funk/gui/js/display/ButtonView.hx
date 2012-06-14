package funk.gui.js.display;

import funk.gui.button.Button;
import funk.gui.button.ButtonModel;
import funk.gui.button.IButtonView;
import funk.gui.core.IComponent;
import funk.gui.core.IComponentModel;
import funk.gui.core.ComponentModel;
import funk.gui.core.ComponentState;
import funk.gui.core.events.IComponentEventTarget;
import funk.gui.core.geom.Point;
import funk.option.Any;

import funk.gui.js.core.display.Graphics;
import funk.gui.js.core.display.GraphicsComponentView;

import js.Lib;

using funk.option.Any;

class ButtonView extends GraphicsComponentView, implements IButtonView {
		
	private var _button : Button;	
	
	public function new(id : Int) {
		super(id);
	}
	
	public function onComponentInitialize(component : IComponent) : Void {
		_button = cast component;
		
	}
	
	public function onComponentMove(x : Float, y : Float) : Void {
		moveTo(x, y);

		repaint();
	}
	
	public function onComponentResize(width : Float, height : Float) : Void {
		resizeTo(width, height);
		
		width -= (_padding.left + _padding.right);
		height -= (_padding.top + _padding.bottom);
		
		repaint();
	}
	
	public function onComponentModelUpdate(model : IComponentModel, type : Int) : Void {
		switch(type) {
			case ComponentModel.UPDATE_ALL_VALUES: repaint();
		}
	}
	
	public function onComponentStateUpdate(state : ComponentState, type : ComponentStateType) : Void {
		switch(type) {
			case UPDATE_ALL_VALUES: repaint();
			case UPDATE_ENABLED: repaint();
			case UPDATE_HOVERED: repaint();
			case UPDATE_FOCUSED: repaint();
			case UPDATE_PRESSED: repaint();
		}
	}
	
	public function onComponentCleanup() : Void {
		
	}

	public function containsPoint(point : Point) : Bool {
		//var radius : Float = width * 0.5;
		//var dx : Float = radius - (point.x - bounds.x);
		//var dy : Float = radius - (point.y - bounds.y);
		//return Math.sqrt(dx * dx + dy * dy) <= radius;
		return bounds.containsPoint(point);
	}
	
	private function repaint() : Void {
		if(_button.isDefined()) {

			var xx : Float = 0;
			var yy : Float = 0;
			var ww : Float = width;
			var hh : Float = height;

			var color : Int = if(_button.enabled) {
				if(_button.hovered) {
					xx = -10;
					yy = -10;
					ww = width + 20;
					hh = height + 20;

					if(_button.pressed) {
						0xff0000;
					} else {
						0x0000ff;	
					}
				} else {
					0xc1c1c1;
				}
			} else {
				0x110011;
			}
			
			var g : Graphics = graphics;

			g.clear();
			g.save();

			g.translate(x, y);
			g.beginFill(color);
			g.drawRect(xx, yy, ww, hh);
			//var radius : Float = ww * 0.5;
			//g.drawCircle(xx + radius, yy + radius, radius);
			g.endFill();

			g.restore();
		}
	}
}
