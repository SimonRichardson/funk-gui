package funk.gui.button;

import funk.gui.button.events.ButtonEvent;
import funk.gui.button.observables.ButtonModelObserver;
import funk.gui.core.Component;
import funk.gui.core.IComponentModel;
import funk.gui.core.IComponentModelObserver;
import funk.gui.core.IComponentView;
import funk.gui.core.display.IComponentImageData;
import funk.option.Any;

using funk.option.Any;

class ButtonComponent extends Component {
	
	public var text(getText, setText) : String;

	public var icon(getIcon, setIcon) : IComponentImageData;
	
	public var selected(getSelected, setSelected) : Bool;
	
	private var _buttonModel : ButtonModel;
	
	private var _buttonModelObserver : IComponentModelObserver;
	
	public function new(componentView : IComponentView) {
		super(componentView);
	}
	
	override private function initModel() : Void {
		model = new ButtonModel();
	}
	
	override private function initEvents() : Void {
		event = new ButtonEvent(this);
	}
	
	override private function set_model(componentModel : IComponentModel) : IComponentModel {
		if(_buttonModel.isDefined()) {
			_buttonModel.removeComponentModelObserver(_buttonModelObserver);
			_buttonModelObserver = null;
		}
		
		var result = super.set_model(_buttonModel = cast componentModel);
		
		if(_buttonModel.isDefined()) {				
			_buttonModelObserver = new ButtonModelObserver(this);
			_buttonModel.addComponentModelObserver(_buttonModelObserver);
		}
		
		return result;
	}
	
	private function getText() : String {
		return _buttonModel.text;
	}
	
	private function setText(value : String) : String {
		_buttonModel.text = value;
		return _buttonModel.text;
	}

	private function getIcon() : IComponentImageData {
		return _buttonModel.icon;
	}
	
	private function setIcon(value : IComponentImageData) : IComponentImageData {
		_buttonModel.icon = value;
		return _buttonModel.icon;
	}
	
	private function getSelected() : Bool {
		return _buttonModel.selected;
	}
	
	private function setSelected(value : Bool) : Bool {
		_buttonModel.selected = value;
		return _buttonModel.selected;
	}
}
