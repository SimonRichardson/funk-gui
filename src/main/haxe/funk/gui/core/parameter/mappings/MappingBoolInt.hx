package funk.gui.core.parameter.mappings;

class MappingBoolInt implements IParameterMapping<Bool, Int> {
	
	public function new() {
	}
	
	public function map(value : Bool) : Int {
		return value ? 1 : 0;
	}
	
	public function unmap(value : Int) : Bool { 
		return value >= 1;
	}
}
