package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author author
	 */
	public class VisualObject extends Sprite
	{
		private var _type:int;
		private var _objectSkin:MovieClip = new objectsMovie();
		private var _xdelay:int;
		private var _ydelay:int;
		
		public function VisualObject(type:int, cellX:int, cellY:int, xdelay:int, ydelay:int) 
		{
			_xdelay = xdelay;
			_ydelay = ydelay;
			addChild(_objectSkin);
			_objectSkin.gotoAndStop(type);
			_type = type;
			_objectSkin.name = "Object_" + cellX.toString() + "_" + cellY.toString() + "_" + _type;
		}
		
		public function get type():int { return _type; }
		
		public function get xdelay():int { return _xdelay; }
		
		public function get ydelay():int { return _ydelay; }
		
		public function set ydelay(value:int):void 
		{
			_ydelay = value;
		}
	}

}