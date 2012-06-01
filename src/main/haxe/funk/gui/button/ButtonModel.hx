package funk.gui.button;

import funk.gui.core.ComponentModel;

class ButtonModel extends ComponentModel {
	
	public static var UPDATE_TEXT : Int = 1;

	public static var UPDATE_SELECTION : Int = 2; 
	
	public var text(getText, setText) : String;
	
	public var selected(getSelected, setSelected) : Bool;
	
	private var _text : String;
	
	private var _selected : Bool;
	
	public function new(?text:String = "", ?selected:Bool = false) {
		super();
		
		_text = text;
		_selected = selected;
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
	
	private function getSelected() : Bool {
		return _selected;
	}
	
	private function setSelected(value: Bool) : Bool {
		if(value != _selected) {
			_selected = value;
			notify(UPDATE_SELECTION);
		}
		
		return _selected;
	}
}
