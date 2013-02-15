package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.TiledImage;
	import net.flashpunk.graphics.Tilemap;
	
	public class Tiles extends Entity
	{
		
		[Embed(source="../assets/gfx/TileKit.png")] private var imgTileKit:Class;
		 
		private var tiles:Tilemap;
		
		public function Tiles(width:int, height:int, layer:int, scroll:Number = 1) 
		{
			tiles = new Tilemap(imgTileKit, width, height, 32, 32);
			//tiles.setRect(0, 0, 640, 680, 3);
			
			graphic = tiles;
			collidable = false;
			graphic.scrollX = scroll;
			//graphic.scrollY = scroll;
			
			
			this.layer = layer;
		}
		
		public function AddTile(colx:int, coly:int, id:int):void 
		{
			tiles.setTile(colx, coly, id);
		}
	}

}