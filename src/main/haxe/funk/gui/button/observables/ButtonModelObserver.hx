package funk.gui.button.observables;

import funk.gui.button.ButtonModel;
import funk.gui.button.events.ButtonEvent;
import funk.gui.core.Component;
import funk.gui.core.IComponentModel;
import funk.gui.core.IComponentModelObserver;

class ButtonModelObserver implements IComponentModelObserver {
	
	private var _buttonComponent : ButtonComponent;
	
	private var _buttonComponentNS : ComponentDispatchEventNamespace;
	
	public function new(buttonComponent : ButtonComponent) {
		_buttonComponent = buttonComponent;
		_buttonComponentNS = cast buttonComponent;
	}
	
	public function onComponentModelUpdate(componentModel : IComponentModel, type : Int) : Void {
		if(type == ButtonModel.UPDATE_SELECTION) {
			var t = _buttonComponent.selected ? ButtonEventType.SELECT : ButtonEventType.DESELECT;
			_buttonComponentNS.dispatchComponentEvent(t);
		}
	}
}
