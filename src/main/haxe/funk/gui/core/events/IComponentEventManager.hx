package funk.gui.core.events;

import funk.gui.core.IComponentRoot;

interface IComponentEventManager<E> {
	
	function onEventManagerInitialize(root : IComponentRoot<E>) : Void;
	
	function onEventManagerCleanup() : Void;
}
