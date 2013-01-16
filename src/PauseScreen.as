package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	public class PauseScreen extends Entity
	{
		
		[Embed(source="../assets/gfx/pause.png")] private const sprPause:Class;
		public var imgPause:Image = new Image(sprPause);
		
		public function PauseScreen() 
		{
			
			graphic = imgPause;
			graphic.scrollX = graphic.scrollY = 0;
			x = 0;
			y = 0;
				
		}
		
	}

}