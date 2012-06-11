package funk.gui.core.display;

import funk.gui.core.IComponentRoot;

interface IComponentRenderManager<E> {
	
	var context(dynamic, never) : E;
	
	function onRenderManagerInitialize(root : IComponentRoot<E>) : Void;
	
	function onRenderManagerCleanup() : Void;
	
	function invalidate() : Void;
}
