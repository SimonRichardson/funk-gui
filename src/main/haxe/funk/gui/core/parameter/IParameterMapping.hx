package funk.gui.core.parameter;

interface IParameterMapping<A, B> {
	
	function map(value : A) : B;
	
	function unmap(value : B) : A;
}
