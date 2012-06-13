package funk.gui.core.events;

import funk.gui.core.geom.Point;
import funk.gui.core.events.UIEvent;

interface IComponentEventTarget {

	var eventParent(dynamic, never) : IComponentEventTarget;
		
	function captureEventTarget(point : Point) : IComponentEventTarget;

	function processEvent(event : UIEvent) : Void;
}
