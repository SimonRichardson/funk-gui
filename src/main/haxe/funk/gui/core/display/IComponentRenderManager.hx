package funk.gui.core.display;

import funk.gui.Root;

interface IComponentRenderManager<T> {
	
	var context(dynamic, never) : T;
	
	function onRenderManagerInitialize(root : Root<T>) : Void;
	
	function onRenderManagerCleanup() : Void;
	
	function invalidate() : Void;
}
