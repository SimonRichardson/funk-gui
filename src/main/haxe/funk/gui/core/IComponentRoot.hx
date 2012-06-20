package funk.gui.core;

import funk.collections.IList;
import funk.gui.core.geom.Point;
import funk.gui.core.geom.Rectangle;
import funk.gui.core.IComponent;
import funk.gui.core.IContainer;
import funk.gui.core.display.IComponentRenderManager;
import funk.gui.core.events.IComponentEventManager;
import funk.gui.core.events.IComponentEventTarget;

interface IComponentRoot<E> implements IContainer, implements IComponentEventTarget {

	var root(dynamic, never) : IComponentRoot<E>;

	var eventManager(default, setEventManager) : IComponentEventManager<E>;

	var renderManager(default, setRenderManager) : IComponentRenderManager<E>;

	var debug(dynamic, dynamic) : Bool;

	function addContainerObserver(observer : IContainerObserver) : Void;

	function removeContainerObserver(observer : IContainerObserver) : Void;

	function getComponentsIntersectsPoint(point : Point) : IList<IComponent>;

	function getComponentsIntersectsRectangle(rect : Rectangle) : IList<IComponent>;
	
	function invalidate() : Void;

	function iterator() : Iterator<IComponent>;
}
