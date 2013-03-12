package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.tweens.motion.LinearMotion;
	import flash.geom.Point;
	import net.flashpunk.utils.Input;
	
	
	public class BounceBlock extends Entity
	{
		[Embed(source = "../assets/gfx/bounceBlock.png")] private const imgBounceBlock:Class;
		[Embed(source = "../assets/sfx/littleBoing.mp3")] private const mp3LittleBoing:Class;
		[Embed(source="../assets/sfx/bigBoing.mp3")]  private const mp3BigBoing:Class;
		
		private var sprBounceBlock:Spritemap = new Spritemap(imgBounceBlock, 32, 32);
		private var sfxLittleBoing:Sfx = new Sfx(mp3LittleBoing);
		private var sfxBigBoing:Sfx = new Sfx(mp3BigBoing);
		
		private var bouncing:Boolean = false;
		public var orgX:int;
		public var orgY:int;
		
		
		public function BounceBlock(x:int, y:int)
		{
			sprBounceBlock.add("slowTick", [0, 1, 2, 3], 5, true);
			sprBounceBlock.add("fastTick", [0, 1, 2, 3], 10, true);
			sprBounceBlock.play("slowTick");
			graphic = sprBounceBlock;
			
			this.x = x;
			this.y = y;
			orgX = x;
			orgY = y;
			
			setHitbox(32, 32, 0, 0);
			
			type = "collisionGrid";
			
			collidable = true;
			
		}
		
		override public function update():void 
		{
			if (collideWith(Game.player,x, y - 1))
			{
				if (y < orgY + 20)
				{
					y = y + 1;
					Game.player.moveBy(0, +1, "collisionGrid", true)
				}
				else
				{
					sfxLittleBoing.play(.4);
					Game.player.ySpeed = -5;
					
				}	
				if (y > orgY + 10 && Input.pressed("jump"))
				{
					
					Game.player.superJump = true;
					sfxBigBoing.play(.4);
				}
			}
			else if (collideWith(Game.player,x, y + 5))
			{
				if (y > orgY - 20)
					y = y - 1;	
			}
			else	
			{
				
				if (y < orgY)
					y = y + 1;	
				if (y > orgY)
					y = y - 1;			
			
			}
		}
		
	}

}