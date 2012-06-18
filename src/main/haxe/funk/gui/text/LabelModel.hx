package funk.gui.text;

import funk.gui.core.ComponentModel;
import funk.gui.core.display.ImageData;

class LabelModel extends ComponentModel {
	
	public static var UPDATE_ICON : Int = 1;

	public static var UPDATE_TEXT : Int = 2; 
	
	public var text(getText, setText) : String;
	
	public var icon(getIcon, setIcon) : ImageData;

	private var _text : String;
	
	private var _icon : ImageData;
	
	public function new(?text:String = "", ?icon:ImageData = null) {
		super();
		
		_text = text;
		_icon = icon;
	}
	
	private function getText() : String {
		return _text;
	}
	
	private function setText(value: String) : String {
		if(value != _text) {
			_text = value;
			notify(UPDATE_TEXT);
		}
		
		return _text;
	}

	private function getIcon() : ImageData {
		return _icon;
	}
	
	private function setIcon(value: ImageData) : ImageData {
		if(value != _icon) {
			_icon = value;
			notify(UPDATE_ICON);
		}
		
		return _icon;
	}
}
