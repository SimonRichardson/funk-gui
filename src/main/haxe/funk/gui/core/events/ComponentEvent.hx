package funk.gui.core.events;

import funk.gui.core.IComponent;
import funk.option.Option;

using funk.option.Option;

class ComponentEventType {
	
	public static var UNDEFINED : ComponentEventType = new ComponentEventType();
	
	public static var PRESS : ComponentEventType = new ComponentEventType();
	
	public static var RELEASE : ComponentEventType = new ComponentEventType();
	
	public static var HOVER_IN : ComponentEventType = new ComponentEventType();
	
	public static var HOVER_OUT : ComponentEventType = new ComponentEventType();
	
	public static var FOCUS_IN : ComponentEventType = new ComponentEventType();
	
	public static var FOCUS_OUT : ComponentEventType = new ComponentEventType();
	
	public static var ENABLE : ComponentEventType = new ComponentEventType();
	
	public static var DISABLE : ComponentEventType = new ComponentEventType();
	
	private function new(){
	}
}

class ComponentEvent {

	public var type(getType, never) : ComponentEventType;
	
	public var component(getComponent, never) : IComponent;
	
	private var _defaultComponent : Option<IComponent>;
	
	private var _component : IComponent;
	
	private var _type : ComponentEventType;
	
	public function new(component : IComponent, ?componentType : ComponentEventType) {
		_defaultComponent = Some(component);
		
		reset(componentType);
	}
	
	public function reset(value : ComponentEventType) : Void {
		_type = value;
		_component = _defaultComponent.getOrElse(function():IComponent {
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
