package funk.gui.js.core.display.text;

import funk.option.Any;
import funk.gui.core.geom.Rectangle;
import funk.gui.js.core.display.Graphics;
import funk.gui.js.core.display.Painter;

import js.w3c.html5.Canvas2DContext;

using funk.option.Any;
using funk.gui.js.core.display.Painter;

class TextLine {

	public var parent(getParent, never) : TextLine;

	public var x(getX, setX) : Float;

	public var y(getY, setY) : Float;

	public var width(getWidth, never) : Float;

	public var height(getHeight, never) : Float;

	public var text(getText, setText) : String;

	public var metrics(getMetrics, never) : TextLineMetrics;
	
	private var _parent : TextLine;

	private var _bounds : Rectangle;

	private var _metrics : TextLineMetrics;

	private var _text : String;

	private var _graphics : Graphics;

	private var _textFormat : TextFormat;

	public function new(graphics : Graphics, textFormat : TextFormat, parent : TextLine) {
		_graphics = graphics;
		_textFormat = textFormat;
		_parent = parent;

		_text = "";

		_bounds = new Rectangle(0, 0, 0, 0);
		_metrics = new TextLineMetrics();
	}

	public function render() : Void {
		measure();
		repaint();
	}

	public function measure() : Void {
		if(_graphics.isDefined() && _textFormat.isDefined()){
			_text.measureText(_metrics, _textFormat);
		} else {
			_metrics.reset();
		}

		_bounds.width = _metrics.width;
		_bounds.height = _metrics.height;
	}

	private function repaint() : Void {
		if(_graphics.isDefined()) {
			var g : Graphics = _graphics;

			g.beginFill(_textFormat.fontColor);
			g.createText(_text, _textFormat.toString(), _bounds);
			g.endFill();
		}
	}

	private function getParent() : TextLine {
		return _parent;
	}

	public function getX() : Float {
		return _bounds.x;
	}

	public function setX(value : Float) : Float {
		if(_bounds.x != value){
			_bounds.x = value;
		}
		return _bounds.x;
	}

	public function getY() : Float {
		return _bounds.y;
	}

	public function setY(value : Float) : Float {
		if(_bounds.y != value) {
			_bounds.y = value;
		}
		return _bounds.y;
	}

	private function getWidth() : Float {
		return _bounds.width;
	}

	private function getHeight() : Float {
		return _bounds.height;
	}

	private function getText() : String {
		return _text;
	}

	private function setText(value : String) : String {
		if(_text != value) {
			_text = value;
			_metrics.size = _text.length;
		}
		return _text;
	}

	private function getMetrics() : TextLineMetrics {
		return _metrics;
	}
}