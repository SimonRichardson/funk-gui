package funk.gui.core.geom;

class Rectangle {
	
	public var x(default, default) : Float;
	
	public var y(default, default) : Float;
	
	public var width(default, default) : Float;
	
	public var height(default, default) : Float;
	
	public function new(?x : Float = 0.0, ?y : Float = 0.0, ?w : Float = 0.0, ?h : Float = 0.0) {
		moveTo(x, y);
		resizeTo(w, h);
	}
	
	public function moveTo(x : Float, y : Float) : Void {
		this.x = x;
		this.y = y;
	}
	
	public function resizeTo(w : Float, h : Float) : Void {
		this.width = w;
		this.height = h;
	}
	
	public function containsPoint(point : Point) : Bool {
		var px = point.x;
		var py = point.y;
		return (px >= x && px <= width && py >= y && py <= height);
	}
}
