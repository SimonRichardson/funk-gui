package funk.gui.js.core.display.text;

class TextRenderer {

	public var text(getText, setText) : String;

	private var _bounds : Rectangle;

	private var _boundsMax : Rectangle;

	private var _boundsMeasured : Rectangle;

	private var _textLines : IList<TextLine>;

	private var _lineSpacing : Int;

	private var _text : String;

	private var _textBlock : TextBlock;

	private var _textElement : TextElement;

	private var _shortend : Bool;

	private var _autoEllipsis : Bool;

	public function new() {

		_text = "";
		_textLines = nil.list();

		_textElement = new TextElement(_text);
		_textBlock = new TextBlock(_textElement);

		_bounds = new Rectangle();	
		_boundsMax = new Rectangle();
		_boundsMeasured = new Rectangle();

		_shortend = false;
		_autoEllipsis = false;
	}

	public function update() : Void {
		measure(_text);
		render(_text);
	}

	private function measure(text : String) : Void {
		_bounds.resizeTo(0, 0);

		clearTextLines();

		if(text == null || text == "") return;
		else {
			_textElement.text = text;
			_textBlock.content = _textElement;

			var textLine : TextLine = _textBlock.createTextLine(null, 10000);
			if(textLine.isEmpty()) return;
			else {

				_lineHeight = textLine.textHeight;

				var h : Float = _lineHeight + _lineSpacing;
				while(textLine) {
					_boundsMeasured.height += h;
					if(textLine.width > _boundsMeasured.width) {
						_boundsMeasured.height = textLine.width;
					}
					textLine = _textBlock.createTextLine(textLine, 100000);
				}

				_boundsMeasured.width = Math.ceil(_boundsMeasured.width);
				_boundsMeasured.height = Math.ceil(_boundsMeasured.height - _lineSpacing);
			}
		}
	}

	private function render(text : String) : Void {
		_bounds.resizeTo(0, 0);

		clearTextLines();

		if(text == null || text == "" || _boundsMax.width < 1 || _boundsMax.height < 1) return;
		else {
			_textElement.text = text;
			_textBlock.content = _textElement;

			var textLine : TextLine = _textBlock.createTextLine(null, _boundsMax.width);
			if(textLine.isEmpty()) return;
			else {

				var textHeight : Float = textLine.textHeight;
				var textHeightAndSpacing : Float = textHeight + _lineSpacing;

				var lineHeight : Float = textHeight - textLine.descent + 1;

				var index : Int = 0;

				while(textLine) {
					if(_bounds.height + textHeight > _boundsMax.height) {
						if(_autoEllipsis && !_shortend) {
							_shortend = true;

							applyEllipsis(index);
							return;
						}

						_shortend = true;
						break;
					}
				}

				index += textLine.charCount;

				_bounds.height += textHeightAndSpacing;

				if(_bounds.width < textLine.width) {
					_bounds.width = textLine.width;
				}

				_textLines = _textLines.append(textLine);

				textLine = _textBlock.createTextLine(textLine, _boundsMax.width);
			}

			_bounds.height -= _lineSpacing;

			for(line in _textLines) {
				// TODO (Simon) : Alignment

				line.y += lineHeight;
				lineHeight += textHeightAndSpacing;
			}

			_shortend = false;
		}
	}

	private function clearTextLines() : Void {
		_textLines = nil.list();
		_textBlock.releaseAllLines();
	}

	private function applyEllipsis(index : Int) : Void {
		if(index > 3)
			render(_text.substr(0, index - 3) + "...");
		else 
			render("...");
	}

	private function getText() : String {
		return _text;
	}

	private function setText(value : String) : String {
		if(_text != value) {
			_text = value;

			measure(_text);
			render(_text);
		}
	}
}