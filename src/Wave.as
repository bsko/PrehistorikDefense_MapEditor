package  
{
	/**
	 * ...
	 * @author author
	 */
	public class Wave 
	{
		public static const NAME:String = "Wave";
		
		private var _type:String;
		private var _numberOfType:int;
		private var _enemiesDelay:int;
		private var _enemyHP:int;
		private var _enemyArmor:int;
		private var _cost:int;
		private var _resistToBlunt:int;
		private var _resistToSword:int;
		private var _resistToPike:int;
		private var _resistToMagic:int;
		private var _isKeyWave:Boolean;
		private var _isBossWave:Boolean;
		
		public function Wave()
		{
			Init();
		}
		
		public function Init(type:String = "SaberTooth", numberOfType:int = 5, enemiesDelay:int = 1000, enemyHP:int = 100, enemyArmor:int = 0, cost:int = 0, resistBlunt:int = 0, resistSword:int = 0, resistPike:int = 0, resistMagic:int = 0, isKey:Boolean = false, isBossWave:Boolean = false):void
		{
			_type = type;
			_numberOfType = numberOfType;
			_enemiesDelay = enemiesDelay;
			_enemyHP = enemyHP;
			_enemyArmor = enemyArmor;
			_cost = cost;
			_resistToBlunt = resistBlunt;
			_resistToSword = resistSword;
			_resistToPike = resistPike;
			_resistToMagic = resistMagic;
			_isKeyWave = isKey;
			_isBossWave = isBossWave;
		}
		
		public function destroy():void
		{
			_type = "";
			_numberOfType = 0;
			_enemiesDelay = 0;
			_enemyHP = 0;
			_enemyArmor = 0;
			_cost = 0;
			_resistToBlunt = 0;
			_resistToSword = 0;
			_resistToPike = 0;
			_resistToMagic = 0;
		}
		
		public function get enemiesDelay():int { return _enemiesDelay; }
		
		public function get type():String { return _type; }
		
		public function get numberOfType():int { return _numberOfType; }
		
		public function get enemyHP():int { return _enemyHP; }
		
		public function get enemyArmor():int { return _enemyArmor; }
		
		public function get cost():int { return _cost; }
		
		public function get resistToBlunt():int { return _resistToBlunt; }
		
		public function get resistToSword():int { return _resistToSword; }
		
		public function get resistToPike():int { return _resistToPike; }
		
		public function get resistToMagic():int { return _resistToMagic; }
		
		public function set numberOfType(value:int):void 
		{
			_numberOfType = value;
		}
		
		public function set resistToMagic(value:int):void 
		{
			_resistToMagic = value;
		}
		
		public function set resistToPike(value:int):void 
		{
			_resistToPike = value;
		}
		
		public function set resistToSword(value:int):void 
		{
			_resistToSword = value;
		}
		
		public function set resistToBlunt(value:int):void 
		{
			_resistToBlunt = value;
		}
		
		public function set cost(value:int):void 
		{
			_cost = value;
		}
		
		public function set enemyArmor(value:int):void 
		{
			_enemyArmor = value;
		}
		
		public function set enemyHP(value:int):void 
		{
			_enemyHP = value;
		}
		
		public function set enemiesDelay(value:int):void 
		{
			_enemiesDelay = value;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		public function get isKeyWave():Boolean { return _isKeyWave; }
		
		public function set isKeyWave(value:Boolean):void 
		{
			_isKeyWave = value;
		}
		
		public function get isBossWave():Boolean { return _isBossWave; }
		
		public function set isBossWave(value:Boolean):void 
		{
			_isBossWave = value;
		}
	}

}