package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author ash
	 */
	public class textBox extends Entity 
	{
		
		[Embed(source = "../assets/gfx/textBox.png")]private var imgTextBox:Class;
		private var sprTextBox:Image = new Image(imgTextBox);
		
		public function textBox(x:int, y:int)
		{
			sprTextBox = new Image(imgTextBox);
			sprTextBox.scale = 0;

			graphic = sprTextBox;
				
			x = FP.camera.x + 10;
			y = FP.camera.y + 10;
			centerOrigin();
		}
		
		override public function update():void
		{
			if (sprTextBox.scale < 1)
				sprTextBox.scale += .02;
			else
				sprTextBox.scale = 1;
				
				
			x = FP.camera.x + 35;
			y = FP.camera.y + 10;
		}
		
	}

}