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
		[Embed(source = "../assets/levels/level3.oel", mimeType = "application/octet-stream")] public var lvlLevel3:Class;
		
		public static var music:Sfx = new Sfx(mp3Music);
		public static var musicDie:Sfx = new Sfx(mp3MusicDie);
		
		public var levels:Array = new Array(lvlLevel1, lvlLevel2, lvlLevel3);
		
		
		
		
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
			var platformGrid:CollisionGrid = new CollisionGrid(2560, 2560, 8, 8, "PlatformGrid");
			var parallax1:Tiles = new Tiles(2560, 2560, 102, .05);
			var parallax2:Tiles = new Tiles(2560, 2560, 101, .2);
			var parallax3:Tiles = new Tiles(2560, 2560, 100,.5);
			var tiles:Tiles = new Tiles(2560, 2560, 99);
			var tilesForeground:Tiles = new Tiles(2560, 2560, 98);
			
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
			for each (o in levelXML.entities[0].OneUp)
			{
				add(new OneUPCatFood(o.@x, o.@y));
			}
			for each (o in levelXML.parallax1[0].tile)
			{				
				parallax1.AddTile(o.@x, o.@y, o.@id);
			}
			for each (o in levelXML.parallax2[0].tile)
			{				
				parallax2.AddTile(o.@x, o.@y, o.@id);
			}
			for each (o in levelXML.parallax3[0].tile)
			{				
				parallax3.AddTile(o.@x, o.@y, o.@id);
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
			add(parallax1);
			add(parallax2);
			add(parallax3);
			
			
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
			for each (o in levelXML.entities[0].bombDog)
			{
				add(new BombDog(o.@x, o.@y));
			}
			for each (o in levelXML.entities[0].bounceBlock)
			{
				add(new BounceBlock(o.@x, o.@y));
			}
			for each (o in levelXML.entities[0].dropBlock)
			{
				add(new DropBlock(o.@x, o.@y, o.node.@x, o.node.@y));
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
			
			
			
			 // Calculate the edges of the screen.
			var marginWidth:Number = 10
			var marginLeft:Number = camera.x + FP.width/2 - marginWidth;
			var marginRight:Number = camera.x + FP.width/2 + marginWidth - player.width;

      // Calculate how far to scroll when the player is near the edges of the screen.
      var cameraMovement:Number = 0.0;
      if (player.x < marginLeft)
        cameraMovement = player.x - marginLeft;
      else if (player.x > marginRight)
        cameraMovement = player.x - marginRight;

      // Update the camera position, but prevent scrolling off the ends of the level.
      camera.x = camera.x + cameraMovement;
	  			
	  if (!player.dead)
		camera.y += Math.round(((player.y - FP.height / 4) - FP.camera.y) / 10);
		
	  FP.clampInRect(camera, 0, 0,  levelWidth - FP.width,  levelHeight - FP.height);
			
			
			
			
			
			
			
			//if (player.speed.x < 0)
				//camera.x += Math.round(((player.x - FP.width / 4) - FP.camera.x) / 10);
			//else
				//camera.x += Math.round(((player.x - FP.width / 4) - FP.camera.x) / 10);
				//
			
			//
				//
			//FP.clampInRect(camera, 0, 0,  levelWidth - FP.width,  levelHeight - FP.height);
			
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