package funk.gui.core.geom;

import funk.gui.core.geom.Point;

class Rectangle {
	
	public var x(default, default) : Float;
	
	public var y(default, default) : Float;
	
	public var width(default, default) : Float;
	
	public var height(default, default) : Float;

	public var left(getLeft, setLeft): Float;

	public var right(getRight, setRight) : Float;

	public var top(getTop, setTop) : Float;

	public var bottom(getBottom, setBottom) : Float; 

	public var topLeft(getTopLeft, setTopLeft) : Point;

	public var bottomRight(getBottomRight, setBottomRight) : Point;

	public function new(?x : Float = 0.0, ?y : Float = 0.0, ?w : Float = 0.0, ?h : Float = 0.0) {
		moveTo(x, y);
		resizeTo(w, h);
	}

	public function clone() : Rectangle {
		return new Rectangle(x, y, width, height);
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

	public function intersects(rect : Rectangle) : Bool {
		return !(rect.x > right || rect.right < left || rect.top > bottom || rect.bottom < top);
	}
	
	public function union(rect : Rectangle) : Rectangle {
		var nx = x > rect.x  ? rect.x : x;
		var nr = right < rect.right  ? rect.right : right;
		var ny = y > rect.y  ? rect.y : y;
		var nb = bottom < rect.bottom  ? rect.bottom : bottom;
		return new Rectangle(nx, ny, nr - nx, nb - ny);
	}

	private function getLeft() : Float {
		return x;
	}

	private function setLeft(value : Float) : Float {
		width -= value - x;
		x = value;
		return value;
	}

	private function getRight() : Float {
		return x + width;
	}

	private function setRight(value : Float) : Float {
		width = value - x;
		return value;
	}

	private function getTop() : Float {
		return y;
	}

	private function setTop(value : Float) : Float {
		height -= value - y;
		y = value;
		return value;
	}

	private function getBottom() : Float {
		return y + height;
	}

	private function setBottom(value : Float) : Float {
		height = value - y;
		return value;
	}

	private function getTopLeft() : Point {
		return new Point(x, y);
	}

	private function setTopLeft(value : Point) : Point {
		x = value.x;
		y = value.y;
		return value;
	}

	private function getBottomRight() : Point {
		return new Point(x + width, y + height);
	}

	private function setBottomRight(value : Point) : Point {
		width = value.x - x;
		height = value.y - y;
		return value;
	}
}
