package funk.gui.core.events;

import funk.gui.core.geom.Point;

interface IComponentEventTargetHook {

	function captureEventTarget(point : Point) : IComponentEventTarget;
}