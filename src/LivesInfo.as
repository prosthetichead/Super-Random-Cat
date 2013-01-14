package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	
	
	
	public class LivesInfo extends Entity
	{
		
		private var textLives:Text;
		public var livesRemaining:int;
		
		public function LivesInfo(lives:int=3) 
		{
			livesRemaining = lives;
			
		 textLives = new Text("Lives: 00");
		 textLives.size =8;
		 
		 graphic = textLives;
		 graphic.scrollX = graphic.scrollY = 0;
		 layer = 1;
		 x = 270;
		 y = 0;
		}
		
		override public function update():void
		{
				textLives.text = "LIVES: " + livesRemaining;
		}
	}

}