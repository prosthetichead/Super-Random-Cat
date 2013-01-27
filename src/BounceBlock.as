package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
		import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
import net.flashpunk.tweens.misc.NumTween;
import net.flashpunk.utils.Ease;
	import net.flashpunk.tweens.motion.LinearMotion;
		import flash.geom.Point;
		import net.flashpunk.utils.Input;
	
	
	public class BounceBlock extends Entity
	{
		[Embed(source = "../assets/gfx/bounceBlock.png")] private const imgBounceBlock:Class;
		private var sprBounceBlock:Spritemap = new Spritemap(imgBounceBlock, 32, 32);
		public var bounceTween:NumTween = new NumTween();
		var bouncing:Boolean = false;
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
			
			addTween(bounceTween);
			bounceTween.tween(y, orgY, 1, Ease.expoOut);
			
		}
		
		public function tweenComplete():void 
		{
			trace("tween complete");
		}
		
		override public function update():void 
		{
			if (collideWith(Game.player,x, y - 1))
			{
				if (y < orgY + 20)
				{
					y = y + 1;
					Game.player.speed.x = 0;
				}
				else
				{
					Game.player.speed.y = -5;
				}	
				if (y > orgY + 5 && Input.pressed("jump"))
					Game.player.speed.y = -8;
			}
			else if (collideWith(Game.player,x, y + 5))
			{
				if (y > orgY - 20)
					y = y - 1;	
			}
			else	
			{
				Game.player.jump = 3.5
				if (y < orgY)
					y = y + 1;	
				if (y > orgY)
					y = y - 1;				
			
			}
		}
		
	}

}