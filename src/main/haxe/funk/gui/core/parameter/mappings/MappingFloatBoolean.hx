package funk.gui.core.parameter.mappings;

import funk.gui.core.parameter.IParameterMapping;

class MappingFloatBoolean implements IParameterMapping<Float, Bool> {
	
	public function new() {
	}
	
	public function map(value : Float) : Bool {
		return value > 0.5;
	}
	
	public function unmap(value : Bool) : Float { 
		return value ? 1.0 : 0.0;
	}
}
