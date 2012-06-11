package funk.gui.js.core.event;

import funk.gui.core.events.IComponentEventManager;
import funk.gui.core.events.IComponentEventManagerObserver;
import funk.gui.core.IComponent;
import funk.gui.core.IComponentRoot;
import funk.signal.Signal2;

import js.w3c.html5.Core;
import js.w3c.level3.Events;

class EventManager<E : HTMLCanvasElement> implements IComponentEventManager<E> {
	
	private var _root : IComponentRoot<E>;
	
	private var _context : E;

	private var _signal : ISignal2<IComponentEventManager<E>, ComponentEventManagerUpdateType>;
	
	public function new(){
		_signal = new Signal2<IComponentEventManager<E>, ComponentEventManagerUpdateType>();
	}
	
	public function addEventManagerObserver(observer : IComponentEventManagerObserver<E>) : 
																IComponentEventManagerObserver<E> {
        _signal.add(observer.onComponentEventManagerUpdate);
        return observer;
	}

	public function removeEventManagerObserver(observer : IComponentEventManagerObserver<E>) : 
																IComponentEventManagerObserver<E> {
        _signal.remove(observer.onComponentEventManagerUpdate);
        return observer;
	}

	public function onEventManagerInitialize(root : IComponentRoot<E>) : Void {
		_root = root;
		
		_context = _root.renderManager.context;
		_context.addEventListener('mousedown', handleEvent, false);
		_context.addEventListener('click', handleEvent, false);
	}
	
	public function onEventManagerCleanup() : Void {
		_context.removeEventListener('mousedown', handleEvent, false);
		_context.removeEventListener('click', handleEvent, false);
		_context = null;
		
		_root = null;
 	}
	
	private function handleEvent(event : Event) : Void {
		switch(event.type) {
			case 'mousedown': trace('mousedown');
			case 'click': trace('click');
		}
	}

	private function notify(type : ComponentEventManagerUpdateType) : Void {
		_signal.dispatch(this, type);
	}
}
