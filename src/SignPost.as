package  
{
	
	import net.flashpunk.Entity
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
	public class SignPost extends Entity
	{
	
		[Embed(source="../assets/gfx/signPost.png")] private var imgSignPost:Class;
		private var sprSignPost:Image;
		public var message:String;
		public var displayHelp:DisplayHelp;
		
		public function SignPost(x:int, y:int, message:String = "text here") 
		{
			this.x = x;
			this.y = y;
			this.message = message;
			sprSignPost = new Image(imgSignPost);	
			graphic = sprSignPost;
			setHitbox(32, 32, 0, 0);
			type = "signPost";			
		}
		
		override public function update():void 
		{	
			if (collide("player", x, y) && !displayHelp)
			{
				displayHelp = new DisplayHelp(x, y - 10);
				FP.world.add(displayHelp);
			}
			else if (!collide("player", x, y) && displayHelp)
			{
				displayHelp.distory();
				displayHelp = null;
			}
				
			if (Input.check("up") && Input.pressed("sprint")  &&  collide("player", x, y))
				trace(message);
		}
	}

}