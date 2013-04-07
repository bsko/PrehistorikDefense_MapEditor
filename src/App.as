package  
{
	import flash.geom.Point;
	import menus.MainInterface;
	/**
	 * ...
	 * @author author
	 */
	public class App 
	{
		
		public static const W_DIV:int = 640;
		public static const H_DIV:int = 480;
		public static const Half_W_DIV:int = 320;
		public static const Half_H_DIV:int = 240;
		
		public static const MAP_SIZE:int = 24;
		public static const Cell_W:int = 61;
		public static const Cell_H:int = 35;
		public static const Half_Cell_W:Number = 30.5;
		public static const Half_Cell_H:Number = 17.5;
		
		public static var enemyTypesArray:Array = [];
		
		public static var koefA:int = (Cell_H * 5 - Half_Cell_H) / Cell_H;
		public static var koefC:int = Half_W_DIV / Cell_W;
		
		public static const CELL_STATE_SAND:int = 2;
		public static const CELL_STATE_GRASS:int = 3;
		public static const CELL_STATE_STONE:int = 4;
		public static const CELL_STATE_ROAD:int = 1;
		
		public static const CELL_HEIGHT_DELAY:int = -12;
		public static const CELL_STATE_BUSY:String = "BUSY";
		public static const CELL_STATE_FREE:String = "FREE";
		
		public static var universe:Universe;
		public static var mainInterface:MainInterface;
		public static var soundStatus:Boolean = true;
		public static var musicStatus:Boolean = true;
		
		public static const DELIMITER:String = "|";
		public static const DELIMITER2:String = "_";
		
		public static var currentEditor:int;
		public static var currentObject:int;
		public static var currentLabel:String;
		public static const TILES_EDIT:int = 1;
		public static const OBJ_EDIT:int = 2;
		public static const OTHER_EDIT:int = 3;
		public static const ERASER_EDIT:int = 4;
		public static const UP_OBJ_EDIT:int = 5;
		public static const DOWN_OBJ_EDIT:int = 6;
		public static const ABLE_MAP_EDIT:int = 7;
		public static const CHECKS_EDIT:int = 8;
		public static const CH_LINES_EDIT:int = 9;
		public static const DELETE_CHECKS:int = 10;
		
		public static var lvleditor:LvlEditorInterface;
		
		public static function randomInt(a:int, b:int):int
		{
			if (a >= b) { throw(Error("invalid variables")); }
			return int((Math.random() * (b - a)  + a));
		}
		
		public static function angleFinding(currentPoint:Point, nextPoint:Point):Number
		{
			var angle:Number;
			angle = (Math.atan((nextPoint.x - currentPoint.x) / (nextPoint.y - currentPoint.y)) * 180 / Math.PI);
			angle = 360 - angle;
			if (nextPoint.y >= currentPoint.y) { angle += 180; } 
			return angle;
		}
	}

}