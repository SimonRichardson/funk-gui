package funk.gui.core.events;

import funk.gui.core.geom.Point;

interface IComponentEventTarget {
		
	function captureEventTarget(point : Point) : IComponentEventTarget;
}
