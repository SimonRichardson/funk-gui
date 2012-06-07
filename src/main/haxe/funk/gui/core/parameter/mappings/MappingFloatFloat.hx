package funk.gui.core.parameter.mappings;

class MappingFloatFloat implements IParameterMapping<Float, Float> {
	
	private var _min : Float;
	private var _max : Float;
	
	public function new(?min:Float = 0.0, ?max:Float = 1.0) {
		_min = min;
		_max = max;
	}
	
	public function map(value : Float) : Float {
		if(value > _max) value = _max;
		if(value < _min) value = _min;
		
		return _min + value * (_max - _min);
	}
	
	public function unmap(value : Float) : Float {
		return (value - _min) / (_max - _min);
	}
}
