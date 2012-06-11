package funk.gui.core.display;

enum ComponentRenderManagerUpdateType {
	PRE_RENDER;
	POST_RENDER;
}

interface IComponentRenderManagerObserver<E> {

	function onComponentRenderManagerUpdate(	manager : IComponentRenderManager<E>,
												type : ComponentRenderManagerUpdateType) : Void;
}