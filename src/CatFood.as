package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	public class CatFood extends Entity
	{
		[Embed(source = "../assets/gfx/catFood.png")] private var imgCatFood:Class;
		private var sprCatFood:Image;
		
		public function CatFood(x:int, y:int) 
		{
			sprCatFood = new Image(imgCatFood);
			graphic = sprCatFood;
			this.x = x;
			this.y = y;
		
			type = "catFood";
			setHitbox(10, 10);
		
			collidable = true;
		}
		
		override public function update():void
		{
			
		}
		
		
	}

}