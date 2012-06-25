package funk.gui.js.dom.components;

import funk.gui.button.Button;
import funk.gui.button.ButtonModel;
import funk.gui.button.IButtonView;
import funk.gui.core.IComponent;
import funk.gui.core.IComponentModel;
import funk.gui.core.ComponentModel;
import funk.gui.core.ComponentState;
import funk.gui.core.events.IComponentEventTarget;
import funk.gui.core.events.IComponentEventTargetHook;
import funk.gui.core.geom.Point;
import funk.gui.text.Label;
import funk.option.Any;

import funk.gui.js.dom.display.GraphicsComponentView;
import funk.gui.js.core.display.Graphics;

import js.Lib;

using funk.option.Any;

class ButtonView extends GraphicsComponentView, 
								implements IButtonView, 
								implements IComponentEventTargetHook {
		
	private var _button : Button;
	
	public function new() {
		super();
	}
	
	public function onComponentInitialize(component : IComponent) : Void {
		_button = cast component;
		_button.addCaptureHook(this);
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
			case ComponentModel.UPDATE_ALL_VALUES:
				repaint();
			case ButtonModel.UPDATE_TEXT:
			case ButtonModel.UPDATE_ICON:
				repaint();
		}
	}
	
	public function onComponentStateUpdate(state : ComponentState, type : ComponentStateType) : Void {
		switch(type) {
			case UPDATE_ALL_VALUES:
			case UPDATE_ENABLED:
			case UPDATE_HOVERED:
			case UPDATE_FOCUSED:
			case UPDATE_PRESSED: 
		}

		repaint();
	}

	public function onComponentCleanup() : Void {
		_button.removeCaptureHook(this);
	}

	public function captureEventTarget(point : Point) : IComponentEventTarget {
		return bounds.containsPoint(point) ? _button : null;
	}
	
	private function repaint() : Void {
		if(_button.isDefined()) {

			var color : Int = if(_button.enabled) {
				if(_button.hovered) {
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
			//g.drawRect(0, 0, width, height);
			g.drawCircle(0, 0, width);
			g.endFill();

			g.restore();
		}
	}
}
