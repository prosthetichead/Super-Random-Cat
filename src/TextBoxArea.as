package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	/**
	 * ...
	 * @author ash
	 */
	public class TextBoxArea extends Entity 
	{
		
		[Embed(source = "../assets/gfx/textBox.png")]private var imgTextBox:Class;
		private var sprTextBox:Image = new Image(imgTextBox);
		private var fullSize:Boolean = false;
		private var text:Text;
		private var textEntity:Entity;
		
		public function TextBoxArea(x:int, y:int, message:String)
		{
			sprTextBox = new Image(imgTextBox);
			sprTextBox.scale = 0;

			graphic = sprTextBox;
				
			x = FP.camera.x + 35;
			y = FP.camera.y + 10;
			layer = 3;
			
			//centerOrigin();
			
			text = new Text(message);
			text.size = 8;
			text.color = 0x00FFFF;
			textEntity = new Entity(200, 200, text);
			textEntity.layer = 2;
			FP.world.add(textEntity);
			textEntity.visible = false;

		}
		
		override public function update():void
		{
			if (sprTextBox.scale < 1)
			{
				sprTextBox.scale += .06;
				x = FP.camera.x + 35;
				y = FP.camera.y + 10;
			}
			else
			{
				sprTextBox.scale = 1;
				fullSize = true;
			}	
			
			if (fullSize)
			{
				//start printing out the text.
				//show 1 letter a second to be like the old type out stile used by snes
				textEntity.visible = true;
				textEntity.x = x + 10;
				textEntity.y = y + 10;				
			}
		

			
		}
		
		public function distroy():void 
		{
			FP.world.remove(textEntity);
			FP.world.remove(this);
			
		}
		
	}

}