package funk.gui.core;

import funk.gui.core.Component;
import funk.gui.core.IComponentViewConfig;
import funk.gui.core.geom.Rectangle;
import funk.gui.core.geom.TRBL;

class ComponentView {
	
	public var x(get_x, never) : Float;
	
	public var y(get_y, never) : Float;
	
	public var width(get_width, never) : Float;
	
	public var height(get_height, never) : Float;

	public var bounds(get_bounds, never) : Rectangle;
	
	private var _bounds : Rectangle;
	
	private var _innerBounds : Rectangle;
	
	private var _outerBounds : Rectangle;
	
	private var _margin : TRBL;
	
	private var _padding : TRBL;
	
	public function new() {
		_bounds = new Rectangle();
		_innerBounds = new Rectangle();
		_outerBounds = new Rectangle();
		
		_margin = new TRBL();
		_padding = new TRBL();
	}
	
	private function configure(component : IComponent, config : IComponentViewConfig) : Void {
		var p : TRBL = config.padding;
		var m : TRBL = config.margin;

		_padding.setValues(p.top, p.right, p.bottom, p.left);
		_margin.setValues(m.top, m.right, m.bottom, m.left);
		
		var w : Float = -1;
		var h : Float = -1;
		
		if (config.size.min.width > -1) {
			w = config.size.min.width;
		}

		if (config.size.min.height > -1) {
			w = config.size.min.height;
		}

		if (config.size.max.width > -1) {
			w = config.size.max.width;
		}

		if (config.size.max.height > -1) {
			w = config.size.max.height;
		}

		if (config.size.size.width > -1) {
			w = config.size.size.width;
		}

		if (config.size.size.height > -1) {
			w = config.size.size.height;
		}

		if (w > -1 && h > -1)
		{
			component.resizeTo(w, h);
		}
	}
	
	private function moveTo(x : Float, y : Float) : Void {
		_bounds.x = x;
		_bounds.y = y;
		
		_innerBounds.x = _bounds.x + _padding.left;
		_innerBounds.y = _bounds.y + _padding.top;
		
		_outerBounds.x = _bounds.x - _margin.left;
		_outerBounds.y = _bounds.y - _margin.top;
	}
	
	private function resizeTo(width : Float, height : Float) : Void {
		_bounds.width = width;
		_bounds.height = height;
		
		_innerBounds.width = width - (_padding.left + _padding.right);
		_innerBounds.height = height - (_padding.top + _padding.bottom);
		
		_outerBounds.width = width + (_margin.left + _margin.right);
		_outerBounds.height = height + (_margin.top + _margin.bottom);
	}
	
	private function get_x() : Float {
		return _bounds.x;
	}
	
	private function get_y() : Float {
		return _bounds.y;
	}
	
	private function get_width() : Float {
		return _bounds.width;
	}
	
	private function get_height() : Float {
		return _bounds.height;
	}

	private function get_bounds() : Rectangle {
		return _bounds.clone();
	}
}
