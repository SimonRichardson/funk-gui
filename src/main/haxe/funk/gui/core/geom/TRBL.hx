package funk.gui.core.geom;

class TRBL {
	
	public var top(default, default) : Float;
	
	public var right(default, default) : Float;
	
	public var bottom(default, default) : Float;
	
	public var left(default, default) : Float;
	
	public function new(?t : Float = 0.0, ?r : Float = 0.0, ?b : Float = 0.0, ?l : Float = 0.0) {
		setValues(t, r, b, l);
	}
	
	public function setValues(t : Float, r : Float, b : Float, l : Float) : Void {
		top = t;
		right = r;
		bottom = b;
		left = l;
	}
}
