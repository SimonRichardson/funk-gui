package funk.gui.core.observables;

import funk.gui.core.Component;
import funk.gui.core.ComponentState;
import funk.option.Any;

using funk.option.Any;

class ComponentStateObserver implements IComponentStateObserver {
	
	private var _component : IComponent;
	
	private var _componentNS : ComponentNamespace;
	
	public function new(component : IComponent) {
		_component = component;
		_componentNS = cast component;
	}
	
	public function onComponentStateUpdate(componentState : ComponentState, type : ComponentStateType) : Void {
		if(_component.view.isDefined()) 
			_component.view.onComponentStateUpdate(componentState, type);
			
		switch(type) {
			case UPDATE_ENABLED:
			case UPDATE_HOVERED:
			case UPDATE_FOCUSED:
			case UPDATE_PRESSED:
			case UPDATE_ALL_VALUES:
		}
	}
}
