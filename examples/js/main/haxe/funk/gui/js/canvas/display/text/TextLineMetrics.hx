package funk.gui.js.canvas.display.text;

class TextLineMetrics {

	public var size(getSize, setSize) : Int;

	public var width(getWidth, setWidth) : Float;

	public var height(getHeight, setHeight) : Float;

	private var _size : Int;

	private var _width : Float;

	private var _height : Float;

	public function new() {
		reset();
	}

	public function reset() : Void {
		_size = 0;
		_width = 0.0;
		_height = 0.0;
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

	private function getHeight() : Float {
		return _height;
	}

	private function setHeight(value : Float) : Float {
		_height = value;
		return _height;
	}
}