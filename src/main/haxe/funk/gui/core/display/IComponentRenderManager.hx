package funk.gui.core.display;

import funk.gui.Root;

interface IComponentRenderManager {
	
	function onRenderManagerInitialize(root : Root) : Void;
	
	function onRenderManagerCleanup() : Void;
}
