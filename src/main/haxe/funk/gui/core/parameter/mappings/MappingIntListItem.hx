package funk.gui.core.parameter.mappings;

import funk.collections.IList;
import funk.option.Option;

class MappingIntListItem<T> implements IParameterMapping<Int, T> {
	
	private var _list : IList<T>;
	
	public function new(?list:IList<T>) {
		_list = list;
	}
	
	public function map(value : Int) : T {
		return switch(_list.get(value)) {
			case Some(x): x;
			case None:
		}
	}
	
	public function unmap(value : T) : Int {
		return _list.indexOf(value);
	}
}
