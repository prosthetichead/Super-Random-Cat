package  
{

	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import flash.utils.ByteArray;
	
	
	public class TitleScreen extends World
	{
		[Embed(source="../assets/levels/titleScreen.oel", mimeType="application/octet-stream")] public var lvlTitleScreen:Class;
		[Embed(source = "../assets/gfx/title.png")] private const imgTile:Class;
		[Embed(source="../assets/gfx/ph2kGames.png")] private const imgPH2KGames:Class; 
		private var sprTitle:Image = new Image(imgTile);
		private var entTile:Entity = new Entity(0, 0, sprTitle);
		private var sprPH2KGames:Image = new Image(imgPH2KGames);
		private var entPH2KGames:Entity = new Entity(0, 0, sprPH2KGames);
		
		private var tiles:Tiles = new Tiles(2560, 2560, 99);
		private var tilesForeground:Tiles = new Tiles(2560, 2560, 98);
		private var collisionGrid:CollisionGrid = new CollisionGrid(2560, 2560, 8, 8);
		public static var levelHeight:Number = 2560;
		public static var levelWidth:Number = 2560;
		
		public function TitleScreen() 
		{
			entTile.x = FP.halfWidth - 74;
			entPH2KGames.x = FP.halfWidth - 35;
			entTile.y = 280;
			entPH2KGames.y = 100
			add(entPH2KGames);
			add(entTile);
			LoadLevel();
			camera.y = camera.x = 0
			
		}
		
		override public function update():void 
		{
			super.update();
			
			FP.clampInRect(camera, 0, 0,  levelWidth - FP.width,  levelHeight - FP.height);
			camera.y += 1;
		}
		
		
		public function LoadLevel():void 
		{	
			//get the xml file of the level
			var o:XML;
			var file:ByteArray = new lvlTitleScreen;
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
				//add(player = new Player(o.@x, o.@y));
			}
			for each (o in levelXML.entities[0].blueBizDog)
			{
				add(new BlueBizDog(o.@x, o.@y));
			}
			for each (o in levelXML.entities[0].redBizDog)
			{
				add(new RedBizDog(o.@x, o.@y));
			}
			
			
			
		}
	}

}