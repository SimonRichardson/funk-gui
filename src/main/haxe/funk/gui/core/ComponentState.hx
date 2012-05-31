package funk.gui.core;

import funk.signal.Signal2;

enum ComponentStateType {
	UPDATE_ALL_VALUES;
	UPDATE_ENABLED;
	UPDATE_HOVERED;
	UPDATE_FOCUSED;
	UPDATE_PRESSED;
}

interface IComponentStateObserver {
	
	function onComponentStateUpdate(state : ComponentState, type : ComponentStateType) : Void;
}

typedef ComponentStateNamespace = {
	function notify(type : ComponentStateType) : Void;
}

class ComponentState {
	
	public var enabled(default, setEnabled) : Bool;
	
	public var hovered(default, setHovered) : Bool;
	
	public var focused(default, setFocused) : Bool;
	
	public var pressed(default, setPressed) : Bool;
	
	private var _signal : ISignal2<ComponentState, ComponentStateType>;
	
	public function new() {
		_signal = new Signal2<ComponentState, ComponentStateType>();
		
		enabled = true;
		hovered = false;
		focused = false;
		pressed = false;
	}
	
	public function addComponentStateObserver(observer : IComponentStateObserver) : Void {
		_signal.add(observer.onComponentStateUpdate);
	}
	
	public function removeComponentStateObserver(observer : IComponentStateObserver) : Void {
		_signal.remove(observer.onComponentStateUpdate);
	}
	
	private function notify(type : ComponentStateType) : Void {
		_signal.dispatch(this, type);
	}
	
	private function setEnabled(value : Bool) : Bool {
		if(enabled != value) {
			enabled = value;
			notify(UPDATE_ENABLED);
		}
		return enabled;
	}
	
	private function setHovered(value : Bool) : Bool {
		if(hovered != value) {
			hovered = value;
			notify(UPDATE_HOVERED);
		}
		return hovered;
	}
	
	private function setFocused(value : Bool) : Bool {
		if(focused != value) {
			focused = value;
			notify(UPDATE_FOCUSED);
		}
		return focused;
	}
	
	private function setPressed(value : Bool) : Bool {
		if(pressed != value) {
			pressed = value;
			notify(UPDATE_PRESSED);
		}
		return pressed;
	}
}