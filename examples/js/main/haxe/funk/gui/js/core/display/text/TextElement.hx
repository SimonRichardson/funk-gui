package funk.gui.js.core.display.text;

class TextElement {
	
	public var text(getText, setText) : String;

	private var _text : String;

	private var _position : Int;

	public function new(?text : String = "") {
		_text = text;
		_position = 0;
	}

	private function getText() : String {
		return _text;
	}

	private function setText(value : String) : String {
		if(_text != value) {
			_text = value;
			_position = 0;
		}
		return _text;
	}
}