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
import funk.gui.js.core.event.Events;

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
		if(animating) return;

		switch(type) {
			case UPDATE_ALL_VALUES:
			case UPDATE_ENABLED:
			case UPDATE_HOVERED: //triggerAnimation();
			case UPDATE_FOCUSED:
			case UPDATE_PRESSED: 
		}

		repaint();
	}
	
	public function onComponentCleanup() : Void {
		
	}

	public function containsPoint(point : Point) : Bool {
		//var radius : Float = width * 0.5;
		//var dx : Float = radius - (point.x - bounds.x);
		//var dy : Float = radius - (point.y - bounds.y);
		//return dx * dx + dy * dy <= radius * radius;
		return bounds.containsPoint(point);
	}

	var t : Float;
	var d : Float;
	var sx : Float;
	var sy : Float;
	var fx : Float;
	var fy : Float;
	var animating : Bool;

	private function triggerAnimation() : Void {
		animating = true;

		t = 0;
		d = 40;
		sx = x;
		sy = y;
		fx = Std.random(800);
		fy = Std.random(800);

		Events.render.add(animate);
	}

	private function animate() : Void {
		if(t >= 0 && t < d) {
			var tx = easeInOutQuad(t, sx, fx - sx, d);
			var ty = easeOutCubic(t, sy, fy - sy, d);

			moveTo(tx, ty);
			repaint();
		} else if (t > d) {
			animating = false;
			Events.render.remove(animate);
		}
		t++;
	}

	private function easeInOutQuad(t : Float, b : Float, c : Float, d : Float) : Float {
		t /= d/2;
		if (t < 1) return c/2*t*t + b;
		t--;
		return -c/2 * (t*(t-2) - 1) + b;
	}

	private function easeOutCubic(t : Float, b : Float, c : Float, d : Float) : Float {
		t /= d;
		t--;
		return c*(t*t*t + 1) + b;
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

			var radius : Float = ww * 0.5;

			g.translate(x, y);
			//g.beginFill(color);
			g.beginGradientFill([color, 0x1d1d1d], [1.0, 1.0], [0, 1]);

			//g.drawRect(xx, yy, ww, hh);
			g.drawRoundRect(xx, yy, ww, hh, 10);
			//g.drawCircle(xx + radius, yy + radius, radius);

			g.endFill();

			g.restore();
		}
	}
}
