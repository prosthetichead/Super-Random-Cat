package  
{
	
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;

	
	public class Platform extends Entity
	{
		[Embed(source = "../assets/gfx/platform.png")] private var imgPlatform:Class;
		
		private var sprPlatform:Image;
		
		public function Platform(x:int, y:int) 
		{
			sprPlatform = new Image(imgPlatform)
			
			graphic = sprPlatform;
			this.x = x;
			this.y = y;
			
			type = "platform";
			setHitbox(16, 1);
			
			collidable = true;
			
			layer = 100;
		}
	}

}