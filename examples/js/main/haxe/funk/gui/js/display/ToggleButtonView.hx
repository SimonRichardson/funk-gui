package funk.gui.js.display;

import funk.gui.button.ToggleButton;
import funk.gui.button.ButtonModel;
import funk.gui.button.IToggleButtonView;
import funk.gui.core.IComponent;
import funk.gui.core.IComponentModel;
import funk.gui.core.ComponentModel;
import funk.gui.core.ComponentState;
import funk.option.Any;

import funk.gui.js.core.display.GraphicsComponentView;

import js.Lib;

using funk.option.Any;

class ToggleButtonView extends GraphicsComponentView, implements IToggleButtonView {
		
	private var _toggleButton : ToggleButton;	
	
	public function new() {
		super();
	}
	
	public function onComponentInitialize(component : IComponent) : Void {
		_toggleButton = cast component;
		
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
		if(type == ComponentStateType.UPDATE_ENABLED) {
			
		}
		
		repaint();
	}
	
	public function onComponentCleanup() : Void {
		
	}
	
	private function repaint() : Void {
		if(_toggleButton.isDefined()) {
			
			graphics.clear();
			graphics.translate(x, y);

			if(_toggleButton.enabled) {
				if(_toggleButton.hovered) {
					if(_toggleButton.pressed) {
						graphics.beginFill(0xff0000);
					} else {
						graphics.beginFill(0x0000ff);	
					}
				} else {
					graphics.beginFill(0xff00ff);
				}
			} else {
				graphics.beginFill(0x1d1d1d);
			}

			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	}
}
