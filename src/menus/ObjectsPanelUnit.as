package menus 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author author
	 */
	public class ObjectsPanelUnit extends Sprite 
	{
		static public const OFFSET:int = 20;
		public var widthTile:int = 61;
		public var heightTile:int = 53;
		
		public function ObjectsPanelUnit(tiles:MovieClip, startIndex:int, endIndex:int) 
		{
			var nameClass:String = getQualifiedClassName(tiles);
			var movieObject:Class = getDefinitionByName(nameClass) as Class;
			var tmpBtn:MovieClip;
			var heightIndex:int = 0;
			var widthIndex:int = 0;
			var widthTile:int = 61;
			var heightTile:int = 53;
			x = widthTile / 2;
			y = heightTile / 2;
			for (var i:int = startIndex; i < endIndex; i++)
			{ 
				heightIndex = int((i % LvlEditorInterface.NUM_OBJECTS) / LvlEditorInterface.NUM_OBJECTS_WIDTH);
				widthIndex = int(i % LvlEditorInterface.NUM_OBJECTS_WIDTH);
				tmpBtn = new movieObject();
				tmpBtn.gotoAndStop(1);
				tmpBtn.tileContainer.gotoAndStop(i + 1);
				if (tmpBtn.tileContainer.width > widthTile || tmpBtn.tileContainer.height > heightTile)
				{
					resizeTile(tmpBtn.tileContainer);
				}
				tmpBtn.x = widthIndex * (OFFSET + widthTile) + OFFSET;
				tmpBtn.y = heightIndex * (OFFSET + widthTile) + OFFSET;
				tmpBtn.name = String(movieObject) + "_" + String(i + 1);
				addChild(tmpBtn);
				tmpBtn.addEventListener(MouseEvent.CLICK, onModeDefine, false, 0, true);
			}	
		}
		
		private function onModeDefine(e:MouseEvent):void 
		{
			var tmpArray:Array = e.currentTarget.name.split("_");
			switch (tmpArray[0])
			{
				case "[class ObjBtnMoviecopy]":
				for ( var i:int = 0; i < numChildren; i++)
				{
					(getChildAt(i) as MovieClip).gotoAndStop("OFF");
				}
				(e.currentTarget as MovieClip).gotoAndStop("ON");
				App.currentObject = tmpArray[1];
				App.currentLabel = (e.currentTarget as MovieClip).tileContainer.currentLabel;
				break;
				case "[class TileBtnMovie]":
				for (i = 0; i < numChildren; i++)
				{
					(getChildAt(i) as MovieClip).gotoAndStop("OFF");
				}
				(e.currentTarget as MovieClip).gotoAndStop("ON");
				App.currentObject = tmpArray[1];
				break;
			}
		}
		
		private function resizeTile(tile:MovieClip):void 
		{
			var k:Number;
			if (tile.width > widthTile)
			{
				k = (widthTile - 5) / tile.width;
				tile.scaleX = k;
				tile.scaleY = k;
			}
			if (tile.height > heightTile)
			{
				k = (heightTile - 7) / tile.height;
				tile.scaleX = k;
				tile.scaleY = k;
			}
		}
		
	}

}