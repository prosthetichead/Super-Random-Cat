package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	
	
	public class DisplayHelp extends Entity 
	{
		
		[Embed(source = "../assets/gfx/upx.png")] private var imgUpX:Class;
		private var sprUpX:Image = new Image(imgUpX);
		private var showHelp:Boolean = true;
		
		public function DisplayHelp(x:int, y:int) 
		{
			graphic = sprUpX;
			this.x = x;
			this.y = y;
			sprUpX.alpha = 0;
		}
		
		
		
		override public function update():void 
		{
			
			if (sprUpX.alpha < 1 && showHelp)
			{
				sprUpX.alpha += .01;
			}	
			
			if (!showHelp)
			{
				sprUpX.alpha -= .04;
				if (sprUpX.alpha <= 0 )
					FP.world.remove(this);
			}
		}
		
		public function distory():void 
		{
			showHelp = false;
		}
	}

}