package funk.gui.js.canvas.components;

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
import funk.gui.js.canvas.event.Events;

import funk.gui.js.canvas.display.Graphics;
import funk.gui.js.canvas.display.GraphicsComponentView;

import js.Lib;

using funk.option.Any;

class ButtonView extends GraphicsComponentView, 
								implements IButtonView, 
								implements IComponentEventTargetHook {
		
	private var _button : Button;

	private var _label : Label;
	
	public function new() {
		super();
	}
	
	public function onComponentInitialize(component : IComponent) : Void {
		_button = cast component;
		_button.addCaptureHook(this);

		_padding.left = 0;
		_padding.top = 0;
		_padding.bottom = 10;

		var labelView : LabelView = new LabelView();
		_label = new Label(labelView);
		addView(labelView);
	}
	
	public function onComponentMove(x : Float, y : Float) : Void {
		moveTo(x, y);

		_label.moveTo(x + _padding.left, y + _padding.top);

		repaint();
	}
	
	public function onComponentResize(width : Float, height : Float) : Void {
		resizeTo(width, height);

		width -= (_padding.left + _padding.right);
		height -= (_padding.top + _padding.bottom);
		
		_label.resizeTo(width, height);

		repaint();
	}
	
	public function onComponentModelUpdate(model : IComponentModel, type : Int) : Void {
		switch(type) {
			case ComponentModel.UPDATE_ALL_VALUES: 
				_label.text = _button.text;
				repaint();
			case ButtonModel.UPDATE_TEXT:
				_label.text = _button.text;
			case ButtonModel.UPDATE_ICON:
				repaint();
		}
	}
	
	public function onComponentStateUpdate(state : ComponentState, type : ComponentStateType) : Void {
		switch(type) {
			case UPDATE_ALL_VALUES:
			case UPDATE_ENABLED:
				_label.enabled = state.enabled;
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
			g.drawRect(0, 0, width, height);
			g.endFill();

			g.restore();
		}
	}
}
