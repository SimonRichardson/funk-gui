package funk.gui.js.core.display.text;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.gui.core.geom.Rectangle;
import funk.gui.js.core.display.Graphics;
import funk.option.Any;

using funk.collections.immutable.Nil;
using funk.option.Any;

class TextRenderer {

	inline private static var AUTOSIZE_WIDTH : Int = 99999;

	inline private static var AUTOSIZE_HEIGHT : Int = 99999;

	public var text(getText, setText) : String;

	public var autoSize(getAutoSize, setAutoSize) : Bool;

	public var x(getX, setX) : Float;

	public var y(getY, setY) : Float;

	public var width(getWidth, setWidth) : Float;

	public var height(getHeight, setHeight) : Float;

	public var textFormat(getTextFormat, setTextFormat) : TextFormat;

	public var lineSpacing(getLineSpacing, never) : Float;

	private var _graphics : Graphics;

	private var _bounds : Rectangle;

	private var _boundsMax : Rectangle;

	private var _boundsMeasured : Rectangle;

	private var _textLines : IList<TextLine>;

	private var _text : String;

	private var _textBlock : TextBlock;

	private var _textElement : TextElement;

	private var _shortend : Bool;

	private var _autoSize : Bool;

	private var _autoEllipsis : Bool;

	private var _textFormat : TextFormat;

	public function new(graphics : Graphics) {

		_graphics = graphics;

		_text = "";
		_textLines = nil.list();

		_textElement = new TextElement(_text);
		_textBlock = new TextBlock(graphics, _textElement);

		_bounds = new Rectangle();	
		_boundsMax = new Rectangle(0, 0, AUTOSIZE_WIDTH, AUTOSIZE_HEIGHT);
		_boundsMeasured = new Rectangle();

		_shortend = false;
		_autoSize = true;
		_autoEllipsis = true;

		_textFormat = new TextFormat();
	}

	public function moveTo(x : Float, y : Float) : Void {
		if(_bounds.x != x || _bounds.y != y) {
			_bounds.x = x;
			_bounds.y = y;

			render();
		}
	}

	public function resizeTo(width : Float, height : Float) : Void {
		if(!_autoSize && (_boundsMax.width != width || _boundsMax.height != height)) {
			_boundsMax.width = width;
			_boundsMax.height = height;

			render();
		}
	}

	public function render() : Void {
		measure(_text);
		repaint(_text);
	}

	private function measure(text : String) : Void {
		_bounds.resizeTo(0, 0);

		clearTextLines();

		if(text == null || text == "") return;
		else {
			_textElement.text = text;
			_textElement.textFormat = _textFormat;

			_textBlock.textElement = _textElement;

			var textLine : TextLine = _textBlock.create(null, _boundsMax.width);
			if(textLine.isEmpty()) return;
			else {

				var lineHeight : Float = textLine.height;

				var h : Float = lineHeight + lineSpacing;
				while(textLine.isDefined()) {
					_boundsMeasured.height += h;
					if(textLine.width > _boundsMeasured.width) {
						_boundsMeasured.height = textLine.width;
					}
					textLine = _textBlock.create(textLine, _boundsMax.width);
				}

				_boundsMeasured.width = Math.ceil(_boundsMeasured.width);
				_boundsMeasured.height = Math.ceil(_boundsMeasured.height - lineSpacing);
			}
		}
	}

	private function repaint(text : String) : Void {
		_bounds.resizeTo(0, 0);

		clearTextLines();

		if(text == null || text == "" || _boundsMax.width < 1 || _boundsMax.height < 1) return;
		else {
			_textElement.text = text;
			_textElement.textFormat = _textFormat;

			_textBlock.textElement = _textElement;

			var textLine : TextLine = _textBlock.create(null, _boundsMax.width);
			if(textLine.isEmpty()) return;
			else {
				var textHeight : Float = textLine.height;
				var textHeightAndSpacing : Float = textHeight + lineSpacing;

				var lineHeight : Float = _bounds.y + textHeight;

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
					
					index += textLine.metrics.size;

					_bounds.height += textHeightAndSpacing;

					if(_bounds.width < textLine.width) {
						_bounds.width = textLine.width;
					}

					_textLines = _textLines.append(textLine);

					textLine = _textBlock.create(textLine, _boundsMax.width);
				}
				
				_bounds.height -= lineSpacing;

				// Clear the graphics
				_graphics.clear();
				_graphics.save();

				for(line in _textLines) {
					// TODO (Simon) : Alignment
					var textLine : TextLine = line;
					textLine.x = _bounds.x;
					textLine.y += lineHeight;
					textLine.render();

					lineHeight += textHeightAndSpacing;
				}

				_graphics.restore();

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

			render();
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
				_boundsMax.width = AUTOSIZE_WIDTH;
				_boundsMax.height = AUTOSIZE_HEIGHT;
			}

			render();
		}
		return _autoSize;
	}

	private function getX() : Float {
		return _bounds.x;
	}

	private function setX(value : Float) : Float {
		if(_bounds.x != value) {
			_bounds.x = value;
			render();
		}
		return _bounds.x;
	}

	private function getY() : Float {
		return _bounds.y;
	}

	private function setY(value : Float) : Float {
		if(_bounds.y != value) {
			_bounds.y = value;
			render();
		}
		return _bounds.y;
	}

	private function getWidth() : Float {
		return _bounds.width;
	}

	private function setWidth(value : Float) : Float {
		if(_autoSize) {
			_boundsMax.width = value;
			render();
		}
		return _bounds.width;
	}

	private function getHeight() : Float {
		return _bounds.height;
	}

	private function setHeight(value : Float) : Float {
		if(_autoSize) {
			_boundsMax.height = value;
			render();
		}
		return _bounds.height;
	}

	private function getTextFormat() : TextFormat {
		return _textFormat;
	}

	private function setTextFormat(value : TextFormat) : TextFormat {
		_textFormat = value;
		render();
		return _textFormat;
	}

	private function getLineSpacing() : Float {
		return _textFormat.lineSpacing;
	}
}