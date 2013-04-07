package menus 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author author
	 */
	public class MainInterface extends Sprite
	{
		private var _mainMenuGrp:MovieClip = new MainMenu();
		
		
		public function MainInterface() 
		{
			Init();
		}
		
		public function Init():void
		{
			addChild(_mainMenuGrp);
			_mainMenuGrp.gotoAndStop("main_menu");
			if (App.soundStatus)
			{
				_mainMenuGrp.volumeBtn.gotoAndStop("on");
			}
			else
			{
				_mainMenuGrp.volumeBtn.gotoAndStop("off");
			}
			if (App.musicStatus)
			{
				_mainMenuGrp.musicBtn.gotoAndStop("on");
			}
			else
			{
				_mainMenuGrp.musicBtn.gotoAndStop("off");
			}
			
			_mainMenuGrp.musicBtn.addEventListener(MouseEvent.CLICK, onChangeMusicStatus, false, 0, true);
			_mainMenuGrp.volumeBtn.addEventListener(MouseEvent.CLICK, onChangeSoundStatus, false, 0, true);
			_mainMenuGrp.playBtn.addEventListener(MouseEvent.CLICK, onSelectLevelMenu, false, 0, true);
		}
		
		private function onSelectLevelMenu(e:MouseEvent):void 
		{
			_mainMenuGrp.playBtn.removeEventListener(MouseEvent.CLICK, onSelectLevelMenu, false);
			_mainMenuGrp.gotoAndStop("select_level");
			_mainMenuGrp.mainMenuBtn.addEventListener(MouseEvent.CLICK, onReturnToMainMenu, false, 0, true)
		}
		
		private function onReturnToMainMenu(e:MouseEvent):void 
		{
			_mainMenuGrp.mainMenuBtn.removeEventListener(MouseEvent.CLICK, onReturnToMainMenu, false)
			_mainMenuGrp.gotoAndStop("main_menu");
			_mainMenuGrp.playBtn.addEventListener(MouseEvent.CLICK, onSelectLevelMenu, false, 0, true);
		}
		
		private function onChangeSoundStatus(e:MouseEvent):void 
		{
			App.soundStatus = !App.soundStatus;
			if (App.soundStatus)
			{
				_mainMenuGrp.volumeBtn.gotoAndStop("on");
			}
			else
			{
				_mainMenuGrp.volumeBtn.gotoAndStop("off");
			}
		}
		
		private function onChangeMusicStatus(e:MouseEvent):void 
		{
			App.musicStatus = !App.musicStatus;
			if (App.musicStatus)
			{
				_mainMenuGrp.musicBtn.gotoAndStop("on");
			}
			else
			{
				_mainMenuGrp.musicBtn.gotoAndStop("off");
			}
		}
	}
}