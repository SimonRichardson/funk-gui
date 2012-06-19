package funk.gui.core.events;

import funk.gui.core.IComponent;
import funk.option.Option;

using funk.option.Option;

class ContainerEventType {
	
	public static var COMPONENT_ADDED : ContainerEventType = new ContainerEventType();
		
	private function new(){
	}
}

class ContainerEvent {

	public var type(getType, never) : ContainerEventType;
	
	public var component(getComponent, never) : IComponent;

	private var _defaultComponent : Option<IComponent>;
	
	private var _component : IComponent;
	
	private var _type : ContainerEventType;
	
	public function new(?componentType : ContainerEventType, component : IComponent) {	
		_defaultComponent = Some(component);

		reset(componentType);
	}
	
	public function reset(value : ContainerEventType) : Void {
		_type = value;
		_component = _defaultComponent.getOrElse(function():IComponent {
			return null;
		});
	}
	
	public function getType() : ContainerEventType {
		return _type;
	}

	public function getComponent() : IComponent {
		return _component;
	}
}
