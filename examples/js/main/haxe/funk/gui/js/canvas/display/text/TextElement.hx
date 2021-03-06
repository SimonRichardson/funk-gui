package funk.gui.js.canvas.display.text;

class TextElement {
	
	public var text(getText, setText) : String;

	public var textFormat(getTextFormat, setTextFormat) : TextFormat;

	private var _text : String;

	private var _textFormat : TextFormat;

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

	private function getTextFormat() : TextFormat {
		return _textFormat;
	}

	private function setTextFormat(value : TextFormat) : TextFormat {
		if(_textFormat != value) {
			_textFormat = value;
		}
		return _textFormat;
	}
}