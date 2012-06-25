package funk.gui.js.canvas.components;

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

import funk.gui.js.core.display.GraphicsComponentView;
import funk.gui.js.canvas.display.text.TextFormat;
import funk.gui.js.canvas.display.text.TextRenderer;

import js.Lib;

using funk.option.Any;

enum LabelViewFontRendering {
	ALL;
	FONT_FORMAT;
	FONT_POSTURE;
}

class LabelView extends GraphicsComponentView, 
									implements ILabelView, 
									implements IComponentEventTargetHook {
	
	public var textFormat(getTextFormat, setTextFormat) : TextFormat;

	public var fontName(getFontName, setFontName) : String;

	public var fontColor(getFontColor, setFontColor) : Int;

	public var fontSize(getFontSize, setFontSize) : Int;

	public var italic(getItalic, setItalic) : Bool;

	public var bold(getBold, setBold) : Bool;

	public var lineSpacing(getLineSpacing, setLineSpacing) : Float;

	private var _label : Label;

	private var _textFormat : TextFormat;

	private var _textRenderer : TextRenderer;
	
	public function new() {
		super();
	}
	
	public function onComponentInitialize(component : IComponent) : Void {
		_label = cast component;
		_label.addCaptureHook(this);

		_textFormat = new TextFormat();
		_textFormat.fontSize = 24;

		_textRenderer = new TextRenderer(graphics);
		_textRenderer.autoSize = true;
		_textRenderer.textFormat = _textFormat;
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
				updateTextRenderer(ALL);
				updatePositioning();
			case LabelModel.UPDATE_TEXT:
				_textRenderer.text = _label.text;
				updateTextRenderer(ALL);
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

	private function updateTextRenderer(type : LabelViewFontRendering) : Void {
		var textFormat : TextFormat = _textRenderer.textFormat;
		switch(type) {
			case ALL: 
				_textRenderer.textFormat = _textFormat;		
			case FONT_FORMAT:
				_textRenderer.textFormat.fontName = _textFormat.fontName;
				_textRenderer.textFormat.fontColor = _textFormat.fontColor;
				_textRenderer.textFormat.fontSize = _textFormat.fontSize;
				_textRenderer.render();
			case FONT_POSTURE:
				_textRenderer.textFormat.bold = _textFormat.bold;
				_textRenderer.textFormat.italic = _textFormat.italic;
				_textRenderer.render();
		}		
	}

	private function updatePositioning() : Void {
		
	}

	private function getTextFormat() : TextFormat {
		return _textFormat;
	}

	private function setTextFormat(value : TextFormat) : TextFormat {
		if(_textFormat != value) {
			_textFormat = value;

			updateTextRenderer(FONT_FORMAT);
			repaint();
		}
		return _textFormat;
	}

	private function getFontName() : String {
		return _textFormat.fontName;
	}

	private function setFontName(value : String) : String {
		if (value != _textFormat.fontName){
			_textFormat.fontName = value;
			
			updateTextRenderer(FONT_FORMAT);
		}
		return _textFormat.fontName;
	}

	private function getFontSize() : Int {
		return _textFormat.fontSize;
	}

	private function setFontSize(value : Int) : Int {
		if (value != _textFormat.fontSize){
			_textFormat.fontSize = value;
			
			updateTextRenderer(FONT_FORMAT);
		}
		return _textFormat.fontSize;
	}

	private function getFontColor() : Int {
		return _textFormat.fontColor;
	}

	private function setFontColor(value : Int) : Int {
		if (value != _textFormat.fontColor){
			_textFormat.fontColor = value;
			
			updateTextRenderer(FONT_FORMAT);
		}
		return _textFormat.fontColor;
	}

	private function getItalic() : Bool {
		return switch(_textFormat.italic) {
			case TextPosture.ITALIC: true;
			case TextPosture.NORMAL: false;
		};
	}

	private function setItalic(value : Bool) : Bool {
		_textFormat.italic = switch(value){
			case true:  TextPosture.ITALIC;
			case false:  TextPosture.NORMAL;
		};

		updateTextRenderer(FONT_POSTURE);
		
		return switch(_textFormat.italic) {
			case TextPosture.ITALIC: true;
			case TextPosture.NORMAL: false;
		};
	}

	private function getBold() : Bool {
		return switch(_textFormat.bold) {
			case BOLD: true;
			case NORMAL: false;
		};
	}

	private function setBold(value : Bool) : Bool {
		_textFormat.bold = switch(value){
			case true: TextWeight.BOLD;
			case false: TextWeight.NORMAL;
		};

		updateTextRenderer(FONT_POSTURE);

		return switch(_textFormat.bold) {
			case TextWeight.BOLD: true;
			case TextWeight.NORMAL: false;
		};
	}

	private function getLineSpacing() : Float {
		return _textFormat.lineSpacing;
	}

	private function setLineSpacing(value : Float) : Float {
		if (value != _textFormat.lineSpacing){
			_textFormat.lineSpacing = value;
			
			updateTextRenderer(ALL);
		}
		return _textFormat.lineSpacing;
	}
}
