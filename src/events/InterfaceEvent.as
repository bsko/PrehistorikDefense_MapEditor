package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author author
	 */
	public class InterfaceEvent extends Event 
	{
		static public const INTERFACE_EVENT:String = "interfaceevent";
		static public const ERASER_MOD:String = "erasermod";
		static public const OBJECTS_MOD:String = "objectsmod";
		static public const ABLE_MAP_MOD:String = "ablemapmod";
		static public const TILES_MOD:String = "tilesmod";
		static public const UP_OBJ_MODE:String = "upobjmod";
		static public const DOWN_OBJ_MODE:String = "downobjmod";
		static public const OTHERS_MODE:String = "othersmod";
		static public const CHECKS_MODE:String = "checksmod";
		static public const CH_LINE_MODE:String = "chlinemod";
		static public const SAVE_SIGNATURE:String = "savesignature";
		static public const DELETE_CHECKS:String = "deletechecks";
		private var _subtype:String;
		
		public function InterfaceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, subtype:String = ERASER_MOD ) 
		{ 
			super(type, bubbles, cancelable);
			_subtype = subtype;
		} 
		
		public override function clone():Event 
		{ 
			return new InterfaceEvent(type, bubbles, cancelable, _subtype);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("InterfaceEvent", "type", "bubbles", "cancelable", "eventPhase", "_subtype"); 
		}
		
		public function get subtype():String { return _subtype; }
		
	}
	
}