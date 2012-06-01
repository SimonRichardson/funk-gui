package funk.gui.core.observables;

import funk.gui.core.Component;
import funk.gui.core.ComponentState;
import funk.gui.core.events.ComponentEvent;
import funk.option.Any;

using funk.option.Any;

class ComponentStateObserver implements IComponentStateObserver {
	
	private var _component : IComponent;
	
	private var _componentNS : ComponentDispatchEventNamespace;
	
	public function new(component : IComponent) {
		_component = component;
		_componentNS = cast component;
	}
	
	public function onComponentStateUpdate(componentState : ComponentState, type : ComponentStateType) : Void {
		if(_component.view.isDefined()) 
			_component.view.onComponentStateUpdate(componentState, type);
			
		switch(type) {
			case UPDATE_ENABLED:
				_componentNS.dispatchComponentEvent(componentState.enabled ? 
																ComponentEventType.ENABLE : 
																ComponentEventType.DISABLE);
			case UPDATE_HOVERED:
				_componentNS.dispatchComponentEvent(componentState.hovered ? 
																ComponentEventType.HOVER_IN : 
																ComponentEventType.HOVER_OUT);
			case UPDATE_FOCUSED:
				_componentNS.dispatchComponentEvent(componentState.focused ? 
																ComponentEventType.FOCUS_IN : 
																ComponentEventType.FOCUS_OUT);
			case UPDATE_PRESSED:
				_componentNS.dispatchComponentEvent(componentState.pressed ? 
																ComponentEventType.PRESS : 
																ComponentEventType.RELEASE);
			default:
		}
	}
}
