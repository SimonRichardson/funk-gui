package funk.gui.js.core.display.text;

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
		if(previousTextLine.isEmpty()) {
			return new TextLine(_graphics, previousTextLine);
		}
		return null;
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