package funk.gui.core.display;

import funk.collections.IList;
import funk.collections.IQuadTree;
import funk.collections.mutable.Nil;
import funk.errors.RangeError;
import funk.gui.core.geom.Point;
import funk.gui.core.geom.Rectangle;
import funk.option.Option;
import funk.product.Product;
import funk.product.ProductIterator;
import funk.unit.Expect;

using funk.collections.mutable.Nil;
using funk.unit.Expect;

class QuadTree<T : IComponent> extends Product, implements IQuadTree<T> {

	private static var MAX_RECURSION : Int = 3;

	public var rect(get_rect, set_rect) : IQuadTreeRectangle;

    public var size(get_size, never): Int;

    public var hasDefinedSize(get_hasDefinedSize, never): Bool;

    public var toArray(get_toArray, never): Array<T>;

	private var _quad : QuadTreeNode<T>;

	private var _nodes : IList<T>;

	public function new(width : Float, height : Float) {
		super();

		_nodes = nil.list();
		_quad = new QuadTreeNode<T>(new Rectangle(0, 0, width, height), MAX_RECURSION);
	}

	public function add(value : T) : IQuadTree<T> {
		_nodes = _nodes.prepend(value);
		return this;
	}

	public function addAt(value : T, index : Int) : IQuadTree<T> {
		if(index == 0) {
			_nodes = _nodes.prepend(value);
		} else if(index == size) {
			_nodes = _nodes.append(value);
		} else if(index < 0 || index > size) {
			throw new RangeError();
		} else {
			var n : Int = 0;
			_nodes = _nodes.flatMap(function(v : T) : IList<T> {
				var l : IList<T> = nil.list();
				l.prepend(v);

				if(index == n) {
					l.prepend(value);
				}

				n++;
				return l;
			});
		}

		return this;
	}

	public function remove(value : T) : IQuadTree<T> {
		_nodes = _nodes.filterNot(function(v : T) : Bool {
			return expect(value).toEqual(v);
		});
		return this;
	}

	public function removeAt(index : Int) : IQuadTree<T> {
		var n : Int = 0;
		_nodes = _nodes.filterNot(function(v : T) : Bool {
			return n++ == index;
		});
		return this;
	}

	public function get(value : T) : Option<T> {
		return _nodes.get(_nodes.indexOf(value));
	}

	public function getAt(index : Int) : Option<T> {
		return _nodes.get(index);
	}

	public function contains(value : T) : Bool {
		return _nodes.contains(value);
	}

	public function indexOf(value : T) : Int {
		return _nodes.indexOf(value);
	}

	public function queryPoint(value : IQuadTreePoint) : IList<T> {
		return switch(_quad.queryPoint(cast value)){
			case Some(x): x.nodes;
			case None: nil.list();
		}
	}

	public function queryRectangle(value : IQuadTreeRectangle) : IList<T> {
		return switch(_quad.queryRectangle(cast value)){
			case Some(x): x.nodes;
			case None: nil.list();
		}
	}

	public function integrate() : Void {
		_quad.clearAll();

		for(n in _nodes) {
			_quad.add(n);
		}
	}

	public function describe() : String {
		var buffer : StringBuf = new StringBuf();
		_quad.describe(buffer, "\n");
		return buffer.toString();
	}

	override public function iterator() : IProductIterator<Dynamic> {
		return _nodes.iterator();
	}

	override public function productElement(i : Int) : Dynamic {
		return _nodes.productElement(i);
	}

	private function get_rect() : IQuadTreeRectangle {
		return _quad.rect;
	}

	private function set_rect(value : IQuadTreeRectangle) : IQuadTreeRectangle {
		_quad.rect = cast value;
		return value;
	}

	private function get_size() : Int {
		return _nodes.size;
	}

	private function get_hasDefinedSize() : Bool {
		return _nodes.hasDefinedSize;
	}

	private function get_toArray() : Array<T> {
		return _nodes.toArray;
	}

	override private function get_productArity() : Int {
		return size;
	}

	override private function get_productPrefix() : String {
		return "QuadTree";
	}
}

private class QuadTreeNode<T : IComponent> {

	public var nodes(get_nodes, never) : IList<T>;

	public var rect(get_rect, set_rect) : Rectangle;

	private var _rect : Rectangle;

	private var _cacheRectangle : Rectangle;

	private var _level : Int;

	private var _leaf : Bool;

	private var _nodes : IList<T>;

	private var _q0 : QuadTreeNode<T>;

	private var _q1 : QuadTreeNode<T>;

	private var _q2 : QuadTreeNode<T>;

	private var _q3 : QuadTreeNode<T>;

