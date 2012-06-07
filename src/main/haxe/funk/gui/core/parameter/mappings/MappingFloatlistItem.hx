package funk.gui.core.parameter.mappings;

import funk.collections.IList;
import funk.option.Option;

class MappingFloatlistItem<T> implements IParameterMapping<Float, T> {
	
	private var _list : IList<T>;
	
	public function new(?list:IList<T>) {
		_list = list;
	}
	
	public function map(value : Float) : T {
		return switch(_list.get(Std.int(value % _list.size))) {
			case Some(x): x;
			case None:
		}
	}
	
	public function unmap(value : T) : Float {
		return _list.indexOf(value);
	}
}
