package funk.gui.core.events;

import funk.gui.core.Component;
import funk.option.Option;

using funk.option.Option;

enum ComponentEventType {
	UNDEFINED;
	PRESS;
	RELEASE;
	HOVER_IN;
	HOVER_OUT;
	FOCUS_IN;
	FOCUS_OUT;
	ENABLE;
	DISABLE;
}

class ComponentEvent {

	public var type(getType, never) : ComponentEventType;
	
	public var component(getComponent, never) : IComponent;
	
	private var _defaultComponent : Option<IComponent>;
	
	private var _component : IComponent;
	
	private var _type : ComponentEventType;
	
	public function new(component : IComponent, ?componentType : ComponentEventType) {
		_component = Some(component);
		
		reset(componentType);
	}
	
	public function reset(value : ComponentEventType) : Void {
		_type = value;
		_component = _defaultComponent.getOrElse(function():IComponent {
			// TODO (Simon) : Should we pass null
			return null;
		});
	}
	
	public function getType() : ComponentEventType {
		return _type;
	}
	
	public function getComponent() : IComponent {
		return _component;
	}
}
