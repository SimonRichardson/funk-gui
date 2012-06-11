package funk.gui.core.events;

enum ComponentEventManagerUpdateType {
	RESIZE(width : Float, height : Float);
}

interface IComponentEventManagerObserver<E> {
	
	function onComponentEventManagerUpdate(	manager : IComponentEventManager<E>, 
											type : ComponentEventManagerUpdateType) : Void;
}