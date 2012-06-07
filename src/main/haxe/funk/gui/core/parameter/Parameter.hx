package funk.gui.core.parameter;

import funk.signal.Signal2;

class Parameter<A, B> {
	
	public var value(getValue, setValue) : A;
	
	private var _value : A;
	
	private var _defaultValue : A;
	
	private var _normalisedValue : B;
	
	private var _mapping : IParameterMapping<A, B>;
	
	private var _valueSignal : ISignal2<A, A>;
	
	private var _normalisedValueSignal : ISignal2<B, B>;
	
	public function new(mapping : IParameterMapping<A, B>, ?value : A) {
		_mapping = mapping;
		_value = value;
		_defaultValue = value;
	}
	
	public function addParameterObserver(observer : IParameterObserver<A, B>) : IParameterObserver<A, B> {
		_valueSignal.add(observer.onParameterValueChanged);
		_normalisedValueSignal.add(observer.onParameterNormalisedValueChanged);
		return observer;
	}
	
	public function removeParameterObserver(observer : IParameterObserver<A, B>) : IParameterObserver<A, B> {
		_valueSignal.remove(observer.onParameterValueChanged);
		_normalisedValueSignal.remove(observer.onParameterNormalisedValueChanged);
		return observer;
	}
	
	private function valueChanged(v : A) : Void {
		if(v != _value) {
			_valueSignal.dispatch(v, _value);
		}
	}
	
	private function normalisedValueChanged(v : B) : Void {
		if(v != _normalisedValue) {
			_normalisedValueSignal.dispatch(v, _normalisedValue);	
		}
	}
	
	private function getValue() : A {
		return _value;
	}
	
	private function setValue(value : A) : A {
		var v : A = _value;
		var n : B = _normalisedValue;
		
		_value = value;
		_normalisedValue = _mapping.map(value);
		
		valueChanged(v);
		normalisedValueChanged(n);
		
		return _value;
	}
}
