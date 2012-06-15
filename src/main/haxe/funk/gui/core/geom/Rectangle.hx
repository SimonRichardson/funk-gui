package funk.gui.core.geom;

import funk.gui.core.geom.Point;

class Rectangle {
	
	public var x : Float;
	
	public var y : Float;
	
	public var width : Float;
	
	public var height : Float;

	public var left(getLeft, setLeft): Float;

	public var right(getRight, setRight) : Float;

	public var top(getTop, setTop) : Float;

	public var bottom(getBottom, setBottom) : Float; 

	public var topLeft(getTopLeft, setTopLeft) : Point;

	public var bottomRight(getBottomRight, setBottomRight) : Point;

	public function new(?x : Float = 0.0, ?y : Float = 0.0, ?w : Float = 0.0, ?h : Float = 0.0) {
		this.x = x;
		this.y = y;
		this.width = w;
		this.height = h;
	}

	public function clone() : Rectangle {
		return new Rectangle(x, y, width, height);
	}

	public function equals(rect : Rectangle) : Bool {
		return x == rect.x && y == rect.y && width == rect.width && height == rect.height;
	}

	public function setValues(x : Float, y : Float, w : Float, h : Float) : Void {
		this.x = x;
		this.y = y;
		this.width = w;
		this.height = h;
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
		return (px >= x && px < right && py >= y && py < bottom);
	}

	public function containsRect(rect : Rectangle) : Bool {
		var rx = rect.x;
		var ry = rect.y;
		var rw = rx + rect.width;
		var rh = ry + rect.height;

		return  (rx >= x && rx < right && ry >= y && ry < bottom) && 
				(rw >= x && rw < right && rh >= y && rh < bottom);
	}

	inline public function intersects(rect : Rectangle) : Bool {
		return !(rect.x > right || rect.right < left || rect.top > bottom || rect.bottom < top);
	}

	public function expand(value : Float) : Void {
		x -= value;
		y -= value;
		width += value;
		height += value;
	}
	
	public function union(rect : Rectangle) : Rectangle {
		var nx = x < rect.x ? x : rect.x;
		var ny = y < rect.y ? y : rect.y;
		var nr = right > rect.right ? right : rect.right;
		var nb = bottom > rect.bottom ? bottom : rect.bottom;

		return new Rectangle(nx, ny, nr - nx, nb - ny);
	}

	private function getLeft() : Float {
		return x;
	}

	private function setLeft(value : Float) : Float {
		width += x - value;
		x = value;
		return value;
	}

	private function getRight() : Float {
		return x + width;
	}

	private function setRight(value : Float) : Float {
		width = Math.max(value - x, 0);
		return value;
	}

	private function getTop() : Float {
		return y;
	}

	private function setTop(value : Float) : Float {
		height += y - value;
		y = value;
		return value;
	}

	private function getBottom() : Float {
		return y + height;
	}

	private function setBottom(value : Float) : Float {
		height = Math.max(value - y, 0);
		return value;
	}

	private function getTopLeft() : Point {
		return new Point(x, y);
	}

	private function setTopLeft(value : Point) : Point {
		left = value.x;
		top = value.y;
		return value;
	}

	private function getBottomRight() : Point {
		return new Point(x + width, y + height);
	}

	private function setBottomRight(value : Point) : Point {
		right = value.x;
		bottom = value.y;
		return value;
	}

	public function toString() : String {
		return "{x: " + x + ", y: " + y + ", width: " + width + ", height: " + height + "}";
	}
}
