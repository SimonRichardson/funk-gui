package funk.gui.core.observables;

import funk.gui.core.events.ComponentEvent;
import funk.signal.Signal1;

class ComponentObserverProxy implements IComponentObserver {
	
	public var componentEventSignal : ISignal1<ComponentEvent>;
	
	public function new() {
		componentEventSignal = new Signal1<ComponentEvent>();
	}
	
	public function onComponentEvent(event : ComponentEvent) : Void {
		componentEventSignal.dispatch(event);
	}
}