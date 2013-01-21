package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	
	public class CatFood extends Entity
	{
		[Embed(source = "../assets/gfx/catFood.png")] private var imgCatFood:Class;
		[Embed(source="../assets/sfx/collect.mp3")] private var mp3Collect:Class;
		private var sprCatFood:Image;
		private var sfxCollect:Sfx = new Sfx(mp3Collect);
		private var ogX:int;
		private var ogY:int;
		private var collected:Boolean = false;
		
		public function CatFood(x:int, y:int) 
		{
			sprCatFood = new Image(imgCatFood);
			graphic = sprCatFood;
			this.x = x;
			this.y = y;
			setOrigin(5, 5);
			type = "catFood";
			setHitbox(10, 10);
		
			collidable = true;
			
			layer = 95;
			
		}
		
		override public function update():void
		{
			if (collideWith(Game.player, x, y) && !Game.player.dead)
			{
				sfxCollect.play(.5);
				Game.infoText.score += 10;
				FP.world.remove(this);
			}				
		}
		
		
	}

}