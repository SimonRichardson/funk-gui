package funk.gui.core;

import funk.gui.core.events.ComponentEvent;
import funk.signal.Signal1;

interface IComponentObserver {
	
	function onComponentEvent(event : ComponentEvent) : Void;	
}

class ComponentObserverProxy {
	
	public var componentEventSignal : ISignal1<ComponentEvent>;
	
	public function new() {
		componentEventSignal = new Signal1<ComponentEvent>();
	}
	
	public function onComponentEvent(event : ComponentEvent) : Void {
		componentEventSignal.dispatch(event);
	}
}
