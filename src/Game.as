package  
{

	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.FP; 
	import flash.utils.ByteArray;
	import net.flashpunk.utils.Input;
	import net.flashpunk.graphics.Graphiclist;
	
	
	public class Game extends World
	{	
		[Embed(source = "../assets/music/Pinball_Spring.mp3")]  public static var mp3Music:Class;
		[Embed(source="../assets/music/die.mp3")] public static var mp3MusicDie:Class;
		[Embed(source = "../assets/levels/level1.oel", mimeType = "application/octet-stream")] public var lvlLevel1:Class;
		[Embed(source = "../assets/levels/level2.oel", mimeType = "application/octet-stream")] public var lvlLevel2:Class;
		
		public static var music:Sfx = new Sfx(mp3Music);
		public static var musicDie:Sfx = new Sfx(mp3MusicDie);
		
		public var levels:Array = new Array(lvlLevel1, lvlLevel2);
		
		
		private var tiles:Tiles = new Tiles(2560, 2560, 99);
		private var tilesForeground:Tiles = new Tiles(2560, 2560, 98);
		
		
		private var pauseScreen:PauseScreen = new PauseScreen();
		
		public static var player:Player;
		public static var pause:Boolean = false;
		public static var reset:Boolean = false;
		public static var gameOver:Boolean = false;
		public static var levelHeight:Number = 2560;
		public static var levelWidth:Number = 2560;
		public static var currentLevel:int = 0; //level 0  is first level
		
		
		public static var infoText:InfoText = new InfoText();
		
		public function Game() 
		{	
			pauseScreen.visible = false;
			LoadLevel();
		}
		
		
		
		public function LoadLevel():void 
		{
			music.loop(.1);

			add(infoText);
			add(pauseScreen);
			
			var collisionGrid:CollisionGrid = new CollisionGrid(2560, 2560, 8, 8);
			var platformGrid:CollisionGrid = new CollisionGrid(2560, 2560, 8, 8,"PlatformGrid");
			
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
			for each (o in levelXML.platforms[0].rect)
			{				
				platformGrid.addSolidRect(o.@x, o.@y, o.@w, o.@h);
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
			add(platformGrid);
			
			for each (o in levelXML.entities[0].signPost)
			{
				add(new SignPost(o.@x, o.@y, o.@signInfo));
			}
			
			for each (o in levelXML.entities[0].playerFinish)
			{
				add(new Teleport(o.@x, o.@y));
			}
			
			for each (o in levelXML.entities[0].playerStart)
			{				
				add(player = new Player(o.@x, o.@y));
			}
			for each (o in levelXML.entities[0].blueBizDog)
			{
				add(new BlueBizDog(o.@x, o.@y));
			}
			for each (o in levelXML.entities[0].redBizDog)
			{
				add(new RedBizDog(o.@x, o.@y));
			}
			for each (o in levelXML.entities[0].bounceBlock)
			{
				add(new BounceBlock(o.@x, o.@y));
			}

			
		}

		override public function update():void
		{
			//textLives.text = "LIVES: " + livesRemaining;
			//textScore.text = "SCORE: " + currentScore;
			
			
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
			if (!player.dead)
				camera.y += Math.round(((player.y - FP.height / 4) - FP.camera.y) / 10);
			
				
			FP.clampInRect(camera, 0, 0,  levelWidth - FP.width,  levelHeight - FP.height);
			
			if (Input.pressed("pause"))
				Game.pause = !Game.pause;
			if (reset)
			{
				resetLevel();

			}
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
			infoText.lives = 3;
			infoText.score = 0;
			FP.world = new TitleScreen;
		}
	}
}