package funk.gui.js.core.event;

import funk.gui.core.events.IComponentEventManager;
import funk.gui.Root;

import js.w3c.html5.Core;
import js.w3c.level3.Events;

class EventManager implements IComponentEventManager<HTMLCanvasElement> {
	
	private var _root : Root<HTMLCanvasElement>;
	
	private var _context : HTMLElement;
	
	public function new(){
	}
	
	public function onEventManagerInitialize(root : Root<HTMLCanvasElement>) : Void {
		_root = root;
		
		_context = _root.renderManager.context;
		_context.addEventListener('mousedown', handleEvent, false);
		_context.addEventListener('click', handleEvent, false);
	}
	
	public function onEventManagerCleanup() : Void {
		_context.removeEventListener('mousedown', handleEvent, false);
		_context.removeEventListener('click', handleEvent, false);
		_context = null;
		
		_root = null;
 	}
	
	private function handleEvent(event : Event) : Void {
		switch(event.type) {
			case 'mousedown': trace('mousedown');
			case 'click': trace('click');
		}
	}
}
