package funk.gui.js.display;

import funk.gui.core.IComponent;
import funk.gui.core.IComponentModel;
import funk.gui.core.ComponentModel;
import funk.gui.core.ComponentState;
import funk.gui.core.events.IComponentEventTarget;
import funk.gui.core.events.IComponentEventTargetHook;
import funk.gui.core.geom.Point;
import funk.gui.text.Label;
import funk.gui.text.LabelModel;
import funk.gui.text.ILabelView;
import funk.option.Any;
import funk.gui.js.core.event.Events;

import funk.gui.js.core.display.Graphics;
import funk.gui.js.core.display.GraphicsComponentView;
import funk.gui.js.core.display.text.TextRenderer;

import js.Lib;

using funk.option.Any;

class LabelView extends GraphicsComponentView, 
									implements ILabelView, 
									implements IComponentEventTargetHook {
		
	private var _label : Label;

	private var _textRenderer : TextRenderer;
	
	public function new() {
		super();
	}
	
	public function onComponentInitialize(component : IComponent) : Void {
		_label = cast component;
		_label.addCaptureHook(this);

		_textRenderer = new TextRenderer(graphics);
		_textRenderer.autoSize = false;
	}
	
	public function onComponentMove(x : Float, y : Float) : Void {
		moveTo(x, y);

		_textRenderer.moveTo(x + _padding.left, y + _padding.top);

		repaint();
	}
	
	public function onComponentResize(width : Float, height : Float) : Void {
		resizeTo(width, height);
		
		width -= (_padding.left + _padding.right);
		height -= (_padding.top + _padding.bottom);
		
		_textRenderer.resizeTo(width, height);

		repaint();
	}
	
	public function onComponentModelUpdate(model : IComponentModel, type : Int) : Void {
		switch(type) {
			case ComponentModel.UPDATE_ALL_VALUES: 
				_textRenderer.text = _label.text;
				updateTextRenderer();
				updatePositioning();
			case LabelModel.UPDATE_TEXT:
				_textRenderer.text = _label.text;
				updateTextRenderer();
				updatePositioning();
			case LabelModel.UPDATE_ICON:
				updatePositioning();
		}
		
		repaint();
	}
	
	public function onComponentStateUpdate(state : ComponentState, type : ComponentStateType) : Void {
		switch(type) {
			case UPDATE_ALL_VALUES:
			case UPDATE_ENABLED:
			case UPDATE_HOVERED:
			case UPDATE_FOCUSED:
			case UPDATE_PRESSED: 
		}
	}

	public function onComponentCleanup() : Void {
		_label.removeCaptureHook(this);
	}

	public function captureEventTarget(point : Point) : IComponentEventTarget {
		return bounds.containsPoint(point) ? _label : null;
	}
	
	private function repaint() : Void {
		if(_label.isDefined()){
			_textRenderer.render();	
		}
	}

	private function updateTextRenderer() : Void {
		
	}

	private function updatePositioning() : Void {
		
	}
}
