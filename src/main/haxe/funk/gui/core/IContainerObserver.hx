package funk.gui.core;

import funk.gui.core.events.ContainerEvent;

interface IContainerObserver {
	
	function onContainerUpdate(event : ContainerEvent) : Void;	
}
