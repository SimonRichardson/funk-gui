package funk.gui.core.events;

import funk.gui.Root;

interface IComponentEventManager {
	
	function onEventManagerInitialize(root : Root) : Void;
	
	function onEventManagerCleanup() : Void;
}
