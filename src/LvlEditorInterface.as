package  
{
	import events.InterfaceEvent;
	import fl.controls.BaseButton;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.List;
	import fl.controls.NumericStepper;
	import fl.controls.TextInput;
	import fl.events.ComponentEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import menus.ObjectsPanelUnit;
	import fl.controls.ComboBox;
	/**
	 * ...
	 * @author author
	 */
	public class LvlEditorInterface extends Sprite
	{
		private var menushka:MovieClip = new mapEditorBackGrd();
		private var _tilesPanels:Array = [];
		private var _objectsPanels:Array = [];
		private var _othersPanels:Array = [];
		public static const NUM_OBJECTS_WIDTH:int = 5;
		public static const NUM_OBJECTS_HEIGHT:int = 8;
		public static const NUM_OBJECTS:int = NUM_OBJECTS_WIDTH * NUM_OBJECTS_HEIGHT;
		private var _saveGameFlag:Boolean = false;
		private var _loadGameFlag:Boolean = false;
		private var saveGameField:TextInput = new TextInput();
		private var saveGameStyle:TextFormat = new TextFormat();
		private var _tmpWaveMenu:MovieClip = new wavesEditInterface();
		private var _tmpHeightMenu:Sprite = new heightSwitcher();
		private var _heightComboBox:NumericStepper;
		private var _numberOfWaves:TextInput;
		private var _makeWaves:Button;
		private var _currentWave:NumericStepper;
		private var _numberOfType:TextInput;
		private var _enemyDelay:TextInput;
		private var _enemyType:List;
		private var _enemyHP:TextInput;
		private var _enemyArmor:TextInput;
		private var _enemyCost:TextInput;
		private var _resistBlunt:TextInput;
		private var _resistSword:TextInput;
		private var _resistPike:TextInput;
		private var _resistMagic:TextInput;
		private var _isThereAKey:CheckBox;
		private var _isThereABoss:CheckBox;
		private var _wavesArray:Array = [];
		private var loadMenu:Sprite = new LoadMenu();
		private var loadFromFileBtn:Button;
		private var fileName:TextInput;
		public var currentHeight:int;
		
		private var _currentObjectsPage:int = 0;
		
		public function LvlEditorInterface() 
		{
			addChild(menushka);
			buttonsStatusUpdate();
			
			var tmpObjects:MovieClip = new TileBtnMovie();
			var length:int = tmpObjects.tileContainer.totalFrames;
			var loops:int = int(length / NUM_OBJECTS) + 1;
			var tmpPanel:Sprite;
			
			for (var i:int = 0; i < loops; i++) {
				var endIndex:int = (i + 1) * NUM_OBJECTS;
				if ((length - i * NUM_OBJECTS) < endIndex) {
					endIndex = length;
				}
				tmpPanel = new ObjectsPanelUnit(tmpObjects, i * NUM_OBJECTS, endIndex);
				menushka.objectsPanelAll.addChild(tmpPanel);
				tmpPanel.visible = false;
				_tilesPanels[i] = tmpPanel;
			}
			
			tmpObjects = new ObjBtnMoviecopy();
			length = tmpObjects.tileContainer.totalFrames;
			loops = int(length / NUM_OBJECTS) + 1;
			for (i = 0; i < loops; i++) {
				endIndex = (i + 1) * NUM_OBJECTS;
				if ((length - i * NUM_OBJECTS) < endIndex) {
					endIndex = length;
				}
				tmpPanel = new ObjectsPanelUnit(tmpObjects, i * NUM_OBJECTS, endIndex);
				menushka.objectsPanelAll.addChild(tmpPanel);
				tmpPanel.visible = false;
				_objectsPanels[i] = tmpPanel;
			}
			
			
			_numberOfWaves = _tmpWaveMenu.getChildByName("numberOfWaves") as TextInput;
			_numberOfWaves.text = "10";
			_numberOfWaves.addEventListener(Event.CHANGE, onChangeText, false, 0, true);
			_makeWaves = _tmpWaveMenu.getChildByName("makeWaves") as Button;
			_makeWaves.addEventListener(ComponentEvent.BUTTON_DOWN, onMakeWaves, false, 0, true);
			_makeWaves.label = "Создать волны";
			_currentWave = _tmpWaveMenu.getChildByName("waveNumber") as NumericStepper;
			_currentWave.addEventListener(Event.CHANGE, onUpdateCurrentWave, false, 0, true);
			_currentWave.minimum = 1;
			_currentWave.maximum = 1;
			_enemyType = _tmpWaveMenu.getChildByName("enemyType") as List;
			length = App.enemyTypesArray.length;
			for (i = 0; i < length; i++)
			{
				_enemyType.addItem(App.enemyTypesArray[i]);
			}
			_enemyType.addEventListener(Event.CHANGE, onSaveWave, false, 0, true);
			_numberOfType = _tmpWaveMenu.getChildByName("numberOfType") as TextInput;
			_numberOfType.addEventListener(Event.CHANGE, onChangeText, false, 0, true);
			_enemyDelay = _tmpWaveMenu.getChildByName("enemiesDelay") as TextInput;
			_enemyDelay.addEventListener(Event.CHANGE, onChangeText, false, 0, true);
			_enemyArmor = _tmpWaveMenu.getChildByName("enemyArmor") as TextInput;
			_enemyArmor.addEventListener(Event.CHANGE, onChangeText, false, 0, true);
			_enemyCost = _tmpWaveMenu.getChildByName("cost") as TextInput;
			_enemyCost.addEventListener(Event.CHANGE, onChangeText, false, 0, true);
			_enemyHP = _tmpWaveMenu.getChildByName("enemyHP") as TextInput;
			_enemyHP.addEventListener(Event.CHANGE, onChangeText, false, 0, true);
			_resistBlunt = _tmpWaveMenu.getChildByName("resistBlunt") as TextInput;
			_resistBlunt.addEventListener(Event.CHANGE, onChangeText, false, 0, true);
			_resistSword = _tmpWaveMenu.getChildByName("resistSword") as TextInput;
			_resistSword.addEventListener(Event.CHANGE, onChangeText, false, 0, true);
			_resistPike = _tmpWaveMenu.getChildByName("resistPike") as TextInput;
			_resistPike.addEventListener(Event.CHANGE, onChangeText, false, 0, true);
			_resistMagic = _tmpWaveMenu.getChildByName("resistMagic") as TextInput;
			_resistMagic.addEventListener(Event.CHANGE, onChangeText, false, 0, true);
			_isThereAKey = _tmpWaveMenu.getChildByName("keyCheckbox") as CheckBox;
			_isThereAKey.addEventListener(Event.CHANGE, onChangeKeyStatus, false, 0, true);
			_isThereAKey.label = "Волна с ключем";
			_isThereABoss = _tmpWaveMenu.getChildByName("Bossbox") as CheckBox;
			_isThereABoss.addEventListener(Event.CHANGE, onChangeBossStatus, false, 0, true);
			
			menushka.objectsPanelAll.addChild(_tmpWaveMenu);
			_tmpWaveMenu.x = 50;
			_tmpWaveMenu.y = 300;
			_tmpWaveMenu.visible = false;
			
			// SaveGame Field Initialisation
			//saveGameField.background = true;
			//saveGameField.backgroundColor = 0xaaaaaa;
			saveGameField.y = 30;
			saveGameField.x = 30;
			saveGameField.visible = false;
			//saveGameField.multiline = true;
			//saveGameField.selectable = true;
			saveGameField.width = 900;
			//saveGameField.height = 200;
			Main.saveSignatureLayer.addChild(saveGameField);
			
			/*saveGameStyle.bold = false;
			saveGameStyle.font = "Arial";
			saveGameStyle.color = 0x000000;
			saveGameStyle.size = 15;*/
			//------------------------------
			
			// мини менюшка для загрузки сигнатуры
			menushka.addChild(loadMenu);
			loadMenu.x = 500;
			loadMenu.y = 50;
			loadMenu.visible = false;
			loadFromFileBtn = loadMenu.getChildByName("loadFromFile") as Button;
			loadFromFileBtn.label = "Загрузить";
			loadFromFileBtn.addEventListener(ComponentEvent.BUTTON_DOWN, onLoadEvent, false, 0, true);
			fileName = loadMenu.getChildByName("FileName") as TextInput;
			fileName.text = "";
			
			// мини менюшка для управления высотой тайлов:
			_tmpHeightMenu.x = 700;
			_tmpHeightMenu.y = 30;
			_heightComboBox = _tmpHeightMenu.getChildByName("heightBox") as NumericStepper;
			_heightComboBox.minimum = 0;
			_heightComboBox.maximum = 50;
			_heightComboBox.value = 0;
			_heightComboBox.addEventListener(Event.CHANGE, onChangeHeight, false, 0, true);
			_tmpHeightMenu.visible = false;
			addChild(_tmpHeightMenu);
			//--------
			
			menushka.eraserMovie.addEventListener(MouseEvent.CLICK, onEraserMode, false, 0, true);
			menushka.tilesMovie.addEventListener(MouseEvent.CLICK, onTilesMode, false, 0, true);
			menushka.objectMovie.addEventListener(MouseEvent.CLICK, onObjectsMode, false, 0, true);
			menushka.othersMovie.addEventListener(MouseEvent.CLICK, onOthersMode, false, 0, true);
			menushka.eraserMovie.addEventListener(MouseEvent.CLICK, onEraserMode, false, 0, true);
			menushka.moveObjDown.addEventListener(MouseEvent.CLICK, onObjDownMode, false, 0, true);
			menushka.moveObjUp.addEventListener(MouseEvent.CLICK, onObjUpMode, false, 0, true);
			menushka.saveBtn.addEventListener(MouseEvent.CLICK, onSaveSignature, false, 0, true);
			menushka.loadBtn.addEventListener(MouseEvent.CLICK, onLoadSignature, false, 0, true);
			menushka.ablingMapMovie.addEventListener(MouseEvent.CLICK, onAblingMapMode, false, 0, true);
			menushka.checkpointsMovie.addEventListener(MouseEvent.CLICK, onCheckpointsMode, false, 0, true);
			menushka.makeChecksLine.addEventListener(MouseEvent.CLICK, onChecksLineMode, false, 0, true);
			menushka.createBtn.addEventListener(MouseEvent.CLICK, onCreateNewMap, false, 0, true);
			menushka.deleteChecks.addEventListener(MouseEvent.CLICK, onDeleteCheck, false, 0, true);
			
			menushka.fileNameSprite.visible = false;
		}
		
		private function onChangeBossStatus(e:Event):void 
		{
			onSaveWave();
		}
		
		private function onDeleteCheck(e:MouseEvent):void 
		{
			buttonsStatusUpdate();
			clearPanels();
			menushka.deleteChecks.gotoAndStop("ON");
			App.currentEditor = App.DELETE_CHECKS;
			dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.DELETE_CHECKS));
		}
		
		private function onCreateNewMap(e:MouseEvent):void 
		{
			menushka.gotoAndStop(2);
			menushka.okBtn.addEventListener(MouseEvent.CLICK, onNewMap, false, 0, true);
			menushka.cancelBtn.addEventListener(MouseEvent.CLICK, onCancelMap, false, 0, true);
		}
		
		private function onCancelMap(e:MouseEvent):void 
		{
			menushka.gotoAndStop(1);
		}
		
		private function onNewMap(e:MouseEvent):void 
		{
			menushka.gotoAndStop(1);
			App.universe.Destroy();
		}
		
		private function onChangeKeyStatus(e:Event):void 
		{
			onSaveWave();
		}
		
		private function onChangeHeight(e:Event):void 
		{
			currentHeight = int(_heightComboBox.value);
		}
		
		private function onLoadEvent(e:ComponentEvent):void 
		{
			/*if (fileName.text != "" )
			{
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
				var request:URLRequest = new URLRequest(fileName.text + ".txt");
				try	{
					loader.load(request);
				}
				catch (error:Error)
				{
					Error("UNABLE TO LOAD REQUEST");
				}
				
			}
			clearUpperPanels();
			_loadGameFlag = false;
			//////////////////////////////////////////////////////////////////*/
			if (fileName.text != "" )
			{
				App.universe.Destroy();
				App.universe.load(fileName.text);
				if (_wavesArray.length > 0)
				{
					_numberOfWaves.text = String(_wavesArray.length);
					onMakeWaves();
				}
				
				clearUpperPanels();
				_loadGameFlag = false;
			}
		}
		
		private function onCompleteHandler(e:Event):void 
		{
			/*menushka.fileNameSprite.visible = true;
			menushka.fileNameSprite.fileNameField.text = fileName.text + ".txt";
			App.universe.Destroy();
			App.universe.load((e.target as URLLoader).data);
			if (_wavesArray.length > 0)
			{
				_numberOfWaves.text = String(_wavesArray.length);
				onMakeWaves();
			}*/
		}
		
		private function onLoadSignature(e:MouseEvent):void 
		{
			clearUpperPanels();
			_saveGameFlag = false;
			if (!_loadGameFlag)
			{
				_loadGameFlag = !_loadGameFlag;
				loadMenu.visible = true;
			}
			else
			{
				_loadGameFlag = !_loadGameFlag;
				loadMenu.visible = false;
			}
		}
		
		public function onUpdateCurrentWave(e:Event = null):void 
		{
			var tmpCurWave:Wave;
			var tmpScndCar:int = int(_currentWave.value);
			if (tmpScndCar < _wavesArray.length)
			{
				tmpCurWave = _wavesArray[tmpScndCar];
			}
			else
			{
				return;
			}
			
			var length:int = App.enemyTypesArray.length;
			for (var i:int = 0; i < length; i++)
			{
				var tmpObject:Object = App.enemyTypesArray[i];
				if (tmpObject.label == tmpCurWave.type)
				{
					_enemyType.selectedIndex = i;
					break;
				}
			}
			
			_enemyDelay.text = String(tmpCurWave.enemiesDelay);
			_numberOfType.text = String(tmpCurWave.numberOfType);
			_enemyHP.text = String(tmpCurWave.enemyHP);
			_enemyCost.text = String(tmpCurWave.cost);
			_enemyArmor.text = String(tmpCurWave.enemyArmor);
			_resistBlunt.text = String(tmpCurWave.resistToBlunt);
			_resistSword.text = String(tmpCurWave.resistToSword);
			_resistPike.text = String(tmpCurWave.resistToPike);
			_resistMagic.text = String(tmpCurWave.resistToMagic);
			_isThereAKey.selected = tmpCurWave.isKeyWave;
			_isThereABoss.selected = tmpCurWave.isBossWave;
			
		}
		
		private function onSaveWave(e:Event = null):void 
		{
			var tmpCurWave:Wave;
			var tmpScndCar:int = int(_currentWave.value - 1);
			if (tmpScndCar < _wavesArray.length)
			{
				tmpCurWave = _wavesArray[tmpScndCar];
			}
			else
			{
				return;
			}
			
			tmpCurWave.type = _enemyType.selectedItem.label;
			
			tmpCurWave.enemiesDelay = int(_enemyDelay.text);
			tmpCurWave.numberOfType = int(_numberOfType.text);
			
			tmpCurWave.enemyHP = int(_enemyHP.text);
			tmpCurWave.enemyArmor = int(_enemyArmor.text);
			tmpCurWave.cost = int(_enemyCost.text);
			
			tmpCurWave.resistToBlunt = int(_resistBlunt.text);
			tmpCurWave.resistToSword = int(_resistSword.text);
			tmpCurWave.resistToPike = int(_resistPike.text);
			tmpCurWave.resistToMagic = int(_resistMagic.text);
			
			tmpCurWave.isKeyWave = _isThereAKey.selected;
			tmpCurWave.isBossWave = _isThereABoss.selected;
			
			trace(tmpCurWave.isBossWave);
		}
		
		private function onChangeText(e:Event):void 
		{
			var txtInput:TextInput = (e.target as TextInput);
			var regExp:RegExp = /\d+/;
			if (txtInput.text != "")
			{
				txtInput.text = regExp.exec(txtInput.text);
			}
			onSaveWave();
		}
		
		private function onMakeWaves(e:ComponentEvent = null):void 
		{
			if (_numberOfWaves.text != "")
			{
				var tmpInt:int = int(_numberOfWaves.text);
				if (tmpInt > 100)
				{
					return;
				}
				
				if (_wavesArray.length != 0)
				{
					if (_wavesArray.length > tmpInt)
					{
						_wavesArray.length = tmpInt;
						updateWaveSelect();
						return;
					}
					else if (_wavesArray.length < tmpInt)
					{
						var addedWaves:int = tmpInt - _wavesArray.length;
						for (i = 0; i < addedWaves; i++)
						{
							_wavesArray.push(new Wave());
						}
						updateWaveSelect();
						return;
					}
					else
					{
						updateWaveSelect();
						return;
					}
				}
				
				for (var i:int = 0; i < tmpInt; i++)
				{
					_wavesArray.push(new Wave());
				}
				updateWaveSelect();
			}
		}
		
		public function updateWaveSelect():void 
		{
			_currentWave.minimum = 1;
			_currentWave.maximum = _wavesArray.length;
			onUpdateCurrentWave();
		}
		
		private function onChecksLineMode(e:MouseEvent):void 
		{
			buttonsStatusUpdate();
			clearPanels();
			menushka.makeChecksLine.gotoAndStop("ON");
			dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.CH_LINE_MODE));
			App.currentEditor = App.CH_LINES_EDIT;
		}
		
		private function onCheckpointsMode(e:MouseEvent):void 
		{
			buttonsStatusUpdate();
			clearPanels();
			menushka.checkpointsMovie.gotoAndStop("ON");
			dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.CHECKS_MODE));
			App.currentEditor = App.CHECKS_EDIT;
		}
		
		private function onAblingMapMode(e:MouseEvent):void 
		{
			buttonsStatusUpdate();
			clearPanels();
			menushka.ablingMapMovie.gotoAndStop("ON");
			dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.ABLE_MAP_MOD));
			App.currentEditor = App.ABLE_MAP_EDIT;
		}
		
		private function onSaveSignature(e:MouseEvent):void 
		{
			clearUpperPanels();
			_loadGameFlag = false;
			if (!_saveGameFlag)
			{
				dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.SAVE_SIGNATURE));
				_saveGameFlag = !_saveGameFlag;
				//saveGameField.setTextFormat(saveGameStyle);
				saveGameField.visible = true;
				/*var tmpString:String = Universe.MapSignature;
				var endString:String = "";
				var firstIndex:int = 0;
				for (var i:int = 0; i < tmpString.length; i++)
				{
					if (i % 130 == 0 && i != 0)
					{
						endString += tmpString.slice(firstIndex, i);
						endString += "\n";
						firstIndex = i;
					}
				}
				saveGameField.text = endString;*/
				saveGameField.text = Universe.MapSignature;
			}
			else
			{
				_saveGameFlag = !_saveGameFlag;
				//endString = "";
				saveGameField.visible = false;
			}
		}
		
		private function onObjUpMode(e:MouseEvent):void 
		{
			buttonsStatusUpdate();
			clearPanels();
			menushka.moveObjUp.gotoAndStop("ON");
			dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.UP_OBJ_MODE));
			App.currentEditor = App.UP_OBJ_EDIT;
		}
		
		private function onObjDownMode(e:MouseEvent):void 
		{
			buttonsStatusUpdate();
			clearPanels();
			menushka.moveObjDown.gotoAndStop("ON");
			dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.DOWN_OBJ_MODE));
			App.currentEditor = App.DOWN_OBJ_EDIT;
		}
		
		private function onOthersMode(e:MouseEvent):void 
		{
			buttonsStatusUpdate();
			clearPanels();
			menushka.othersMovie.gotoAndStop("ON");
			dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.OTHERS_MODE));
			App.currentEditor = App.OTHER_EDIT;
			_tmpWaveMenu.visible = true;
			if (_objectsPanels.length > 1)
			{
				menushka.nextBtnMovie.removeEventListener(MouseEvent.CLICK, onNextMenu, false);
				menushka.prevBtnMovie.removeEventListener(MouseEvent.CLICK, onPreviusMenu, false);
			}
		}
		
		private function onObjectsMode(e:MouseEvent):void 
		{
			buttonsStatusUpdate();
			clearPanels();
			menushka.objectMovie.gotoAndStop("ON");
			dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.OBJECTS_MOD));
			App.currentEditor = App.OBJ_EDIT;
			_objectsPanels[_currentObjectsPage].visible = true;
			if (_objectsPanels.length > 1)
			{
				menushka.nextBtnMovie.addEventListener(MouseEvent.CLICK, onNextMenu, false, 0, true);
				menushka.prevBtnMovie.addEventListener(MouseEvent.CLICK, onPreviusMenu, false, 0, true);
			}
		}
		
		private function onNextMenu(e:MouseEvent):void 
		{
			_objectsPanels[_currentObjectsPage].visible = false;
			if (_currentObjectsPage == _objectsPanels.length - 1)
			{
				_currentObjectsPage = 0;
			}
			else 
			{
				_currentObjectsPage += 1;
			}
			_objectsPanels[_currentObjectsPage].visible = true;
		}
		
		private function onPreviusMenu(e:MouseEvent):void 
		{
			_objectsPanels[_currentObjectsPage].visible = false;
			if (_currentObjectsPage == 0)
			{
				_currentObjectsPage = _objectsPanels.length - 1;
			}
			else 
			{
				_currentObjectsPage -= 1;
			}
			_objectsPanels[_currentObjectsPage].visible = true;
		}
		
		private function onTilesMode(e:MouseEvent):void 
		{
			buttonsStatusUpdate();
			clearPanels();
			menushka.tilesMovie.gotoAndStop("ON");
			dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.TILES_MOD));
			App.currentEditor = App.TILES_EDIT;
			_tmpHeightMenu.visible = true;
			_tilesPanels[0].visible = true;
			if (_objectsPanels.length > 1)
			{
				menushka.nextBtnMovie.removeEventListener(MouseEvent.CLICK, onNextMenu, false);
				menushka.prevBtnMovie.removeEventListener(MouseEvent.CLICK, onPreviusMenu, false);
			}
		}
		
		private function onEraserMode(e:MouseEvent):void 
		{
			buttonsStatusUpdate();
			clearPanels();
			menushka.eraserMovie.gotoAndStop("ON");
			dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.ERASER_MOD));
			App.currentEditor = App.ERASER_EDIT;
		}
		
		public function buttonsStatusUpdate():void
		{
			menushka.eraserMovie.gotoAndStop("OFF");
			menushka.tilesMovie.gotoAndStop("OFF");
			menushka.objectMovie.gotoAndStop("OFF");
			menushka.othersMovie.gotoAndStop("OFF");
			menushka.nextBtnMovie.gotoAndStop("OFF");
			menushka.prevBtnMovie.gotoAndStop("OFF");
			menushka.moveObjDown.gotoAndStop("OFF");
			menushka.moveObjUp.gotoAndStop("OFF");
			menushka.ablingMapMovie.gotoAndStop("OFF");
			menushka.checkpointsMovie.gotoAndStop("OFF");
			menushka.makeChecksLine.gotoAndStop("OFF");
			menushka.deleteChecks.gotoAndStop("OFF");
		}
		
		public function clearPanels():void
		{
			var length:int = _objectsPanels.length;
			for (var i:int = 0; i < length; i++)
			{
				_objectsPanels[i].visible = false;
			}
			length = _tilesPanels.length;
			for (i = 0; i < length; i++)
			{
				_tilesPanels[i].visible = false;
			}
			length = _othersPanels.length;
			for (i = 0; i < length; i++)
			{
				_othersPanels[i].visible = false;
			}
			_tmpWaveMenu.visible = false;
			_tmpHeightMenu.visible = false;
			loadMenu.visible = false;
		}
		
		public function clearUpperPanels():void
		{
			saveGameField.visible = false;
			loadMenu.visible = false;
		}
		
		public function updateTextFields():void 
		{
			_numberOfWaves.text = "";
			_enemyType.selectedIndex = 0;
			_enemyDelay.text = "";
			_numberOfType.text = "";
			_enemyHP.text = "";
			_enemyCost.text = "";
			_enemyArmor.text = "";
			_resistBlunt.text = "";
			_resistSword.text = "";
			_resistPike.text = "";
			_resistMagic.text = "";
			_isThereAKey.selected = false;
		}
		
		public function get wavesArray():Array { return _wavesArray; }
		
		public function set wavesArray(value:Array):void 
		{
			_wavesArray = value;
		}
	}

}