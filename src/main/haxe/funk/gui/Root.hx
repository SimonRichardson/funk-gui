package funk.gui;

import funk.collections.IList;
import funk.collections.IQuadTree;
import funk.collections.immutable.Nil;
import funk.option.Any;
import funk.option.Option;
import funk.gui.core.display.IComponentRenderManager;
import funk.gui.core.display.IComponentRenderManagerObserver;
import funk.gui.core.display.QuadTree;
import funk.gui.core.events.ContainerEvent;
import funk.gui.core.events.IComponentEventManager;
import funk.gui.core.events.IComponentEventManagerObserver;
import funk.gui.core.events.IComponentEventTarget;
import funk.gui.core.events.IComponentEventTargetHook;
import funk.gui.core.events.UIEvent;
import funk.gui.core.geom.Point;
import funk.gui.core.geom.Rectangle;
import funk.gui.core.IComponent;
import funk.gui.core.IComponentRoot;
import funk.gui.core.IContainerObserver;
import funk.signal.Signal1;
import funk.unit.Expect;

using funk.collections.immutable.Nil;
using funk.option.Any;
using funk.unit.Expect;

class Root<E> 	implements IComponentRoot<E>, 
				implements IComponentEventManagerObserver<E>, 
				implements IComponentRenderManagerObserver<E> {
	
	public var size(get_size, never) : Int;
	
	public var root(get_root, never) : IComponentRoot<E>;

	public var debug(get_debug, set_debug) : Bool;
	
	public var eventManager(default, setEventManager) : IComponentEventManager<E>;
	
	public var renderManager(default, setRenderManager) : IComponentRenderManager<E>;

	public var eventParent(get_eventParent, never) : IComponentEventTarget;
	
	private var _bounds : Rectangle;

	private var _quadTree : IQuadTree<IComponent>;

	private var _signal : ISignal1<ContainerEvent>;

	private var _captureHooks : IList<IComponentEventTargetHook>;
	
	public function new() {
		_bounds = new Rectangle(0, 0, 250, 250);
		_quadTree = new QuadTree<IComponent>(250, 250);

		_signal = new Signal1<ContainerEvent>();

		_captureHooks = nil.list();
	}

	public function addContainerObserver(observer : IContainerObserver) : Void {
		_signal.add(observer.onContainerUpdate);
	}

	public function removeContainerObserver(observer : IContainerObserver) : Void {
		_signal.remove(observer.onContainerUpdate);
	}

	public function addCaptureHook(hook : IComponentEventTargetHook) : Void {
		_captureHooks = _captureHooks.prepend(hook);
	}
		
	public function removeCaptureHook(hook : IComponentEventTargetHook) : Void {
		_captureHooks = _captureHooks.filterNot(function(h : IComponentEventTargetHook) : Bool {
			return expect(h).toEqual(hook);
		});
	}
	
	public function add(component : IComponent) : IComponent {
		_quadTree = _quadTree.add(component);

		notify(ContainerEventType.COMPONENT_ADDED);

		return component;
	}

	public function addAt(component : IComponent, index : Int) : IComponent {
		_quadTree = _quadTree.addAt(component, index);

		notify(ContainerEventType.COMPONENT_ADDED);

		return component;
	}

	public function remove(component : IComponent) : IComponent {
		_quadTree = _quadTree.remove(component);

		invalidate();

		return component;
	}

	public function removeAt(index : Int) : Option<IComponent> {
		var comp : Option<IComponent> = _quadTree.getAt(index);
		switch(comp){
			case Some(x):
				_quadTree = _quadTree.removeAt(index);
				
				invalidate();
			case None:	
		}
		return comp;
	}

	public function getAt(index : Int) : IComponent {
		return switch(_quadTree.getAt(index)) {
			case Some(x): x;
			case None: null;
		}
	}

	public function contains(component : IComponent) : Bool {
		return _quadTree.contains(component);
	}

	public function getIndex(component : IComponent) : Int {
		return _quadTree.indexOf(component);
	}

	public function getComponentsIntersectsPoint(point : Point) : IList<IComponent> {
		return _quadTree.queryPoint(point);
	}

	public function getComponentsIntersectsRectangle(rect : Rectangle) : IList<IComponent> {
		return _quadTree.queryRectangle(rect);
	}
	
	public function invalidate() : Void {
		renderManager.invalidate();
	}

	public function iterator() : Iterator<IComponent> {
		return _quadTree.iterator();
	}

	public function preCaptureEventTarget(point : Point) : IComponentEventTarget {
		if(_captureHooks.nonEmpty) {
			var p : IList<IComponentEventTargetHook> = _captureHooks;
			while(p.nonEmpty) {

				var head : IComponentEventTargetHook = p.head;
				var result : IComponentEventTarget = head.captureEventTarget(point);

				if(result.isDefined()) {
					return result;
				}

				p = p.tail;
			}
		} 

		return captureEventTarget(point);
	}

	public function captureEventTarget(point : Point) : IComponentEventTarget {
		var items : IList<IComponent> = getComponentsIntersectsPoint(point).reverse;
		for(item in items) {
			var component : IComponent = item;
			var target : IComponentEventTarget = component.preCaptureEventTarget(point);
			if(target != null) {
				return target;
			}
		}
		return null;
	}

	public function onComponentRenderManagerUpdate(	manager : IComponentRenderManager<E>,
												type : ComponentRenderManagerUpdateType) : Void {
		switch(type) {
			case PRE_RENDER: _quadTree.integrate();
			case POST_RENDER:
		}
	}

	public function onComponentEventManagerUpdate(	manager : IComponentEventManager<E>, 
													type : ComponentEventManagerUpdateType) : Void {
		switch(type) {
			case RESIZE(w, h):
				_bounds.setValues(0, 0, w, h);

				renderManager.resizeTo(w, h);

				_quadTree.rect = _bounds;

				invalidate();
		}
	}

	public function processEvent(event : UIEvent) : Void {

	}

	public function notify(type : ContainerEventType) : Void {
		_signal.dispatch(new ContainerEvent(type));
	}
	
	private function get_size() : Int {
		return _quadTree.size;
	}
	
	private function get_root() : IComponentRoot<E> {
		return this;
	}

	private function get_eventParent() : IComponentEventTarget {
		return null;
	}
	
	private function setEventManager(value : IComponentEventManager<E>) : 
																	IComponentEventManager<E> {
		if(eventManager.isDefined()) {
			eventManager.removeEventManagerObserver(this);
			eventManager.onEventManagerCleanup();
			eventManager = null;
		}
		
		if(value != eventManager) {
			eventManager = value;
			eventManager.addEventManagerObserver(this);
			eventManager.onEventManagerInitialize(this);
		}
		return eventManager;
	}
	
	private function setRenderManager(value : IComponentRenderManager<E>) : 
																	IComponentRenderManager<E> {
		if(renderManager.isDefined()) {
			renderManager.removeRenderManagerObserver(this);
			renderManager.onRenderManagerCleanup();
			renderManager = null;
		}
		
		if(value != renderManager) {
			renderManager = value;
			renderManager.addRenderManagerObserver(this);
			renderManager.onRenderManagerInitialize(this);
		}
		return renderManager;
	}

	private function get_debug() : Bool {
		return renderManager.debug;
	}

	private function set_debug(value : Bool) : Bool {
		renderManager.debug = value;
		return renderManager.debug;
	}

	public function toString() : String {
		return "[Root]";
	}
}
