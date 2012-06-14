package funk.gui.core.events;

import funk.gui.core.events.IComponentEventTarget;
import funk.gui.core.geom.Point;

enum UIEventType {
	FOCUS_OUT;
	FOCUS_IN(focusOut : IComponentEventTarget, focusIn : IComponentEventTarget);
	MOUSE_IN(position : Point);
	MOUSE_DOWN(position : Point);
	MOUSE_MOVE(position : Point, downPosition : Point);
	MOUSE_UP(position : Point);
	MOUSE_OUT(position : Point);
	KEY_DOWN(keyCode : Int, ctrlKey : Bool, shiftKey : Bool, altKey : Bool);
}

class UIEvent {

	public var target : IComponentEventTarget;

	public var currentTarget : IComponentEventTarget;

	public var lastTarget : IComponentEventTarget;

	public var bubbles : Bool;

	public var type(getType, never) : UIEventType;

	private var _type : UIEventType;

	public function new(type : UIEventType) {
		_type = type;

		bubbles = true;
	}

	private function getType() : UIEventType {
		return _type;
	}
}