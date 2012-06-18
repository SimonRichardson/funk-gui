package funk.gui.js.core.display.text;

import funk.option.Any;
import funk.gui.core.geom.Rectangle;
import funk.gui.js.core.display.Graphics;

using funk.option.Any;

class TextLine {

	public var parent(getParent, never) : TextLine;

	public var x(getX, setX) : Float;

	public var y(getY, setY) : Float;

	public var width(getWidth, never) : Float;

	public var height(getHeight, never) : Float;
	
	public var charCount(getCharCount, never) : Int;

	private var _parent : TextLine;

	private var _bounds : Rectangle;

	private var _metrics : TextLineMetrics;

	private var _graphics : Graphics;

	public function new(graphics : Graphics, parent : TextLine) {
		_graphics = graphics;
		_parent = parent;
		_bounds = new Rectangle(0, 0, 40, 40);
		_metrics = new TextLineMetrics();
	}

	private function repaint() : Void {
		if(_graphics.isDefined()) {
			var g : Graphics = _graphics;

			trace("REPAINT");

			g.clear();
			g.save();
			
			g.beginFill(0xffffff);
			g.createText("FUCK YOU!", _bounds.x, _bounds.y);
			g.endFill();

			g.restore();
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
			repaint();
		}
		return _bounds.x;
	}

	public function getY() : Float {
		return _bounds.y;
	}

	public function setY(value : Float) : Float {
		if(_bounds.y != value) {
			_bounds.y = value;
			repaint();
		}
		return _bounds.y;
	}

	private function getWidth() : Float {
		return _bounds.width;
	}

	private function getHeight() : Float {
		return _bounds.height;
	}

	private function getCharCount() : Int {
		return _metrics.size;
	}
}