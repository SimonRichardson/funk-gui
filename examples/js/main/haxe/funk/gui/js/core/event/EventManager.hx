package funk.gui.js.core.event;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.gui.core.events.IComponentEventManager;
import funk.gui.core.events.IComponentEventManagerObserver;
import funk.gui.core.events.IComponentEventTarget;
import funk.gui.core.events.UIEvent;
import funk.gui.core.IComponent;
import funk.gui.core.IComponentRoot;
import funk.gui.core.geom.Point;
import funk.option.Any;
import funk.signal.Signal2;

import js.Dom;
import js.w3c.html5.Core;
import js.w3c.level3.Events;

using funk.collections.immutable.Nil;
using funk.option.Any;

class EventManager<E : HTMLCanvasElement> implements IComponentEventManager<E> {
	
	public var focus(get_focus, set_focus) : IComponentEventTarget;

	public var isDown(get_isDown, never) : Bool;

	private var _root : IComponentRoot<E>;
	
	private var _context : E;

	private var _window : Window;

	private var _document : HTMLDocument;

	private var _signal : ISignal2<IComponentEventManager<E>, ComponentEventManagerUpdateType>;

	private var _mouseDown : Bool;

	private var _mousePoint : Point;

	private var _mouseDownPoint : Point;

	private var _mouseLastPoint : Point;

	private var _mouseUpPoint : Point;

	private var _focus : IComponentEventTarget;

	private var _lastTarget : IComponentEventTarget;

	private var _hoverTarget : IComponentEventTarget;

	private var _hoveredChildren : IList<IComponentEventTarget>;
	
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

		_hoveredChildren = nil.list();
		
		_window = untyped __js__("window");
		_window.onresize = handleEvent;

		_document = CommonJS.getHtmlDocument();
		//_document.onkeydown = cast handleEvent;

		_context = _root.renderManager.context;
		_context.addEventListener('mousedown', handleEvent, false);
		_context.addEventListener('mousemove', handleEvent, false);
		_context.addEventListener('mouseup', handleEvent, false);
		_context.addEventListener('click', handleEvent, false);
		
		onResize(null);
	}
	
	public function onEventManagerCleanup() : Void {
		_window.onresize = null;
		_window = null;

		_document.onkeydown = null;
		_document = null;

		_context.removeEventListener('mousedown', handleEvent, false);
		_context.removeEventListener('mousemove', handleEvent, false);
		_context.removeEventListener('mouseup', handleEvent, false);
		_context.removeEventListener('click', handleEvent, false);
		_context.removeEventListener('keydown', handleEvent, false);
		_context = null;
		
		_root = null;
 	}
	
	private function handleEvent(event : Event) : Void {
		switch(event.type) {
			case 'mousedown': onMouseDown(cast event);
			case 'mousemove': onMouseMove(cast event);
			case 'mouseup': onMouseUp(cast event);
			case 'resize': onResize(event);
			case 'keydown': onKeyDown(cast event);
		}
	}

	private function notify(type : ComponentEventManagerUpdateType) : Void {
		_signal.dispatch(this, type);
	}

	private function dispatchEvent(target : IComponentEventTarget, event : UIEvent) : Void {
		if(target.isEmpty()) {
			// throw error here
		}

		var currentTarget = target;

		event.lastTarget = null;
		event.target = target;

		while(event.bubbles && currentTarget.isDefined()) {
			event.currentTarget = currentTarget;
			
			currentTarget.processEvent(event);

			event.lastTarget = currentTarget;

			if(_root == target) {
				break;
			}

			currentTarget = currentTarget.eventParent;
		}
	}

	private function getHit(point : Point) : IComponentEventTarget {
		var currentTarget : IComponentEventTarget = _root;
		var lastTarget : IComponentEventTarget = null;

		if(currentTarget.isDefined()) {
			while(currentTarget != lastTarget) {
				lastTarget = currentTarget;
				currentTarget = currentTarget.captureEventTarget(point);

				if(currentTarget.isEmpty()) {
					return lastTarget;
				}
			}
		}

		return currentTarget;
	}

	private function setFocus(child : IComponentEventTarget) : Void {
		if(_focus == child) return;

		if(_focus.isDefined()) {
			dispatchEvent(_focus, new UIEvent(FOCUS_OUT));
		}

		if(child.isDefined()) _focus = null;
		else {
			var focusOut : IComponentEventTarget = _focus;
			var focusIn : IComponentEventTarget = child;

			_focus = child;

			dispatchEvent(_focus, new UIEvent(FOCUS_IN(focusOut, focusIn)));
		}
	}

	private function onMouseDown(event : MouseEvent) : Void {
		if(_mouseDown) onMouseUp(null);
		
		_mousePoint.x = event.clientX;
		_mousePoint.y = event.clientY;

		_mouseDownPoint.x = _mousePoint.x;
		_mouseDownPoint.y = _mousePoint.y;

		var currentTarget : IComponentEventTarget = getHit(_mousePoint);
		if(currentTarget.isDefined()) {
			setFocus(currentTarget);

			dispatchEvent(currentTarget, new UIEvent(MOUSE_DOWN(_mouseDownPoint)));
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

			dispatchEvent(currentTarget, new UIEvent(MOUSE_MOVE(_mousePoint, _mouseDownPoint)));

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
		if(currentTarget.isDefined()) {
			dispatchEvent(currentTarget, new UIEvent(MOUSE_UP(_mouseUpPoint)));
		}
	}

	private function handleHovering(currentTarget : IComponentEventTarget) : Void {
		if(_mouseDown) return;
		else {
			var exists : Bool = false;

			var child : IComponentEventTarget;
			var activeChild : IComponentEventTarget;
			var target : IComponentEventTarget;

			var hoverRemoves : IList<IComponentEventTarget> = nil.list();

			var p : IList<IComponentEventTarget> = _hoveredChildren;
			while(p.nonEmpty) {
				child = p.head;

				if(currentTarget != child) {
					activeChild = currentTarget;

					while(activeChild != child) {

						if(activeChild.isDefined()) {
							hoverRemoves = hoverRemoves.prepend(child);

							dispatchEvent(child, new UIEvent(MOUSE_OUT(_mousePoint)));

							break;
						}

						activeChild = activeChild.eventParent;
					}
				} else {
					exists = true;
				}

				p = p.tail;
			}

			if(!exists && currentTarget.isDefined()) {

				_hoveredChildren = _hoveredChildren.prepend(currentTarget);

				dispatchEvent(currentTarget, new UIEvent(MOUSE_IN(_mousePoint)));
			}

			_hoveredChildren = _hoveredChildren.filterNot(function(child : IComponentEventTarget) : Bool {
				return hoverRemoves.contains(child);
			});
		}
	}

	private function handleDragInOut() : Void {

	}

	private function onKeyDown(event : KeyboardEvent) : Void {
		var keyCode : Int = cast event.keyLocation;
		dispatchEvent(focus, new UIEvent(KEY_DOWN(keyCode, event.ctrlKey, event.shiftKey, event.altKey)));
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

	private function get_isDown() : Bool {
		return _mouseDown;
	}
}
