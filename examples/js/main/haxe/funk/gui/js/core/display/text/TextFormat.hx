package funk.gui.js.core.display.text;

import funk.option.Any;
import funk.gui.js.core.display.Unit;

using funk.option.Any;
using funk.gui.js.core.display.Unit;

enum TextPosture {
	ITALIC;
	NORMAL;
}

enum TextWeight {
	BOLD;
	NORMAL;
}

class TextFormat {

	public var fontName(default, default) : String;

	public var fontColor(default, default) : Int;

	public var fontSize(getFontSize, setFontSize) : Int;

	public var italic(default, default) : TextPosture;

	public var bold(default, default) : TextWeight;

	public var lineSpacing(default, default) : Float;

	private var _fontSize : Unit;

	public function new(	?fontName : String = "sans-serif",
							?fontColor : Int = 0xffffff,
							?fontSize : Int = 14,
							?italic : TextPosture = null,
							?bold : TextWeight = null,
							?lineSpacing : Float = 0) {
		this.fontName = fontName;
		this.fontColor = fontColor;
		
		_fontSize = px(fontSize);

		this.italic = italic.isDefined() ? italic : TextPosture.NORMAL;
		this.bold = bold.isDefined() ? bold : TextWeight.NORMAL;
		this.lineSpacing = lineSpacing;
	}

	private function getFontSize() : Int {
		return switch(_fontSize) {
			case em(value): Std.int(value);
			case percent(value): Std.int(value);
			case px(value): Std.int(value);
		}
	}

	private function setFontSize(value : Int) : Int {
		_fontSize = px(value);
		return value;
	}

	public function toString() : String {
		var f : String = _fontSize.format();
		var n : String = fontName;
		return Std.format("$f $n");
	}
}