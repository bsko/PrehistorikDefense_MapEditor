package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import menus.MainInterface;
	
	/**
	 * ...
	 * @author author
	 */
	public class Main extends Sprite 
	{
		public static var interfaceLayer:Sprite = new Sprite();
		public static var saveSignatureLayer:Sprite = new Sprite();
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			App.universe = new Universe();
			App.universe.x = 150;
			App.universe.y = 150;
			App.lvleditor = new LvlEditorInterface();
			App.lvleditor.x = 0;
			App.lvleditor.y = 0;
			addChild(App.lvleditor);
			App.universe.init();
			addChild(App.universe);
			addChild(saveSignatureLayer);
		}
	}
	
}