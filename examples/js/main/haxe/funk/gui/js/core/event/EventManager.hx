package funk.gui.js.core.event;

import funk.gui.core.events.IComponentEventManager;
import funk.gui.core.events.IComponentEventManagerObserver;
import funk.gui.core.events.IComponentEventTarget;
import funk.gui.core.IComponent;
import funk.gui.core.IComponentRoot;
import funk.gui.core.geom.Point;
import funk.signal.Signal2;

import js.Dom;
import js.w3c.html5.Core;
import js.w3c.level3.Events;

class EventManager<E : HTMLCanvasElement> implements IComponentEventManager<E> {
	
	private var _root : IComponentRoot<E>;
	
	private var _context : E;

	private var _window : Window;

	private var _signal : ISignal2<IComponentEventManager<E>, ComponentEventManagerUpdateType>;

	private var _mouseDown : Bool;

	private var _mousePoint : Point;
	
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

		_mouseDown = false;
		_mousePoint = new Point(0, 0);
		
		_window = untyped __js__("window");
		_window.onresize = handleEvent;

		_context = _root.renderManager.context;
		_context.addEventListener('mousedown', handleEvent, false);
		_context.addEventListener('click', handleEvent, false);

		onResize(null);
	}
	
	public function onEventManagerCleanup() : Void {
		_window.onresize = null;
		_window = null;

		_context.removeEventListener('mousedown', handleEvent, false);
		_context.removeEventListener('click', handleEvent, false);
		_context = null;
		
		_root = null;
 	}
	
	private function handleEvent(event : Event) : Void {
		switch(event.type) {
			case 'mousedown': onMouseDown(cast event);
			case 'mouseup': onMouseUp(cast event);
			case 'resize': onResize(event);
		}
	}

	private function notify(type : ComponentEventManagerUpdateType) : Void {
		_signal.dispatch(this, type);
	}

	private function getHit(point : Point) : IComponentEventTarget {
		var currentTarget : IComponentEventTarget = _root;
		var lastTarget : IComponentEventTarget = null;

		if(null != currentTarget) {
			while(currentTarget != lastTarget) {
				lastTarget = currentTarget;
				currentTarget = currentTarget.captureEventTarget(point);

				if(null == currentTarget) {
					return lastTarget;
				}
			}
		}

		return currentTarget;
	}

	private function onMouseDown(event : MouseEvent) : Void {
		if(_mouseDown) {
			onMouseUp(null);
		}

		_mousePoint.x = event.clientX;
		_mousePoint.y = event.clientY;

		trace(getHit(_mousePoint));
	}

	private function onMouseUp(event : MouseEvent) : Void {

	}

	private function onResize(event : Event) : Void {
		notify(RESIZE(_window.innerWidth, _window.innerHeight));
	}
}
