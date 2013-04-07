package  
{
	import flash.display.MovieClip;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author author
	 */
	public class Grid extends Sprite
	{
		private var _tileSkin:MovieClip = new tileMovie();
		private var _cellState:int;
		//public var ableSkin:MovieClip = new MarkersMovie();
		private var _ableState:String;
		private var _gridHeight:int;
		public var objectsArray:Array = [];
		private var _cellPosX:int
		private var _cellPosY:int
		private var _isCampOwner:Boolean;
		private var _isWheatOwner:Boolean;
		private var _isChestOwner:Boolean;
		
		public function Grid(x:int, y:int):void 
		{
			this.y = - App.Cell_H * 5 + App.Half_Cell_H + y * App.Half_Cell_H + App.Half_Cell_H * x;
			this.x = App.Half_W_DIV + x * App.Half_Cell_W - App.Half_Cell_W * y;
			_tileSkin.y = (-1) * height;
			addChild(_tileSkin);
			_tileSkin.name = "tileSkin_" + x.toString() + "_" + y.toString();
			cellState = App.CELL_STATE_GRASS;
			ableState = App.CELL_STATE_BUSY;
			cellPosX = x;
			cellPosY = y;
			_isCampOwner = false;
			_isWheatOwner = false;
			_isChestOwner = false;
			//addChild(ableSkin);
			//ableSkin.name = "GOVNO!!!!_" + x.toString() + "_" + y.toString();
			//ableSkin.visible = false;
		}
		
		public function addObject(_x:int, _y:int, type:int):void
		{
			var tmpObject:VisualObject = new VisualObject(type, cellPosX, cellPosY, _x, _y);
			addChild(tmpObject);
			tmpObject.x = _x;
			tmpObject.y = _y - gridHeight + App.CELL_HEIGHT_DELAY;
			objectsArray.push(tmpObject);
			//trace(tmpObject.x, tmpObject.y, this.gridHeight);
			//trace(tmpObject.localToGlobal(new Point(tmpObject.x, tmpObject.y)));
		}
		
		public function removeObject(objType:int):void
		{
			for (var i:int = 0; i < objectsArray.length; i++)
			{
				var tmpVisualObject:VisualObject = objectsArray[i];
				if (tmpVisualObject.type == objType)
				{
					removeChild(tmpVisualObject);
					objectsArray.splice(i, 1);
					return;
				}
			}
		}
		
		public function get cellState():int { return _cellState; }
		
		public function set cellState(value:int):void 
		{
			_cellState = value;
			_tileSkin.gotoAndStop(_cellState);
		}
		
		public function get ableState():String { return _ableState; }
		
		public function set ableState(value:String):void 
		{
			_ableState = value;
		}

		public function get gridHeight():int { return _gridHeight; }
		
		public function set gridHeight(value:int):void 
		{
			var tmpObject:VisualObject;
			for (var i:int = 0; i < objectsArray.length; i++)
			{
				tmpObject = objectsArray[i];
				//tmpObject.y = tmpObject.ydelay - value + App.CELL_HEIGHT_DELAY;
				tmpObject.y = tmpObject.y + _gridHeight - value;
				tmpObject.ydelay = tmpObject.y;
			}
			_gridHeight = value;
			_tileSkin.y = ( -1) * value;
		}
		
		public function get isCampOwner():Boolean { return _isCampOwner; }
		
		public function set isCampOwner(value:Boolean):void 
		{
			_isCampOwner = value;
		}
		
		public function get isWheatOwner():Boolean { return _isWheatOwner; }
		
		public function set isWheatOwner(value:Boolean):void 
		{
			_isWheatOwner = value;
		}
		
		public function get isChestOwner():Boolean { return _isChestOwner; }
		
		public function set isChestOwner(value:Boolean):void 
		{
			_isChestOwner = value;
		}
		
		public function get cellPosX():int { return _cellPosX; }
		
		public function set cellPosX(value:int):void 
		{
			_cellPosX = value;
		}
		
		public function get cellPosY():int { return _cellPosY; }
		
		public function set cellPosY(value:int):void 
		{
			_cellPosY = value;
		}
	}

}