	public function new(rect : Rectangle, level : Int) {
		_rect = rect;
		_level = level;

		_leaf = level == 0;

		_cacheRectangle = new Rectangle();

		if(!_leaf){ 
			var l : Int = level - 1;

			var qx : Float = _rect.x;
			var qy : Float = _rect.y;
			var qw : Float = _rect.width * 0.5;
			var qh : Float = _rect.height * 0.5;

			_q0 = new QuadTreeNode<T>(new Rectangle(qx, qy, qw, qh), l);
			_q1 = new QuadTreeNode<T>(new Rectangle(qx + qw, qy, qw, qh), l);
			_q2 = new QuadTreeNode<T>(new Rectangle(qx, qy + qh, qw, qh), l);
			_q3 = new QuadTreeNode<T>(new Rectangle(qx + qw, qy + qh, qw, qh), l);
		} else {
			_nodes = nil.list();
		}
	}

	public function add(value : T) : Void {
		if(_leaf) {
			_nodes = _nodes.prepend(value);
		} else {
			var bounds : Rectangle = value.view.bounds;
			
			if(_q0.rect.intersects(bounds)) _q0.add(value);
			
			if(_q1.rect.intersects(bounds)) _q1.add(value);
			
			if(_q2.rect.intersects(bounds)) _q2.add(value);
			
			if(_q3.rect.intersects(bounds)) _q3.add(value);
		}
	}

	public function clearAll() : Void {
		if(_leaf) {
			_nodes = nil.list();
		} else {
			_q0.clearAll();
			_q1.clearAll();
			_q2.clearAll();
			_q3.clearAll();
		}
	}

	public function queryPoint(value : Point) : Option<QuadTreeNode<T>> {
		if(_leaf) {
			return _rect.containsPoint(value) ? Some(this) : None;
		} else {

			var op : Option<QuadTreeNode<T>> = None;

			if(_q0.rect.containsPoint(value)) {
				op = _q0.queryPoint(value);
			} else if(_q1.rect.containsPoint(value)) {
				op = _q1.queryPoint(value);
			} else if(_q2.rect.containsPoint(value)) {
				op = _q2.queryPoint(value);
			} else if(_q3.rect.containsPoint(value)) {
				op = _q3.queryPoint(value);
			}

			return op;
		}
	}

	public function queryRectangle(value : Rectangle) : Option<QuadTreeNode<T>> {
		return if(_leaf) {
			_rect.intersects(value) ? Some(this) : None;
		} else {

			if(_q0.rect.intersects(value)) {
				_q0.queryRectangle(value);
			} else if(_q1.rect.intersects(value)) {
				_q1.queryRectangle(value);
			} else if(_q2.rect.intersects(value)) {
				_q2.queryRectangle(value);
			} else if(_q3.rect.intersects(value)) {
				_q3.queryRectangle(value);
			} else {
				None;
			}
		}
	}

	public function iterator() : Iterator<T> {
		return _nodes.iterator();
	}

	public function describe(buffer : StringBuf, indent : String) : Void {
		buffer.add(indent + "Level : " + _level + " - Rect " + _rect.toString());

		if(!_leaf) {
			buffer.add(indent + "Quad0:");
			_q0.describe(buffer, indent + "\t");
			buffer.add(indent + "Quad1:");
			_q1.describe(buffer, indent + "\t");
			buffer.add(indent + "Quad2:");
			_q2.describe(buffer, indent + "\t");
			buffer.add(indent + "Quad3:");
			_q3.describe(buffer, indent + "\t");
		} 
	}

	private function get_nodes() : IList<T> {
		return _nodes;
	}

	private function get_rect() : Rectangle {
		return _rect;
	}

	private function set_rect(value : Rectangle) : Rectangle {
		_rect = value.clone();
		
		if(!_leaf) {

			var qx : Float = value.x;
			var qy : Float = value.y;
			var qw : Float = value.width * 0.5;
			var qh : Float = value.height * 0.5;

			_cacheRectangle.width = qw;
			_cacheRectangle.height = qh;

			_cacheRectangle.x = qx;
			_cacheRectangle.y = qy;

			_q0.rect = _cacheRectangle;

			_cacheRectangle.x = qx + qw;
			_cacheRectangle.y = qy;

			_q1.rect = _cacheRectangle;

			_cacheRectangle.x = qx;
			_cacheRectangle.y = qy + qh;

			_q2.rect = _cacheRectangle;

			_cacheRectangle.x = qx + qw;
			_cacheRectangle.y + qy + qh;

			_q3.rect = _cacheRectangle;
		}

		return value;
	}
}