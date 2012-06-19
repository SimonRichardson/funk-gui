package funk.gui.js.core.display.text;

class TextLineMetrics {

	public var size(getSize, setSize) : Int;

	public var width(getWidth, setWidth) : Float;

	private var _size : Int;

	private var _width : Float;

	public function new() {
		_size = 0;
		_width = 0.0;
	}

	private function getSize(): Int {
		return _size;
	}

	private function setSize(value : Int) : Int {
		_size = value;
		return _size;
	}

	private function getWidth() : Float {
		return _width;
	}

	private function setWidth(value : Float) : Float {
		_width = value;
		return _width;
	}
}