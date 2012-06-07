package funk.gui.core.parameter;

interface IParameterObserver<A, B> {

	function onParameterValueChanged(oldValue : A, newValue : A) : Void;
	
	function onParameterNormalisedValueChanged(oldValue : B, newValue : B) : Void;
}
