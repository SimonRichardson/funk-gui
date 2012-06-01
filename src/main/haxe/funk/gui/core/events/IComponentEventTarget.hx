package funk.gui.core.events;

import funk.gui.core.geom.Point;

interface IComponentEventTarget {
	
	function preCaptureEventTarget(point : Point) : IComponentEventTarget;
	
	function captureEventTarget(point : Point) : IComponentEventTarget;
}
