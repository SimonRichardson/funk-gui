package funk.gui.core;

import funk.gui.core.IContainer;

interface IComponentRoot<T> {

	var root(dynamic, never) : IComponentRoot<T>;
	
	function invalidate() : Void;
}
