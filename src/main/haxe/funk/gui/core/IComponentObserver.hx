package funk.gui.core;

import funk.gui.core.events.ComponentEvent;

interface IComponentObserver {
	
	function onComponentEvent(event : ComponentEvent) : Void;	
}
