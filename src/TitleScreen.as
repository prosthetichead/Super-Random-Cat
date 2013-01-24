package  
{

	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
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
		
		private var textNewGame:Text;
		private var textCredits:Text;
		private var textShadowNewGame:Text;
		private var textShadowCredits:Text;
		private var entMenu:Entity = new Entity(0, 400);  
		private var gListMenu:Graphiclist = new Graphiclist();
		
		private var menuItem:int = 1;
		private var maxMenuItems:int = 2;
		
		
		
		public function TitleScreen() 
		{
			textShadowNewGame = new Text("NEW GAME", 1, 1);
			textNewGame = new Text("NEW GAME", 0, 0);
			textShadowCredits = new Text("Credits", 1, 31);
			textCredits = new Text("Credits", 0, 30);
			textShadowCredits.color = textShadowNewGame.color = 0x000000
			textShadowNewGame.width = textShadowCredits.width = textNewGame.width = textCredits.width = 340;
			textShadowNewGame.align = textShadowCredits.align = textNewGame.align = textCredits.align = "center";
			
			gListMenu.add(textShadowNewGame);
			gListMenu.add(textShadowCredits);
			gListMenu.add(textNewGame);
			gListMenu.add(textCredits);
			
			entMenu.addGraphic(gListMenu);
			entMenu.layer = 1;
			
			entTile.x = FP.halfWidth - 74;
			entPH2KGames.x = FP.halfWidth - 35;
			entTile.y = 280;
			entPH2KGames.y = 100
			add(entPH2KGames);
			add(entTile);
			add(entMenu);
			LoadLevel();
			camera.y = camera.x = 0
			
		}
		
		override public function update():void 
		{
			super.update();
			
			if(camera.y != levelHeight - FP.height)
				camera.y += 1;
	
				if (Input.pressed(Key.DOWN))
				{
					menuItem += 1;
				}
				else if (Input.pressed(Key.UP))
				{
					menuItem -= 1;
				}
				else if (Input.pressed(Key.Z) || Input.pressed(Key.X) || Input.pressed(Key.ENTER))
				{
					if (camera.y != levelHeight - FP.height)
						camera.y = levelHeight - FP.height;
					else
					{
						if (menuItem == 1)
							FP.world = new Game;
					}
				}
						
				
				
				menuItem = FP.clamp(menuItem, 1, maxMenuItems);
				
				if (menuItem == 1)
					textNewGame.color = 0xFF0033;
				else
					textNewGame.color = 0xFFFFFF;
					
				if (menuItem == 2)
					textCredits.color = 0xFF0033;
				else
					textCredits.color = 0xFFFFFF;
					
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