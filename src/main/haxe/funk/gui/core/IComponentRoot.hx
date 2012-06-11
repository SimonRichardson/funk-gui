package funk.gui.core;

import funk.collections.IList;
import funk.gui.core.geom.Point;
import funk.gui.core.geom.Rectangle;
import funk.gui.core.IComponent;
import funk.gui.core.display.IComponentRenderManager;
import funk.gui.core.events.IComponentEventManager;
import funk.option.Option;

interface IComponentRoot<E> {

	var root(dynamic, never) : IComponentRoot<E>;

	var eventManager(default, setEventManager) : IComponentEventManager<E>;

	var renderManager(default, setRenderManager) : IComponentRenderManager<E>;

	function getComponentsIntersectsPoint(point : Point) : Option<IList<IComponent>>;

	function getComponentsIntersectsRectangle(rect : Rectangle) : Option<IList<IComponent>>;
	
	function invalidate() : Void;

	function iterator() : Iterator<IComponent>;
}
