package funk.gui.core.geom;

class Point {
	
	public var x(default, default) : Float;
	
	public var y(default, default) : Float;
	
	public function new(?x : Float = 0.0, ?y : Float = 0.0) {
		moveTo(x, y);
	}

	public function clone() : Point {
		return new Point(x, y);
	}
	
	public function moveTo(x : Float, y : Float) : Void {
		this.x = x;
		this.y = y;
	}

	public function normalize(value : Float) : Void {
		if(x == 0 && y == 0) x = value;
		else {
			var norm = value / Math.sqrt(x * x + y * y);
			x *= norm;
			y *= norm;
		}
	}
}
