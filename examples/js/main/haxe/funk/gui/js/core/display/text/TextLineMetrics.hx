package funk.gui.js.core.display.text;

class TextLineMetrics {

	public var size(getSize, never) : Int;

	private var _size : Int;

	public function new() {
		_size = 0;
	}

	private function getSize(): Int {
		return _size;
	}
}