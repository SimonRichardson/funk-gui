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
	
	public var focus(get_focus, set_focus) : IComponentEventTarget;

	private var _root : IComponentRoot<E>;
	
	private var _context : E;

	private var _window : Window;

	private var _signal : ISignal2<IComponentEventManager<E>, ComponentEventManagerUpdateType>;

	private var _mouseDown : Bool;

	private var _mousePoint : Point;

	private var _mouseDownPoint : Point;

	private var _mouseLastPoint : Point;

	private var _mouseUpPoint : Point;

	private var _focus : IComponentEventTarget;

	private var _lastTarget : IComponentEventTarget;

	private var _hoverTarget : IComponentEventTarget;
	
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
		_mouseDownPoint = new Point(0, 0);
		_mouseLastPoint = new Point(0, 0);
		_mouseUpPoint = new Point(0, 0);
		
		_window = untyped __js__("window");
		_window.onresize = handleEvent;

		_context = _root.renderManager.context;
		_context.addEventListener('mousedown', handleEvent, false);
		_context.addEventListener('mousemove', handleEvent, false);
		_context.addEventListener('click', handleEvent, false);

		onResize(null);
	}
	
	public function onEventManagerCleanup() : Void {
		_window.onresize = null;
		_window = null;

		_context.removeEventListener('mousedown', handleEvent, false);
		_context.removeEventListener('mousemove', handleEvent, false);
		_context.removeEventListener('mouseup', handleEvent, false);
		_context.removeEventListener('click', handleEvent, false);
		_context = null;
		
		_root = null;
 	}
	
	private function handleEvent(event : Event) : Void {
		switch(event.type) {
			case 'mousedown': onMouseDown(cast event);
			case 'mousemove': onMouseMove(cast event);
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

	private function setFocus(child : IComponentEventTarget) : Void {
		if(_focus == child) return;

		if(null != _focus) {
			//_focus.onEventManager(FOCUS_OUT);
		}

		if(null == child) _focus = null;
		else {
			var focusOut : IComponentEventTarget = _focus;
			var focusIn : IComponentEventTarget = child;

			_focus = child;

			// _focus.onEventManager(FOCUS_IN(focusOut, focusIn));
		}
	}

	private function onMouseDown(event : MouseEvent) : Void {
		if(_mouseDown) onMouseUp(null);
		
		_mousePoint.x = event.clientX;
		_mousePoint.y = event.clientY;

		_mouseDownPoint.x = _mousePoint.x;
		_mouseDownPoint.y = _mousePoint.y;

		var currentTarget : IComponentEventTarget = getHit(_mousePoint);
		if(null != currentTarget) {
			setFocus(currentTarget);

			// currentTarget.onEventManager(MOUSE_DOWN(_mouseDownPoint));
		}

		_lastTarget = currentTarget;
	}

	private function onMouseMove(event : MouseEvent) : Void {
		
		_mousePoint.x = event.clientX;
		_mousePoint.y = event.clientY;

		var currentTarget : IComponentEventTarget = _mouseDown ? 
															_lastTarget : 
															getHit(_mousePoint);
		_hoverTarget = currentTarget;

		handleHovering(currentTarget);
		handleDragInOut();

		if(	_mouseLastPoint.x != _mousePoint.x || 
			_mouseLastPoint.y != _mousePoint.y) {

			// currentTarget.onEventManager(MOUSE_MOVE(_mousePoint, _mouseDownPoint));

			_mouseLastPoint.x = _mousePoint.x;
			_mouseLastPoint.y = _mousePoint.y;
		}
	}

	private function onMouseUp(event : MouseEvent) : Void {
		_mouseDown = false;

		_mousePoint.x = event == null ? _mousePoint.x : event.clientX;
		_mousePoint.y = event == null ? _mousePoint.y : event.clientY;

		_mouseUpPoint.x = _mousePoint.x;
		_mouseUpPoint.y = _mousePoint.y;

		var currentTarget : IComponentEventTarget = _lastTarget;
		if(null != currentTarget) {
			// currentTarget.onEventManager(MOUSE_UP(_mouseUpPoint));
		}
	}

	private function handleHovering(currentTarget : IComponentEventTarget) : Void {
		if(_mouseDown) return;
		else {
			var exists : Bool = false;

			
		}
	}

	private function handleDragInOut() : Void {

	}

	private function onResize(event : Event) : Void {
		notify(RESIZE(_window.innerWidth, _window.innerHeight));
	}

	private function get_focus() : IComponentEventTarget {
		return _focus;
	}

	private function set_focus(value : IComponentEventTarget) : IComponentEventTarget {
		_focus = value;
		return value;
	}
}
