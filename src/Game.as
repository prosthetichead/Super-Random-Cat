package  
{

	
	import net.flashpunk.World;
	import net.flashpunk.FP; 
	import flash.utils.ByteArray;
	import net.flashpunk.utils.Input;
	
	
	public class Game extends World
	{	
		
		[Embed(source = "../assets/levels/level1.oel", mimeType = "application/octet-stream")] public var lvlLevel1:Class;
		
		public var levels:Array = new Array(lvlLevel1);
		public var currentLevel:int = 0; //level 0  is first level
		
		private var tiles:Tiles = new Tiles(2560, 2560, 99);
		private var tilesForeground:Tiles = new Tiles(2560, 2560, 98);
		private var collisionGrid:CollisionGrid = new CollisionGrid(2560, 2560, 8, 8);
		private var player:Player;
		private var pauseScreen:PauseScreen = new PauseScreen();
		public static var pause:Boolean = false;
		public static var reset:Boolean = false;
		public static var gameOver:Boolean = false;
		public static var levelHeight:Number = 2560;
		public static var levelWidth:Number = 2560;
		public static var livesInfo:LivesInfo = new LivesInfo();
		
		public function Game() 
		{	
			pauseScreen.visible = false;
			add(pauseScreen);
			LoadLevel();
		}
		

		
		public function LoadLevel():void 
		{
			if (currentLevel != 0)
				add(livesInfo);
			
			//get the xml file of the level
			var o:XML;
			var file:ByteArray = new levels[currentLevel];
			var str:String = file.readUTFBytes( file.length );
			var levelXML:XML = new XML(str);
			
			levelHeight = levelXML.@height;
			levelWidth  = levelXML.@width;
			
			for each (o in levelXML.walls[0].rect)
			{				
				collisionGrid.addSolidRect(o.@x, o.@y, o.@w, o.@h);
			}
			for each (o in levelXML.entities[0].platform)
			{				
				add(new Platform(o.@x, o.@y));
			}
			for each (o in levelXML.entities[0].catFood)
			{
				add(new CatFood(o.@x, o.@y));
			}
			for each (o in levelXML.tiles[0].tile)
			{				
				tiles.AddTile(o.@x, o.@y, o.@id);
			}
			for each (o in levelXML.foregroundTiles[0].tile)
			{				
				tilesForeground.AddTile(o.@x, o.@y, o.@id);
			}
			add(tiles);
			add(tilesForeground);
			add(collisionGrid);
			for each (o in levelXML.entities[0].signPost)
			{
				add(new SignPost(o.@x, o.@y, o.@signInfo));
			}
			for each (o in levelXML.entities[0].playerStart)
			{				
				add(player = new Player(o.@x, o.@y));
			}
			for each (o in levelXML.entities[0].blueBizDog)
			{
				add(new BlueBizDog(o.@x, o.@y));
			}
			
			
			
		}

		override public function update():void
		{
			if (!pause)
			{
				pauseScreen.visible = false;
				super.update(); 
			}
			else
			{
				pauseScreen.visible = true;
			}
			
			camera.x += Math.round(((player.x - FP.width / 4) - FP.camera.x) / 10);
			camera.y += Math.round(((player.y - FP.height / 4) - FP.camera.y) / 10);
			
			FP.clampInRect(camera, 0, 0,  levelWidth - FP.width,  levelHeight - FP.height);
			
			if (Input.pressed("pause"))
				Game.pause = !Game.pause;
			if (reset)
				resetLevel();
			if (gameOver)
				lose();
		}
		
		public function resetLevel():void
		{
			reset = false;
			removeAll()
			LoadLevel();
		}
		
		public function lose():void
		{
			gameOver = false;
			removeAll();
		}
	}
}