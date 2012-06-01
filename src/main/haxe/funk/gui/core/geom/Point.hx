package funk.gui.core.geom;

class Point {
	
	public var x(default, default) : Float;
	
	public var y(default, default) : Float;
	
	public function new(?x : Float = 0.0, ?y : Float = 0.0) {
		moveTo(x, y);
	}
	
	public function moveTo(x : Float, y : Float) : Void {
		this.x = x;
		this.y = y;
	}
}
