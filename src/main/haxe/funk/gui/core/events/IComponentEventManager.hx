package funk.gui.core.events;

import funk.gui.Root;

interface IComponentEventManager<T> {
	
	function onEventManagerInitialize(root : Root<T>) : Void;
	
	function onEventManagerCleanup() : Void;
}
