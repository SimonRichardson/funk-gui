package funk.gui.core.parameter.mappings;

import funk.gui.core.parameter.IParameterMapping;

class MappingIntBool implements IParameterMapping<Int, Bool> {
	
	public function new() {
	}
	
	public function map(value : Int) : Bool {
		return value >= 1;
	}
	
	public function unmap(value : Bool) : Int { 
		return value ? 1 : 0;
	}
}

