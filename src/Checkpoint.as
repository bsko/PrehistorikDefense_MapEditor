package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author author
	 */
	public class Checkpoint 
	{
		private static const DELAY_FROM_END_LINE_TO_CIRCLE:int = 12;
		public var currentPoint:Point;
		public var nextPointArray:Array = [];
		public var nextPointLinesArray:Array = [];
		public var flagSprite:Sprite = new FlagSprite();
		
		public function Checkpoint(curPoint:Point) 
		{
			currentPoint = curPoint;
		}
		
		public function addCheckpoint(nextCheck:Checkpoint):Boolean
		{
			for (var i:int = 0; i < nextPointArray.length; i++)
			{
				if (nextCheck == nextPointArray[i])
				{
					return false;
				}
			}
			if (currentPoint.x != nextCheck.currentPoint.x && currentPoint.y != nextCheck.currentPoint.y)
			{
				return false;
			}
			nextPointArray.push(nextCheck);
			var tmpSprite:Sprite = new Sprite();
			var tmpY:int = - App.Cell_H * 5 + App.Half_Cell_H + currentPoint.y * App.Half_Cell_H + App.Half_Cell_H * currentPoint.x;
			var tmpX:int = App.Half_W_DIV + currentPoint.x * App.Half_Cell_W - App.Half_Cell_W * currentPoint.y;
			tmpSprite.graphics.moveTo(tmpX, tmpY);
			var tmpX2:int = App.Half_W_DIV + nextCheck.currentPoint.x * App.Half_Cell_W - App.Half_Cell_W * nextCheck.currentPoint.y;
			var tmpY2:int = - App.Cell_H * 5 + App.Half_Cell_H + nextCheck.currentPoint.y * App.Half_Cell_H + App.Half_Cell_H * nextCheck.currentPoint.x;
			tmpSprite.graphics.lineStyle(2, 0xFF0000);5
			tmpSprite.graphics.lineTo(tmpX2, tmpY2);
			var distance:Number = Point.distance(new Point(tmpX, tmpY), new Point(tmpX2, tmpY2));
			var delay:Number = 1 - (DELAY_FROM_END_LINE_TO_CIRCLE / distance);
			var tmpPoint:Point = Point.interpolate(new Point(tmpX2, tmpY2), new Point(tmpX, tmpY), delay);
			tmpSprite.graphics.beginFill(0xFFFFFF);
			tmpSprite.graphics.lineStyle(2, 0xFF0000);
			tmpSprite.graphics.drawCircle(tmpPoint.x, tmpPoint.y, 5);
			tmpSprite.graphics.endFill();
			nextPointLinesArray.push(tmpSprite);
			return true;
		}
	}

}