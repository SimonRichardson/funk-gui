package funk.gui.core.geom;

class Size {
	
	public var width(default, default) : Float;
	
	public var height(default, default) : Float;
	
	public function new(?w : Float = 0.0, ?h : Float = 0.0) {
		resizeTo(w, h);
	}
	
	public function resizeTo(w : Float, h : Float) : Void {
		this.width = w;
		this.height = h;
	}
}
