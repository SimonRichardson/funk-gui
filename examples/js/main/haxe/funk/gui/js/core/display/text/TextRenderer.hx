package funk.gui.js.core.display.text;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.gui.core.geom.Rectangle;
import funk.gui.js.core.display.Graphics;
import funk.option.Any;

using funk.collections.immutable.Nil;
using funk.option.Any;

class TextRenderer {

	inline private static var MAX_WIDTH : Int = 10000;

	inline private static var MAX_HEIGHT : Int = 10000;

	public var text(getText, setText) : String;

	public var autoSize(getAutoSize, setAutoSize) : Bool;

	private var _bounds : Rectangle;

	private var _boundsMax : Rectangle;

	private var _boundsMeasured : Rectangle;

	private var _textLines : IList<TextLine>;

	private var _lineSpacing : Int;

	private var _text : String;

	private var _textBlock : TextBlock;

	private var _textElement : TextElement;

	private var _shortend : Bool;

	private var _autoSize : Bool;

	private var _autoEllipsis : Bool;

	public function new(graphics : Graphics) {

		_text = "";
		_textLines = nil.list();

		_textElement = new TextElement(_text);
		_textBlock = new TextBlock(graphics, _textElement);

		_bounds = new Rectangle();	
		_boundsMax = new Rectangle(0, 0, MAX_WIDTH, MAX_HEIGHT);
		_boundsMeasured = new Rectangle();

		_shortend = false;
		_autoSize = true;
		_autoEllipsis = false;
	}

	public function update() : Void {
		measure(_text);
		repaint(_text);
	}

	private function measure(text : String) : Void {
		_bounds.resizeTo(0, 0);

		clearTextLines();

		if(text == null || text == "") return;
		else {
			_textElement.text = text;
			_textBlock.textElement = _textElement;

			var textLine : TextLine = _textBlock.create(null, MAX_WIDTH);
			if(textLine.isEmpty()) return;
			else {

				var lineHeight : Float = textLine.height;

				var h : Float = lineHeight + _lineSpacing;
				while(textLine.isDefined()) {
					_boundsMeasured.height += h;
					if(textLine.width > _boundsMeasured.width) {
						_boundsMeasured.height = textLine.width;
					}
					textLine = _textBlock.create(textLine, MAX_WIDTH);
				}

				_boundsMeasured.width = Math.ceil(_boundsMeasured.width);
				_boundsMeasured.height = Math.ceil(_boundsMeasured.height - _lineSpacing);
			}
		}
	}

	private function repaint(text : String) : Void {
		_bounds.resizeTo(0, 0);

		clearTextLines();

		if(text == null || text == "" || _boundsMax.width < 1 || _boundsMax.height < 1) return;
		else {
			_textElement.text = text;
			_textBlock.textElement = _textElement;

			var textLine : TextLine = _textBlock.create(null, _boundsMax.width);
			if(textLine.isEmpty()) return;
			else {
				var textHeight : Float = textLine.height;
				var textHeightAndSpacing : Float = textHeight + _lineSpacing;

				var lineHeight : Float = textHeight;

				var index : Int = 0;

				while(textLine.isDefined()) {
					if(_bounds.height + textHeight > _boundsMax.height) {
						if(_autoEllipsis && !_shortend) {
							_shortend = true;

							applyEllipsis(index);
							return;
						}

						_shortend = true;
						break;
					}

					index += textLine.charCount;

					_bounds.height += textHeightAndSpacing;

					if(_bounds.width < textLine.width) {
						_bounds.width = textLine.width;
					}

					_textLines = _textLines.append(textLine);

					textLine = _textBlock.create(textLine, _boundsMax.width);
				}

				_bounds.height -= _lineSpacing;

				for(line in _textLines) {
					// TODO (Simon) : Alignment
					var textLine : TextLine = line;
					textLine.y += lineHeight;

					lineHeight += textHeightAndSpacing;
				}

				_shortend = false;
			}
		}
	}

	private function clearTextLines() : Void {
		_textLines = nil.list();
		_textBlock.removeAll();
	}

	private function applyEllipsis(index : Int) : Void {
		if(index > 3)
			repaint(_text.substr(0, index - 3) + "...");
		else 
			repaint("...");
	}

	private function getText() : String {
		return _text;
	}

	private function setText(value : String) : String {
		if(_text != value) {
			_text = value;

			update();
		}
		return _text;
	}

	private function getAutoSize() : Bool {
		return _autoSize;
	}

	private function setAutoSize(value : Bool) : Bool {
		if(_autoSize != value) {
			_autoSize = value;
			if(_autoSize) {

				_boundsMax.width = MAX_WIDTH;
				_boundsMax.height = MAX_HEIGHT;
			}
			update();
		}
		return _autoSize;
	}
}