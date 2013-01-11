package  
{

	
	import net.flashpunk.World;
	import net.flashpunk.FP; 
	import flash.utils.ByteArray;
	
	public class Game extends World
	{	
		[Embed(source = "../assets/levels/level1.oel", mimeType = "application/octet-stream")] public var lvlLevel1:Class;
		
		private var tiles:Tiles = new Tiles(2560, 480);
		private var tilesForeground:Tiles = new Tiles(2560, 480);
		private var collisionGrid:CollisionGrid = new CollisionGrid(2560, 480, 8, 8);
		
		public function Game() 
		{
			LoadLevel( );
		}
		

		
		public function LoadLevel():void 
		{
			var o:XML;
			
			//get the xml file of the level
			var file:ByteArray = new lvlLevel1;
			var str:String = file.readUTFBytes( file.length );
			var levelXML:XML = new XML(str);
			
			//trace(levelXML);
			
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
			
			for each (o in levelXML.entities[0].playerStart)
			{				
				add(new Player(o.@x, o.@y));
			}
			for each (o in levelXML.entities[0].blueBizDog)
			{
				add(new BlueBizDog(o.@x, o.@y));
			}
			
			
		}
		override public function update():void
		{
			super.update();
			
			camera.x = FP.clamp(camera.x, 0, 2560);
			camera.y = FP.clamp(camera.y, 0, 240);
		}
		
		
	}
}