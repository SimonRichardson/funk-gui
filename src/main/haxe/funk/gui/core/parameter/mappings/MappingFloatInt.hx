package funk.gui.core.parameter.mappings;

class MappingFloatInt implements IParameterMapping<Float, Int> {
	
	private var _min : Int;
	private var _max : Int;
	
	public function new(?min:Int = 0, ?max:Int = 1) {
		_min = min;
		_max = max;
	}
	
	public function map(value : Float) : Int {
		if(value > _max) value = _max;
		if(value < _min) value = _min;
		
		return roundedInt(_min + value * (_max - _min));
	}
	
	public function unmap(value : Int) : Float {
		return (value - _min) / (_max - _min);
	}
	
	inline private function roundedInt(value : Float) : Int {
		return if( value > 0 ) {
			Std.int(value + .5);
		} else if( value < 0 ) {
			Std.int( -value + .5 );
		} else {
			0;
		}
	}
}
