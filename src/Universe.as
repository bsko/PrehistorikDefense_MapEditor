package  
{
	import events.InterfaceEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.engine.TypographicCase;
	/**
	 * ...
	 * @author author
	 */
	public class Universe extends Sprite
	{
		private var roadFieldSprite:Sprite = new Sprite();
		private var mapMask:Array;
		private var ablingMap:Array;
		private var enemiesArray:Array = [];
		private var cellPosX:int;
		private var cellPosY:int;
		private var _objectsLayer:Sprite = new Sprite();
		private var _campLayer:Sprite = new Sprite();
		private var _gridLayer:Sprite = new Sprite();
		private var _linesLayer:Sprite = new Sprite();
		private var _flagsLayer:Sprite = new Sprite();
		private var _objectsArray:Array = [];
		private var _followObj:MovieClip = new objectsMovie();
		private var _followTile:MovieClip = new tileMovie();
		private var _selectObjToDelete:Sprite;
		private var checkpointsArray:Array = [];
		private var _destination:int;
		private var _flagSprite:Sprite = new FlagSprite();
		private var _makeCheckLineFlag:Boolean;
		private var _currentCheck:Checkpoint;
		private var _ableGrid:Sprite = new Sprite();
		private var _isCampExists:Boolean;
		private var _campMovie:MovieClip = new CampMovie();
		
		public static var MapSignature:String;
		
		public function Universe() 
		{
			clearMapMask();
			addChild(roadFieldSprite);
			addChild(_objectsLayer);
			addChild(_campLayer);
			var ramkaSprite:Sprite = new ramkaMovie();
			ramkaSprite.mouseEnabled = false;
			var mask01:Sprite = new ramkaMovie();
			ramkaSprite.x = mask01.x = App.Half_W_DIV;
			ramkaSprite.y = mask01.y = App.Half_H_DIV;
			mask = mask01;
			addChild(_gridLayer);
			addChild(_ableGrid);
			_ableGrid.visible = false;
			addChild(_flagsLayer);
			_flagsLayer.visible = false;
			addChild(_linesLayer);
			_linesLayer.visible = false;
			addChild(ramkaSprite);
			addChild(mask01);
			
			//добавление видов врагов
			App.enemyTypesArray.push({label:"SaberTooth", data:"0"});
			App.enemyTypesArray.push({label:"BlueDino", data:"1"});
			App.enemyTypesArray.push({label:"DinozavrOrange", data:"2"});
			App.enemyTypesArray.push({label:"Frog", data:"3"});
			App.enemyTypesArray.push({label:"Kaban", data:"4"});
			App.enemyTypesArray.push({label:"Rat", data:"5"});
			App.enemyTypesArray.push({label:"Spider", data:"6"});
			App.enemyTypesArray.push({label:"ZlobniyGlist", data:"7"});
			App.enemyTypesArray.push({label:"Doublelegged", data:"8"});
			App.enemyTypesArray.push( { label:"WhiteTiger", data:"9" } );
			App.enemyTypesArray.push({label:"Thorner", data:"10"});
			App.enemyTypesArray.push({label:"Tiger", data:"11"});
			App.enemyTypesArray.push({label:"Pterodaktel", data:"12"});
			App.enemyTypesArray.push({label:"BigGreenBird", data:"13"});
			App.enemyTypesArray.push({label:"SmallBlackBird", data:"14"});
			
			var tmpSprite:Sprite = new Sprite();
			tmpSprite.graphics.moveTo(640, 440);
			tmpSprite.graphics.lineStyle(5, 0xFF0000);
			tmpSprite.graphics.lineTo(0, 440);
			tmpSprite.mouseEnabled = false;
			addChild(tmpSprite);
		}
		
		public function load(lvlSignatura:String):void 
		{
			//read from signature:   ---------------------------------------------------------------------------------------------
			var signatura:Array = lvlSignatura.split(App.DELIMITER);
			var _wavesArray:Array = [];
			
			//настройка волн
			var length:int = signatura.shift();
			var tmpArray:Array;
			for (var i:int = 0; i < length; i++)
			{
				var tmpWaveSignature:String = signatura.shift();
				tmpArray = tmpWaveSignature.split(App.DELIMITER2);
				var tmpAddedWave:Wave = new Wave();
				var isThereAKey:Boolean = false;
				var isBossWave:Boolean = false;
				if (tmpArray[10] == "1")
				{
					isThereAKey = true;
				}
				if (tmpArray.length == 12)
				{
					if (tmpArray[11] == "1")
					{
						isBossWave = true;
					}
				}
				tmpAddedWave.Init(tmpArray[0], int(tmpArray[1]), int(tmpArray[2]), int(tmpArray[3]), int(tmpArray[4]), int(tmpArray[5]), int(tmpArray[6]), int(tmpArray[7]), int(tmpArray[8]), int(tmpArray[9]), isThereAKey, isBossWave);
				_wavesArray.push(tmpAddedWave);
			}
			
			var tmpCheckpointsArray:Array = signatura.shift().split(App.DELIMITER2);
			length = tmpCheckpointsArray.shift();
			
			for (i = 0; i < length; i++)
			{
				var tmpCheck:Checkpoint = new Checkpoint(new Point(tmpCheckpointsArray.shift(), tmpCheckpointsArray.shift()));
				var ptsLength:int = tmpCheckpointsArray.shift();
				var addedCheck:Checkpoint;
				
				for (var j:int = 0; j < ptsLength; j++)
				{
					addedCheck = new Checkpoint(new Point(tmpCheckpointsArray.shift(), tmpCheckpointsArray.shift()));
					tmpCheck.addCheckpoint(addedCheck);
				}
				checkpointsArray.push(tmpCheck);
				
				
			}
			
			//checkpoints ordering
			var lastCheck:Checkpoint;
			for (i = 0; i < checkpointsArray.length; i++)
			{
				tmpCheck = checkpointsArray[i];
				if (tmpCheck.nextPointArray.length == 0)
				{
					lastCheck = tmpCheck;
					checkpointsArray.splice(i, 1);
					continue;
				}
			}	
			if (lastCheck != null)
			{
				checkpointsArray.push(lastCheck);
			}
			
			//настройка ячеек
			for (i = 0; i < App.MAP_SIZE; i++)
			{
				for (j = 0; j < App.MAP_SIZE; j++)
				{
					var tmpGridArray:Array = signatura.shift().split(App.DELIMITER2);
					var cellState:int = tmpGridArray.shift();
					var cellHeight:int = tmpGridArray.shift();
					var cellAble:String = tmpGridArray.shift();
					setCellState(j, i, cellState, cellAble);
					var tmpGrid:Grid = mapMask[i][j];
					
					tmpGrid.gridHeight = cellHeight;
					if (tmpGridArray.shift() == "1")
					{
						tmpGrid.isCampOwner = true;
						addCamp(tmpGrid);
					}
					else
					{
						tmpGrid.isCampOwner = false;
					}
					var objectsLength:int = tmpGridArray.shift(); 
					
					for (var k:int = 0; k < objectsLength; k++) 
					{
						var tmpType:int = tmpGridArray.shift(); 
						var tmpX:int = tmpGridArray.shift(); 
						var tmpY:int = tmpGridArray.shift(); 
						tmpGrid.addObject(tmpX, tmpY - App.CELL_HEIGHT_DELAY, tmpType);
					}
					
				}
			}
			App.lvleditor.wavesArray = _wavesArray;
			updateAbleGrid();
			updateChecksBySignature();
			// end reading signature------------------------------------------------------------------------------
		}
		
		public function init():void 
		{
			objectsArrayOrdering();
			addEventListener(MouseEvent.CLICK, onUpdateMouse, false, 0, true);
			addEventListener(MouseEvent.MOUSE_MOVE, onFollowMouse, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, onEraserAlphaMovie, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onEraserBackAlphaMovie, false, 0, true);
			App.lvleditor.addEventListener(InterfaceEvent.INTERFACE_EVENT, onInterfaceBtnClick, false, 0, true);
		}
		
		private function updateChecksBySignature():void 
		{
			var length:int = checkpointsArray.length;
			var tmpCheckpoint:Checkpoint;
			var tmpX:int;
			var tmpY:int;
			var tmpSprite:Sprite;
			for (var i:int = 0; i < length; i++)
			{
				tmpCheckpoint = checkpointsArray[i];
				tmpX = App.Half_W_DIV + tmpCheckpoint.currentPoint.x * App.Half_Cell_W - App.Half_Cell_W * tmpCheckpoint.currentPoint.y;
				tmpY = - App.Cell_H * 5 + App.Half_Cell_H + tmpCheckpoint.currentPoint.x * App.Half_Cell_H + App.Half_Cell_H * tmpCheckpoint.currentPoint.y;
				tmpCheckpoint.flagSprite.x = tmpX;
				tmpCheckpoint.flagSprite.y = tmpY;
				_flagsLayer.addChild(tmpCheckpoint.flagSprite);
				
				for (var j:int = 0; j < tmpCheckpoint.nextPointLinesArray.length; j++)
				{
					tmpSprite = tmpCheckpoint.nextPointLinesArray[j];
					_linesLayer.addChild(tmpSprite);
				}
			}
		}
		
		private function onInterfaceBtnClick(e:InterfaceEvent):void 
		{
			clearUniverseToItFirstLook();
			switch(e.subtype)
			{
				case InterfaceEvent.TILES_MOD:
					_objectsLayer.addChild(_followTile);
					_followTile.alpha = 0.5;
					App.currentObject = 0;
					_followTile.gotoAndStop(App.currentObject);
					_followTile.x = mouseX;
					_followTile.y = mouseY;
				break;
				case InterfaceEvent.OBJECTS_MOD:
					_objectsLayer.addChild(_followObj);
					_followObj.alpha = 0.5;
					App.currentObject = 0;
					_followObj.gotoAndStop(App.currentObject);
					_followObj.x = mouseX;
					_followObj.y = mouseY;
				break;
				case InterfaceEvent.OTHERS_MODE:
					App.currentObject = 0;
				break;
				case InterfaceEvent.ERASER_MOD:
					_selectObjToDelete = new SelectObject();
					if (contains(_gridLayer))
					{
						removeChild(_gridLayer);
					}
				break;
				case InterfaceEvent.DOWN_OBJ_MODE:
				break;
				case InterfaceEvent.UP_OBJ_MODE:
					//makeCheckpoints();
				break;
				case InterfaceEvent.ABLE_MAP_MOD:
					if (contains(_gridLayer))
					{
						removeChild(_gridLayer);
					}
					_ableGrid.visible = true;
				break;
				case InterfaceEvent.CHECKS_MODE:
					_flagSprite.alpha = 0.5;
					_gridLayer.addChild(_flagSprite);
					_flagSprite.x = mouseX;
					_flagSprite.y = mouseY;
					_flagsLayer.visible = true;
					_linesLayer.visible = true;
				break;
				case InterfaceEvent.CH_LINE_MODE:
					_flagsLayer.visible = true;
					_linesLayer.visible = true;
				break;
				case InterfaceEvent.DELETE_CHECKS:
					_flagsLayer.visible = true;
					_linesLayer.visible = true;
				break;
				case InterfaceEvent.SAVE_SIGNATURE:
				createSignatureFunc();
				break;
			}
		}
		
		private function createSignatureFunc():void 
		{
			var length:int = checkpointsArray.length;				
			var tmpArray:Array = [];
			tmpArray.push(length);
			for (var i:int = 0; i < length; i++)
			{
				var tmpCheckpoint:Checkpoint = checkpointsArray[i];
				tmpArray.push(tmpCheckpoint.currentPoint.x);				// 2 первых элемента начальной точки
				tmpArray.push(tmpCheckpoint.currentPoint.y);
				tmpArray.push(tmpCheckpoint.nextPointArray.length);			// количество точек назначения ( поинтов )
				var nextPtLength:int = tmpCheckpoint.nextPointArray.length;
				for (var j:int = 0; j < nextPtLength; j++)
				{
					var tmpNextChPt:Checkpoint = tmpCheckpoint.nextPointArray[j];
					tmpArray.push(tmpNextChPt.currentPoint.x);				// по 2 элемента точек назначения
					tmpArray.push(tmpNextChPt.currentPoint.y);
				}
			}
			var CheckpointsSignature:String = tmpArray.join("_");
			var tmpMapArray:Array = [];
			for (i = 0; i < App.MAP_SIZE; i++)
			{
				for (j = 0; j < App.MAP_SIZE; j++)
				{
					var tmpGrid:Grid = mapMask[i][j];
					var tmpGridArray:Array = [];
					tmpGridArray.push(tmpGrid.cellState);
					tmpGridArray.push(tmpGrid.gridHeight);
					tmpGridArray.push(tmpGrid.ableState);
					if (tmpGrid.isCampOwner)
					{
						tmpGridArray.push(1);
					}
					else
					{
						tmpGridArray.push(0);
					}
					length = tmpGrid.objectsArray.length;
					tmpGridArray.push(tmpGrid.objectsArray.length);
					for (var k:int = 0; k < length; k++)
					{
						var tmpObject:VisualObject = tmpGrid.objectsArray[k];
						tmpGridArray.push(tmpObject.type);
						tmpGridArray.push(tmpObject.x);
						tmpGridArray.push(tmpObject.y);
					}
					var tmpGridSignature:String = tmpGridArray.join("_");
					tmpMapArray.push(tmpGridSignature);
				}
			}
			
			var waveSignsArray:Array = [];
			var wavesArray:Array = App.lvleditor.wavesArray;
			length = wavesArray.length;
			waveSignsArray.push(length);
			for (i = 0; i < length; i++)
			{
				var tmpWave:Wave = wavesArray[i];
				var tmpWaveArray:Array = [];
				var tmpWaveSign:String;
				tmpWaveArray.push(tmpWave.type);
				tmpWaveArray.push(tmpWave.numberOfType);
				tmpWaveArray.push(tmpWave.enemiesDelay);
				tmpWaveArray.push(tmpWave.enemyHP);
				tmpWaveArray.push(tmpWave.enemyArmor);
				tmpWaveArray.push(tmpWave.cost);
				tmpWaveArray.push(tmpWave.resistToBlunt);
				tmpWaveArray.push(tmpWave.resistToSword);
				tmpWaveArray.push(tmpWave.resistToPike);
				tmpWaveArray.push(tmpWave.resistToMagic);
				if (tmpWave.isKeyWave)
				{
					tmpWaveArray.push("1");
				}
				else
				{
					tmpWaveArray.push("0");
				}
				(tmpWave.isBossWave) ? tmpWaveArray.push("1") : tmpWaveArray.push("0");
				tmpWaveSign = tmpWaveArray.join("_");
				waveSignsArray.push(tmpWaveSign);
			}
			
			MapSignature = waveSignsArray.join("|") + "|" + CheckpointsSignature + "|" + tmpMapArray.join("|");
		}
		
		private function clearUniverseToItFirstLook():void 
		{
			switch(App.currentEditor)
			{
				case App.TILES_EDIT:
					if (_objectsLayer.contains(_followTile))
					{
						_objectsLayer.removeChild(_followTile);
					}
				break;
				case App.OBJ_EDIT:
					if (_objectsLayer.contains(_followObj))
					{
						_objectsLayer.removeChild(_followObj);
					}
				break;
				case App.OTHER_EDIT:
				break;
				case App.ERASER_EDIT:
					if (!contains(_gridLayer))
					{
						addChild(_gridLayer);
					}
				break;
				case App.DOWN_OBJ_EDIT:
					/*if (!contains(_gridLayer))
					{
						addChild(_gridLayer);
					}*/
				break;
				case App.UP_OBJ_EDIT:
					/*if (!contains(_gridLayer))
					{
						addChild(_gridLayer);
					}*/
				break;
				case App.ABLE_MAP_EDIT:
					_ableGrid.visible = false;
				break;
				case App.CHECKS_EDIT:
					if (_gridLayer.contains(_flagSprite))
					{
						_gridLayer.removeChild(_flagSprite);
					}
					_flagsLayer.visible = false;
					_linesLayer.visible = false;
				break;
				case App.CH_LINES_EDIT:
					_flagsLayer.visible = false;
					_linesLayer.visible = false;
					_makeCheckLineFlag = false;
					if (_currentCheck != null)
					{
						_currentCheck.flagSprite.alpha = 1;
						_currentCheck = null;
					}
				case InterfaceEvent.DELETE_CHECKS:
					_flagsLayer.visible = false;
					_linesLayer.visible = false;
				break
				default:
				break;
			}
		}
		
		private function onEraserBackAlphaMovie(e:MouseEvent):void 
		{
			if (App.currentEditor == App.ERASER_EDIT)
			{
				if (e.target is objectsMovie)
				{
					var tmpTarget:MovieClip = e.target as MovieClip;
					if (tmpTarget.contains(_selectObjToDelete))
					{
						tmpTarget.removeChild(_selectObjToDelete);
					}
					tmpTarget.alpha = 1;
				}
			}
			if (App.currentEditor == App.UP_OBJ_EDIT || App.currentEditor == App.DOWN_OBJ_EDIT)
			{
				if (e.target is standartTile)
				{
					var tmpTile:Sprite = e.target as Sprite;
					if (tmpTile.name.split("_")[0] == "tmpSprite")
					{
						var tmpGrid:Grid;
						var cellPosX:int = tmpTile.name.split("_")[1];
						var cellPosY:int = tmpTile.name.split("_")[2];
							
						tmpGrid = mapMask[cellPosY][cellPosX];
						tmpGrid.alpha = 1;
					}
				}
			}
		}
		
		private function onEraserAlphaMovie(e:MouseEvent):void 
		{
			if (App.currentEditor == App.ERASER_EDIT)
			{
				if (e.target is objectsMovie)
				{
					(e.target as MovieClip).addChild(_selectObjToDelete);
					(e.target as MovieClip).alpha = 0.5;
				}
			}
			if (App.currentEditor == App.UP_OBJ_EDIT || App.currentEditor == App.DOWN_OBJ_EDIT)
			{
				if (e.target is standartTile)
				{
					var tmpTile:Sprite = e.target as Sprite;
					if (tmpTile.name.split("_")[0] == "tmpSprite")
					{
						var tmpGrid:Grid;
						var cellPosX:int = tmpTile.name.split("_")[1];
						var cellPosY:int = tmpTile.name.split("_")[2];
							
						tmpGrid = mapMask[cellPosY][cellPosX];
						tmpGrid.alpha = 0.75;
					}
				}
			}
		}
		
		private function onFollowMouse(e:MouseEvent):void 
		{
			var tmpArray:Array = (e.target as Sprite).name.split("_");
			if (tmpArray[0] == "tmpSprite")
			{
				cellPosX = int(tmpArray[1]);
				cellPosY = int(tmpArray[2]);
			}
			if (App.currentEditor == App.TILES_EDIT || App.currentEditor == App.UP_OBJ_EDIT || App.currentEditor == App.DOWN_OBJ_EDIT)
			{
				_followTile.gotoAndStop(App.currentObject);
				_followTile.y = - App.Cell_H * 5 + App.Half_Cell_H + cellPosY * App.Half_Cell_H + App.Half_Cell_H * cellPosX;
				_followTile.x = App.Half_W_DIV + cellPosX * App.Half_Cell_W - App.Half_Cell_W * cellPosY;
			}
			else if (App.currentEditor == App.OBJ_EDIT)
			{
				var tmpGrid:Grid = mapMask[cellPosY][cellPosX];
				_followObj.gotoAndStop(App.currentObject);
				_followObj.x = mouseX;
				if (tmpGrid.cellState != App.CELL_STATE_ROAD)
				{
					_followObj.y = mouseY + App.CELL_HEIGHT_DELAY - tmpGrid.gridHeight;
				}
				else
				{
					_followObj.y = mouseY;
				}
			}
			else if (App.currentEditor == App.CHECKS_EDIT)
			{
				_flagSprite.x = mouseX;
				_flagSprite.y = mouseY;
			}
			e.updateAfterEvent();
		}
		
		private function onUpdateMouse(e:MouseEvent):void 
		{
			trace("CHO EE");
			switch(App.currentEditor)
			{
				case App.TILES_EDIT:
					var tmpArray:Array = (e.target as Sprite).name.split("_");
					if (tmpArray[0] == "tmpSprite")
					{
						cellPosX = int(tmpArray[1]);
						cellPosY = int(tmpArray[2]);
						
						setCellState(cellPosX, cellPosY, App.currentObject, "_", App.lvleditor.currentHeight);
					}
				break;
				case App.OBJ_EDIT:
					tmpArray = (e.target as Sprite).name.split("_");
					if (tmpArray[0] == "tmpSprite")
					{
						cellPosX = int(tmpArray[1]);
						cellPosY = int(tmpArray[2]);
						var tmpGrid:Grid = mapMask[cellPosY][cellPosX];
						switch(App.currentLabel)
						{
							case "camp":
							addCamp(mapMask[cellPosY +1][cellPosX + 1]);
							break;
							case "chest":
							if (!tmpGrid.isChestOwner)
							{
								tmpGrid.addObject(0, 0, App.currentObject);
								tmpGrid.isChestOwner = true;
							}
							break;
							case "wheat":
							if (!tmpGrid.isWheatOwner)
							{
								tmpGrid.addObject(0, 0, App.currentObject);
								tmpGrid.isWheatOwner = true;
							}
							else
							{
								return;
							}
							break;
							default:
							tmpGrid.addObject(mouseX - tmpGrid.x, mouseY - tmpGrid.y, App.currentObject);
							break;
						}
					}
				break;
				case App.ERASER_EDIT:
					tmpArray = (e.target as MovieClip).name.split("_");
					
					if (tmpArray[0] == "Object")
					{
						cellPosX = int(tmpArray[1]);
						cellPosY = int(tmpArray[2]);
						mapMask[cellPosY][cellPosX].removeObject(tmpArray[3]);
					}
					else if (e.target is MovieClip)
					{
						var tmpMovie:MovieClip = e.target as MovieClip
						if (tmpMovie.parent is MovieClip)
						{
							tmpMovie = tmpMovie.parent as MovieClip;
							tmpArray = tmpMovie.name.split("_");
							if (tmpArray[0] == "Object")
							{
								cellPosX = int(tmpArray[1]);
								cellPosY = int(tmpArray[2]);
								mapMask[cellPosY][cellPosX].removeObject(tmpArray[3]);
							}
						}
					}
					if (tmpArray[0] == "tileSkin")
					{
						cellPosX = int(tmpArray[1]);
						cellPosY = int(tmpArray[2]);
						tmpGrid = mapMask[cellPosY][cellPosX];
						if (tmpGrid.isWheatOwner)
						{
							tmpGrid.isWheatOwner = false;
							tmpGrid.removeObject(3);
						}
						if (tmpGrid.isCampOwner)
						{
							tmpGrid.isCampOwner = false;
							tmpGrid.removeObject(1);
						}
						if (tmpGrid.isChestOwner)
						{
							tmpGrid.isChestOwner = false;
							tmpGrid.removeObject(2);
						}
					}
					
				break;
				case App.DOWN_OBJ_EDIT:
					if (e.target is standartTile)
					{
						var tmpTile:Sprite = e.target as Sprite;
						if (tmpTile.name.split("_")[0] == "tmpSprite")
						{
							var cellPosX:int = tmpTile.name.split("_")[1];
							var cellPosY:int = tmpTile.name.split("_")[2];
							
							tmpGrid = mapMask[cellPosY][cellPosX];
							if (tmpGrid.gridHeight > 1)
							{
								tmpGrid.gridHeight -= 2;
							}
						}
					}
				break;
				case App.UP_OBJ_EDIT:
					if (e.target is standartTile)
					{
						tmpTile = e.target as Sprite;
						if (tmpTile.name.split("_")[0] == "tmpSprite")
						{
							cellPosX = tmpTile.name.split("_")[1];
							cellPosY = tmpTile.name.split("_")[2];
							
							tmpGrid = mapMask[cellPosY][cellPosX];
							if (tmpGrid.gridHeight < 39)
							{
								tmpGrid.gridHeight += 2;
							}
						}
					}
				break;
				case App.ABLE_MAP_EDIT:
					var tmpArray2:Array = (e.target as MovieClip).name.split("_");
					if (tmpArray2[0] == "ableSkin")
						{
						cellPosX = int(tmpArray2[1]);
						cellPosY = int(tmpArray2[2]);
						var tmpAbleMovie:MovieClip = _ableGrid.getChildByName("ableSkin_" + cellPosX.toString() + "_" + cellPosY.toString()) as MovieClip;
						if (getAbleCellState(cellPosX, cellPosY) == App.CELL_STATE_BUSY)
						{
							setCellState(cellPosX, cellPosY, 0, App.CELL_STATE_FREE);
							tmpAbleMovie.gotoAndStop("FREE");
						}
						else if (getAbleCellState(cellPosX, cellPosY) == App.CELL_STATE_FREE)
						{
							setCellState(cellPosX, cellPosY, 0, App.CELL_STATE_BUSY);
							tmpAbleMovie.gotoAndStop("BUSY");
						}
					}
				break;
				case App.CHECKS_EDIT:
					tmpArray = (e.target as Sprite).name.split("_");
					if (tmpArray[0] == "tmpSprite")
					{
						cellPosX = int(tmpArray[1]);
						cellPosY = int(tmpArray[2]);
						
						var tmpCheckpoint:Checkpoint = new Checkpoint(new Point(cellPosX, cellPosY));
						var tmpX:int = App.Half_W_DIV + cellPosX * App.Half_Cell_W - App.Half_Cell_W * cellPosY;
						var tmpY:int = - App.Cell_H * 5 + App.Half_Cell_H + cellPosY * App.Half_Cell_H + App.Half_Cell_H * cellPosX;
						tmpCheckpoint.flagSprite.x = tmpX;
						tmpCheckpoint.flagSprite.y = tmpY;
						_flagsLayer.addChild(tmpCheckpoint.flagSprite);
						checkpointsArray.push(tmpCheckpoint);
					}
				break;
				case App.CH_LINES_EDIT:
					tmpArray = (e.target as Sprite).name.split("_");
					if (tmpArray[0] == "tmpSprite")
					{
						cellPosX = int(tmpArray[1]);
						cellPosY = int(tmpArray[2]);
						for (var i:int = 0; i < checkpointsArray.length; i++)
						{
							tmpCheckpoint = checkpointsArray[i];
							var tmpPoint:Point = tmpCheckpoint.currentPoint;
							if (tmpPoint.x == cellPosX && tmpPoint.y == cellPosY)
							{
								if (_makeCheckLineFlag)
								{
									if (_currentCheck.addCheckpoint(tmpCheckpoint))
									{
										_linesLayer.addChild(_currentCheck.nextPointLinesArray[_currentCheck.nextPointLinesArray.length - 1]);
									}
									_currentCheck.flagSprite.alpha = 1;
									_makeCheckLineFlag = false;
									_currentCheck = null;
								}
								else
								{
									_makeCheckLineFlag = true;
									_currentCheck = tmpCheckpoint;
									tmpCheckpoint.flagSprite.alpha = 0.35;
								}
							}
						}
					}
				break;
				case App.DELETE_CHECKS:
					tmpArray = (e.target as Sprite).name.split("_");
					if (tmpArray[0] == "tmpSprite")
					{
						cellPosX = int(tmpArray[1]);
						cellPosY = int(tmpArray[2]);
						for (i = 0; i < checkpointsArray.length; i++)
						{
							tmpCheckpoint = checkpointsArray[i];
							tmpPoint = new Point();
							tmpPoint.x = tmpCheckpoint.currentPoint.x;
							tmpPoint.y = tmpCheckpoint.currentPoint.y;
							if (tmpPoint.x == cellPosX && tmpPoint.y == cellPosY)
							{
								checkpointsArray.splice(i, 1);
								for (var j:int = 0; j < tmpCheckpoint.nextPointLinesArray.length; j++)
								{
									_linesLayer.removeChild(tmpCheckpoint.nextPointLinesArray[j]);
								}
								_flagsLayer.removeChild(tmpCheckpoint.flagSprite);
								tmpCheckpoint.nextPointLinesArray.length = 0;
								tmpCheckpoint.nextPointArray.length = 0;
								
								for (var xi:int = 0; xi < checkpointsArray.length; xi++)
								{
									var tmpCheck2:Checkpoint = checkpointsArray[xi];
									for (var xy:int = 0; xy < tmpCheck2.nextPointArray.length; xy++)
									{
										if ((tmpCheck2.nextPointArray[xy].currentPoint.x == tmpCheckpoint.currentPoint.x) && (tmpCheck2.nextPointArray[xy].currentPoint.y == tmpCheckpoint.currentPoint.y))
										{
											tmpCheck2.nextPointArray.splice(xy, 1);
											_linesLayer.removeChild(tmpCheck2.nextPointLinesArray[xy]);
											tmpCheck2.nextPointLinesArray.splice(xy, 1);
											xy--;
										}
									}
								}
								
								
								return;
							}
						}
					}
				break;
				default:
				break;
			}
		}
		
		private function addCamp(grid:Grid):void 
		{
			if (!_isCampExists)
			{
				_isCampExists = true;
			}
			else
			{
				var tmpGrid:Grid;
				var foundedFlag:Boolean = false;
				for (var i:int = 0; i < App.MAP_SIZE; i++)
				{
					for (var j:int = 0; j < App.MAP_SIZE; j++)
					{
						tmpGrid = mapMask[i][j];
						if (tmpGrid.isCampOwner)
						{
							tmpGrid.isCampOwner = false;
							tmpGrid.removeChild(_campMovie);
							foundedFlag = true;
							break;
						}
					}
					if (foundedFlag)
					{
						break;
					}
				}
			}
			grid.addChild(_campMovie);
			grid.isCampOwner = true;
			_campMovie.x = 0;
			_campMovie.y = -App.Cell_H + App.CELL_HEIGHT_DELAY - grid.gridHeight;
		}
		
		private function objectsArrayOrdering():void
		{
			var length:int = numChildren;
			for ( var j:int = 0; j < length; j++)
			{
				for (var i:int = 0; i < length - 1; i++)
				{
					if (getChildAt(i).y > getChildAt(i + 1).y)
					{
						addChildAt(getChildAt(i + 1), i);
					}
				}
			}
		}
		
		private function clearMapMask():void
		{	
			var tmpSprite3:Sprite = new roadTileSprite();
			roadFieldSprite.addChild(tmpSprite3);
			for (var i:int = 0; i < App.MAP_SIZE; i++)
			{
				for (var j:int = 0; j < App.MAP_SIZE; j++)
				{
					var tmpSprite:Sprite = new standartTile();
					//var tmpSprite2:Sprite = new roadTileMovie();
					var tmpX:int = App.Half_W_DIV + j * App.Half_Cell_W - App.Half_Cell_W * i;
					var tmpY:int = - App.Cell_H * 5 + App.Half_Cell_H + i * App.Half_Cell_H + App.Half_Cell_H * j;
					tmpSprite.x = tmpX;
					//tmpSprite2.x = tmpX;
					tmpSprite.y = tmpY;
					//tmpSprite2.y = tmpY;
					tmpSprite.alpha = 0;
					_gridLayer.addChild(tmpSprite);
					//roadFieldSprite.addChild(tmpSprite2);
					tmpSprite.name = "tmpSprite_" + j.toString() + "_" + i.toString();
				}
			}
			
			roadFieldSprite.x = 0;
			roadFieldSprite.y = 0;
			
			mapMask = [];
			var tmpGrid:Grid;
			for (var y:int = 0; y < App.MAP_SIZE; y++)
			{
				mapMask[y] = [];
				for (var x:int = 0; x < App.MAP_SIZE; x++)
				{
					tmpGrid = new Grid(x, y);
					_objectsLayer.addChild(tmpGrid);
					mapMask[y][x] = tmpGrid;
				}
			}
			
			for (y = 0; y < App.MAP_SIZE; y++)
			{
				for (x = 0; x < App.MAP_SIZE; x++)
				{
					var _ableSkin:MovieClip = new MarkersMovie();
					_ableSkin.x = App.Half_W_DIV + x * App.Half_Cell_W - App.Half_Cell_W * y;
					_ableSkin.y = - App.Cell_H * 5 + App.Half_Cell_H + y * App.Half_Cell_H + App.Half_Cell_H * x;
					_ableSkin.name = "ableSkin_" + x.toString() + "_" + y.toString();
					_ableSkin.gotoAndStop("BUSY");
					_ableGrid.addChild(_ableSkin);
				}
			}
		}
		
		private function updateAbleGrid():void
		{
			for (var y:int = 0; y < App.MAP_SIZE; y++)
			{
				for (var x:int = 0; x < App.MAP_SIZE; x++)
				{
					var tmpGrid:Grid = mapMask[y][x];
					var _ableSkin:MovieClip = _ableGrid.getChildByName("ableSkin_" + x.toString() + "_" + y.toString()) as MovieClip;
					if (_ableSkin != null)
					{
						_ableSkin.gotoAndStop(tmpGrid.ableState);
					}
				}
			}
		}
		
		public function setCellState(x:int, y:int, state:int = 0, ableState:String = "_", height:int = -1):void
		{
			if ((y < App.MAP_SIZE) && (x < App.MAP_SIZE) && (y >= 0) && (x >= 0))
			{
				var tmpGrid:Grid = mapMask[y][x];
				if (state != 0)
				{
					tmpGrid.cellState = state;
				}
				if (ableState != "_")
				{
					tmpGrid.ableState = ableState;
				}
				if (height != -1)
				{
					tmpGrid.gridHeight = height;
				}
			}
			else
			{
				return;
			}
		}
		
		public function getCellState(x:int, y:int):int
		{
			if ((x < App.MAP_SIZE) && (y < App.MAP_SIZE) && (x >= 0) && (y >= 0))
			{
				return mapMask[y][x].cellState;
			}
			else 
			{
				return 0;
			}
		}
	
		public function getAbleCellState(x:int, y:int):String
		{
			if ((x < App.MAP_SIZE) && (y < App.MAP_SIZE) && (x >= 0) && (y >= 0))
			{
				return mapMask[y][x].ableState;
			}
			else 
			{
				return "_";
			}
		}
			
		public function makeCheckpoints():void
		{
			var currentPoint:Point = findFirstCheck();
			if (currentPoint != null)
			{
				checkpointsArray.push(new Point(0, 0));
				checkpointsArray.push(currentPoint);
				findNextCell(currentPoint);
				/*for (var i:int = 0; i < checkpointsArray.length; i++)
				{
					trace(checkpointsArray[i]);
				}*/
				checkpointsArrayOrdering();
				/*for (i = 0; i < checkpointsArray.length; i++)
				{
					trace(checkpointsArray[i]);
				}*/
			}
		}
		
		private function checkpointsArrayOrdering():void 
		{
			checkpointsArray.shift();
			var lenght:int = checkpointsArray.length;
			for (var i:int = 0; i < lenght; i++)
			{
				var tmpPoint:Point = checkpointsArray[i];
				var tmpX:int = tmpPoint.x;
				var tmpY:int = tmpPoint.y;
				if ((i + 2) <= lenght - 1)
				{
					var tmp2ndPoint:Point = checkpointsArray[i + 1];
					var tmp2ndX:int = tmp2ndPoint.x;
					var tmp2ndY:int = tmp2ndPoint.y;
					var tmp3rdPoint:Point = checkpointsArray[i + 2];
					var tmp3rdX:int = tmp3rdPoint.x;
					var tmp3rdY:int = tmp3rdPoint.y;
					if (tmpX == tmp2ndX)
					{
						if (tmpX == tmp3rdX)
						{
							checkpointsArray.splice((i + 1), 1);
							i--;
							lenght--;
							continue;
						}
					}
					else if (tmpY == tmp2ndY)
					{
						if (tmpY == tmp3rdY)
						{
							checkpointsArray.splice((i + 1), 1);
							i--;
							lenght--;
							continue;
						}
					}
					
				}
				else return;
			}
		}
		
		public function Destroy():void
		{
			checkpointsArray.length = 0;
			/*for (var c:int = 0; c < _gridLayer.numChildren; c++)
			{
				if (_gridLayer.getChildAt(c) is FlagSprite)
				{
					_gridLayer.removeChildAt(c);
					c--;
				}
			}*/
			while (_flagsLayer.numChildren > 0)
			{
				_flagsLayer.removeChildAt(0);
			}
			while (_linesLayer.numChildren > 0)
			{
				_linesLayer.removeChildAt(0);
			}
			for (var i:int = 0; i < App.MAP_SIZE; i++)
			{
				for (var j:int = 0; j < App.MAP_SIZE; j++)
				{
					var cellState:int = App.CELL_STATE_GRASS;
					var cellHeight:int = 0;
					var cellAble:String = App.CELL_STATE_BUSY;
					setCellState(j, i, cellState, cellAble);
					
					var tmpGrid:Grid = mapMask[i][j];
					tmpGrid.alpha = 1;
					tmpGrid.gridHeight = cellHeight;
					tmpGrid.isWheatOwner = false;
					tmpGrid.isChestOwner = false;
					if (tmpGrid.isCampOwner)
					{
						tmpGrid.isCampOwner = false;
						_isCampExists = false;
					}
					for (var k:int = 0; k < tmpGrid.objectsArray.length; k++) 
					{
						var tmpObject:VisualObject = tmpGrid.objectsArray[k];
						tmpGrid.removeObject(tmpObject.type);
						k--;
					}
					while (tmpGrid.numChildren > 1)
					{
						tmpGrid.removeChildAt(1);
					}
				}
			}
			trace(App.lvleditor.wavesArray.length);
			App.lvleditor.wavesArray.length = 0;
			App.lvleditor.updateTextFields();
			App.lvleditor.updateWaveSelect();
			trace(App.lvleditor.wavesArray.length);
			updateAbleGrid();
			updateChecksBySignature();
			// end reading signature------------------------------------------------------------------------------
		}
		
		private function findNextCell(currentPoint:Point):void 
		{
			var _x:int = currentPoint.x;
			var _y:int = currentPoint.y;
			var tmpLastArrayPoint:Point = checkpointsArray[checkpointsArray.length - 2];
			if (_destination == 0)
			{
				//влево вниз
				var tmpPoint:Point = new Point(_x, _y + 1);
				var submitX:Boolean = (tmpPoint.x != tmpLastArrayPoint.x);
				var submitY:Boolean = (tmpPoint.y != tmpLastArrayPoint.y);
				var submitPoint:Boolean = (submitX || submitY);
				if (getCellState(_x, _y + 1) == App.CELL_STATE_ROAD && submitPoint)
				{
					_destination = 1;
					checkpointsArray.push(tmpPoint);
					findNextCell(tmpPoint);
					return;
				}
				//вправо вниз
				tmpPoint.x = _x + 1;
				tmpPoint.y = _y;
				submitX = (tmpPoint.x != tmpLastArrayPoint.x);
				submitY = (tmpPoint.y != tmpLastArrayPoint.y);
				submitPoint = (submitX || submitY);
				if (getCellState(_x + 1, _y) == App.CELL_STATE_ROAD && submitPoint)
				{
					_destination = 2;
					checkpointsArray.push(tmpPoint);
					findNextCell(tmpPoint);
					return;
				}
				//влево вверх
				tmpPoint.x = _x - 1;
				tmpPoint.y = _y;
				submitX = (tmpPoint.x != tmpLastArrayPoint.x);
				submitY = (tmpPoint.y != tmpLastArrayPoint.y);
				submitPoint = (submitX || submitY);
				if (getCellState(_x - 1, _y) == App.CELL_STATE_ROAD && submitPoint)
				{
					_destination = 3;
					checkpointsArray.push(tmpPoint);
					findNextCell(tmpPoint);
					return;
				}
				//вправо вверх
				tmpPoint.x = _x;
				tmpPoint.y = _y - 1;
				submitX = (tmpPoint.x != tmpLastArrayPoint.x);
				submitY = (tmpPoint.y != tmpLastArrayPoint.y);
				submitPoint = (submitX || submitY);
				if (getCellState(_x, _y - 1) == App.CELL_STATE_ROAD && submitPoint)
				{
					_destination = 4;
					checkpointsArray.push(tmpPoint);
					findNextCell(tmpPoint);
					return;
				}
				else 
				{
					return;
				}
			}
			//уже влево вниз!
			else if (_destination == 1)
			{
				tmpPoint = new Point(_x, _y + 1);
				if (getCellState(_x, _y + 1) == App.CELL_STATE_ROAD)
				{
					checkpointsArray.push(tmpPoint);
					findNextCell(tmpPoint);
				}
				else
				{
					_destination = 0;
					findNextCell(currentPoint);
				}
			}
			//уже вправо вниз!
			else if (_destination == 2)
			{
				tmpPoint = new Point(_x + 1, _y);
				if (getCellState(_x + 1, _y) == App.CELL_STATE_ROAD)
				{
					checkpointsArray.push(tmpPoint);
					findNextCell(tmpPoint);
				}
				else
				{
					_destination = 0;
					findNextCell(currentPoint);
				}
			}
			//уже влево вверх!
			else if (_destination == 3)
			{
				tmpPoint = new Point(_x - 1, _y);
				if (getCellState(_x - 1, _y) == App.CELL_STATE_ROAD)
				{
					checkpointsArray.push(tmpPoint);
					findNextCell(tmpPoint);
				}
				else
				{
					_destination = 0;
					findNextCell(currentPoint);
				}
			}
			//уже вправо вверх!
			else if (_destination == 4)
			{
				tmpPoint = new Point(_x, _y - 1);
				if (getCellState(_x, _y - 1) == App.CELL_STATE_ROAD)
				{
					checkpointsArray.push(tmpPoint);
					findNextCell(tmpPoint);
				}
				else
				{
					_destination = 0;
					findNextCell(currentPoint);
				}
			}
		}
		
		public function findFirstCheck():Point
		{
			//TO DO запихать границы в константы!
			var j:int = 8;
			for (var i:int = 0; i <= 8; i++, j--)
			{
				if(getCellState(i, j) == App.CELL_STATE_ROAD)
				return (new Point(i, j));
			}
			j = 12;
			for (i = 0; i <= 11; i++, j++)
			{
				if(getCellState(i, j) == App.CELL_STATE_ROAD)
				return (new Point(i, j));
			}
			j = 16;
			for (i = 23; i >= 16; i--, j++)
			{
				if(getCellState(i, j) == App.CELL_STATE_ROAD)
				return (new Point(i, j));
			}
			j = 0;
			for (i = 12; i <= 23; i++, j++)
			{
				if(getCellState(i, j) == App.CELL_STATE_ROAD)
				return (new Point(i, j));
			}
			return null;
		}
	}

}