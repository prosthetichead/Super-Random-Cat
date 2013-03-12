package  
{
	
	import net.flashpunk.Entity
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.graphics.Graphiclist;
	
	public class SignPost extends Entity
	{
	
		[Embed(source="../assets/gfx/signPost.png")] private var imgSignPost:Class;
		[Embed(source = "../assets/gfx/upx.png")] private var imgUpX:Class;
			
		private var sprSignPost:Image;
		public var message:String;
		//public var displayHelp:DisplayHelp;
		private var sprUpX:Image;
		
		private var gList:Graphiclist = new Graphiclist();
		
		private var textBoxArea:TextBoxArea;
		
		public function SignPost(x:int, y:int, message:String = "text here") 
		{
			this.x = x;
			this.y = y;
			this.message = message;
			sprSignPost = new Image(imgSignPost);
			sprUpX = new Image(imgUpX);
			sprUpX.x = 0;
			sprUpX.y = -28;
			
			sprUpX.visible = false;
			sprUpX.alpha = 0;
			
			gList.add(sprUpX);
			gList.add(sprSignPost);
			
			addGraphic(gList);
			setHitbox(32, 32, 0, 0);
			type = "signPost";	
			layer = 95;
		}
		
		override public function update():void 
		{	
			if (collide("player", x, y) && !sprUpX.visible)
			{
				sprUpX.visible = true
			}
			else if (!collide("player", x, y) && sprUpX.visible)
			{
				sprUpX.alpha -= .04;
				if (sprUpX.alpha <= 0 )
					sprUpX.visible = false;
			}
			if (sprUpX.alpha < 1 && sprUpX.visible)
			{
				sprUpX.alpha += .01;
			}	

			
			
			
			
			if (Input.pressed("up") &&  collide("player", x, y) && !textBoxArea)
			{
				textBoxArea = new TextBoxArea(x, y, message);
				FP.world.add(textBoxArea);
			}
			else if ((textBoxArea && Input.pressed("up")) || (!collide("player", x, y) && textBoxArea))
			{
				textBoxArea.distroy();
				textBoxArea = null;
			}
				
		}
	}

}