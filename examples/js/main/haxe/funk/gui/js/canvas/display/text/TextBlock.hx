package funk.gui.js.canvas.display.text;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.gui.js.core.display.Graphics;
import funk.option.Any;

using funk.collections.immutable.Nil;
using funk.option.Any;

class TextBlock {
	
	public var textElement(getTextElement, setTextElement) : TextElement;

	private var _graphics : Graphics;

	private var _textElement : TextElement;

	private var _textLines : IList<TextLine>;

	public function new(graphics : Graphics, textElement : TextElement) {
		_graphics = graphics;
		_textElement = textElement;

		_textLines = nil.list();
	}

	public function create(previousTextLine : TextLine, width : Float) : TextLine {
		var p : Int = if(previousTextLine.isEmpty()) {
			0;
		} else {
			var s : Int = 0;
			var pTextLine : TextLine = previousTextLine;
			while(pTextLine.isDefined()){
				s += pTextLine.metrics.size;
				pTextLine = pTextLine.parent;
			}
			s;
		}

		var fullText : String = _textElement.text;

		if(p == fullText.length || fullText.length == 0) {
			return null;
		}

		var text : String = fullText.substr(p);

		var textLine : TextLine = new TextLine(_graphics, _textElement.textFormat, previousTextLine);
		textLine.text = text;
		textLine.measure();

		if(textLine.metrics.width > width) {
			var parts : Array<String> = text.split(" ");

			var part : String = "";
			var previousText : String = "";

			do {
				textLine.text = part;
				textLine.measure();

				if(textLine.metrics.width > width) {
					// Back off and re-measure.
					textLine.text = previousText;
					textLine.measure();
					break;
				}

				previousText = part;

				part += parts.shift() + (parts.length > 0 ? " " : "");

			} while(parts.length > 0);
		}

		_textLines = _textLines.append(textLine);

		return textLine;		
	}

	public function removeAll() : Void {
		_textLines = nil.list();
	}

	private function getTextElement() : TextElement {
		return _textElement;
	}

	private function setTextElement(value : TextElement) : TextElement {
		if(_textElement != value) {
			_textElement = value;
		}
		return _textElement;
	}
}