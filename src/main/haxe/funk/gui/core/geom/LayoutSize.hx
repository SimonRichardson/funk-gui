package funk.gui.core.geom;

class LayoutSize {
	
	public var min(default, default) : Size;
	
	public var max(default, default) : Size;
	
	public var size(default, default) : Size;
	
	public function new() {
		min = new Size();
		max = new Size();
		size = new Size();
	}
	
	public function setMinSize(width : Float, height : Float) : Void {
		min.width = width;
		min.height = height;
	}
	
	public function setMaxSize(width : Float, height : Float) : Void {
		max.width = width;
		max.height = height;
	}
	
	public function setSize(width : Float, height : Float) : Void {
		size.width = width;
		size.height = height;
	}
	
	public function setFixedSize(width : Float, height : Float) : Void {
		setMinSize(width, height);
		setMaxSize(width, height);
		setSize(width, height);
	}
}
