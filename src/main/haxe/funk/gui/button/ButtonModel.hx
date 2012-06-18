package funk.gui.button;

import funk.gui.core.ComponentModel;
import funk.gui.core.display.IComponentImageData;
import funk.gui.core.parameter.Parameter;
import funk.gui.core.parameter.mappings.MappingBoolInt;

class ButtonModel extends ComponentModel {
	
	public static var UPDATE_TEXT : Int = 1;

	public static var UPDATE_ICON : Int = 2;

	public static var UPDATE_SELECTION : Int = 3; 
	
	public var text(getText, setText) : String;
	
	public var icon(getIcon, setIcon) : IComponentImageData;

	public var selected(getSelected, setSelected) : Bool;
	
	private var _text : String;

	private var _icon : IComponentImageData;
	
	private var _selected : Parameter<Bool, Int>;
	
	public function new(	?text:String = "", 
							?icon:IComponentImageData = null, 
							?selected:Bool = false) {
		super();
		
		_text = text;
		_icon = icon;
		_selected = new Parameter<Bool, Int>(new MappingBoolInt(), selected);
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
	
	private function getIcon() : IComponentImageData {
		return _icon;
	}
	
	private function setIcon(value: IComponentImageData) : IComponentImageData {
		if(value != _icon) {
			_icon = value;
			notify(UPDATE_ICON);
		}
		
		return _icon;
	}

	private function getSelected() : Bool {
		return _selected.value;
	}
	
	private function setSelected(value: Bool) : Bool {
		if(value != _selected.value) {
			_selected.value = value;
			
			notify(UPDATE_SELECTION);
		}
		
		return _selected.value;
	}
}
