package gui.js.core.event;

import funk.gui.core.events.IComponentEventManager;
import funk.gui.Root;
import js.Dom;

class EventManager implements IComponentEventManager<HtmlDom> {
	
	private var _root : Root<HtmlDom>;
	
	private var _context : HtmlDom;
	
	public function new(){
	}
	
	public function onEventManagerInitialize(root : Root<HtmlDom>) : Void {
		_root = root;
		
		_context = _root.renderManager.context;
	}
	
	public function onEventManagerCleanup() : Void {
		_root = null;
	}
}
