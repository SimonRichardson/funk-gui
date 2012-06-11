package funk.gui;

import funk.collections.IList;
import funk.collections.IQuadTree;
import funk.option.Any;
import funk.option.Option;
import funk.gui.core.display.IComponentRenderManager;
import funk.gui.core.display.IComponentRenderManagerObserver;
import funk.gui.core.display.QuadTree;
import funk.gui.core.events.IComponentEventManager;
import funk.gui.core.events.IComponentEventManagerObserver;
import funk.gui.core.geom.Point;
import funk.gui.core.geom.Rectangle;
import funk.gui.core.IComponent;
import funk.gui.core.IComponentRoot;

using funk.option.Any;

class Root<E> 	implements IComponentRoot<E>, 
				implements IComponentEventManagerObserver<E>, 
				implements IComponentRenderManagerObserver<E> {
	
	public var size(get_size, never) : Int;
	
	public var root(get_root, never) : IComponentRoot<E>;
	
	public var eventManager(default, setEventManager) : IComponentEventManager<E>;
	
	public var renderManager(default, setRenderManager) : IComponentRenderManager<E>;
	
	private var _quadTree : IQuadTree<IComponent>;
	
	public function new() {
		_quadTree = new QuadTree<IComponent>(0, 0);
	}
	
	public function add(component : IComponent) : IComponent {
		_quadTree = _quadTree.add(component);

		invalidate();

		return component;
	}

	public function addAt(component : IComponent, index : Int) : IComponent {
		_quadTree = _quadTree.addAt(component, index);

		invalidate();

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

	public function getComponentsIntersectsPoint(point : Point) : Option<IList<IComponent>> {
		return None;
	}

	public function getComponentsIntersectsRectangle(rect : Rectangle) : Option<IList<IComponent>> {
		return None;
	}
	
	public function invalidate() : Void {
		renderManager.invalidate();
	}

	public function iterator() : Iterator<IComponent> {
		return _quadTree.iterator();
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
				_quadTree.width = w;
				_quadTree.height = h;

				invalidate();
		}
	}
	
	private function get_size() : Int {
		return _quadTree.size;
	}
	
	private function get_root() : IComponentRoot<E> {
		return this;
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
			eventManager.onEventManagerInitialize(this);
			eventManager.addEventManagerObserver(this);
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
			renderManager.onRenderManagerInitialize(this);
			renderManager.addRenderManagerObserver(this);
		}
		return renderManager;
	}
}
