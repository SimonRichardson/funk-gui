package funk.gui.core.events;

import funk.gui.core.IComponentRoot;
import funk.gui.core.events.IComponentEventManagerObserver;

interface IComponentEventManager<E> {

	var focus(dynamic, dynamic) : IComponentEventTarget;
	
	function addEventManagerObserver(observer : IComponentEventManagerObserver<E>) : 
																IComponentEventManagerObserver<E>;

	function removeEventManagerObserver(observer : IComponentEventManagerObserver<E>) : 
																IComponentEventManagerObserver<E>;

	function onEventManagerInitialize(root : IComponentRoot<E>) : Void;
	
	function onEventManagerCleanup() : Void;
}
