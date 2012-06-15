package funk.gui.core.events;

import funk.gui.core.IComponent;

class ContainerEventType {
	
	public static var COMPONENT_ADDED : ContainerEventType = new ContainerEventType();
		
	private function new(){
	}
}

class ContainerEvent {

	public var type(getType, never) : ContainerEventType;
	
	private var _type : ContainerEventType;
	
	public function new(?componentType : ContainerEventType) {	
		reset(componentType);
	}
	
	public function reset(value : ContainerEventType) : Void {
		_type = value;
	}
	
	public function getType() : ContainerEventType {
		return _type;
	}
}
