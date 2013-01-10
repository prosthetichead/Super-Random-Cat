package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	
	public class Bouncer extends Entity
	{
		
		var boucing:Boolean = false;
		
		
		public function Bouncer(x:int, y:int)
		{
			
		}
		
		override public function update():void 
		{
			if (!boucing)
				return true;
			
				
		}
		
	}

}