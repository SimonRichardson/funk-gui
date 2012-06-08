package funk.gui.js.display;

import funk.gui.button.Button;
import funk.gui.button.ButtonModel;
import funk.gui.button.IButtonView;
import funk.gui.core.IComponent;
import funk.gui.core.IComponentModel;
import funk.gui.core.ComponentModel;
import funk.gui.core.ComponentState;
import funk.option.Any;

import funk.gui.js.core.display.GraphicsComponentView;

import js.Lib;

using funk.option.Any;

class ButtonView extends GraphicsComponentView, implements IButtonView {
		
	private var _button : Button;	
	
	public function new() {
		super();
	}
	
	public function onComponentInitialize(component : IComponent) : Void {
		_button = cast component;
		
	}
	
	public function onComponentMove(x : Float, y : Float) : Void {
		moveTo(x, y);
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
		if(_button.isDefined()) {
			
			if(_button.enabled) {
				if(_button.hovered) {
					if(_button.pressed) {
						
					} else {
						
					}
				} else {
					
				}
			}
		}
	}
}
