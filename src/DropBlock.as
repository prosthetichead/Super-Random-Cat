package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.utils.Ease;
	
		
	
	public class DropBlock extends Entity
	{
	
		[Embed(source = "../assets/gfx/dropBlock.png")] private const imgDropBlock:Class;
		
		private var sprDropBlock:Image = new Image(imgDropBlock);
		private var orgX:int;
		private var orgY:int;
		private var endX:int;
		private var endY:int;
		private var Move:NumTween = new NumTween();
		private var pauseTime:Number = 0;
		
		public function DropBlock(x:int, y:int, endX:int, endY:int) 
		{
			this.x = x;
			this.y = y;
			orgX = x;
			orgY = y;
			this.endX = endX;
			this.endY = endY + 2;
			addGraphic(sprDropBlock);
			
			
			addTween(Move);
			
			type = "collisionGrid";
			setHitbox(64, 32, 0, 0);
			Move.tween(this.orgY, this.endY, 1);
			
		}
		
		override public function update():void 
		{
			if (collideWith(Game.player, x, y))
				{
					trace(Move.scale);
					Game.player.y = Move.value - Game.player.height*2; 
				}
			
			y = Move.value;
			if (Move.percent == 1 && y == endY)
				Move.tween(endY, orgY, 2, Ease.expoIn);
			else if (Move.percent == 1 && y == orgY)
			{
				pauseTime += FP.elapsed;
				if (pauseTime >= .5)
				{
					Move.tween(orgY, endY, .8,Ease.bounceOut);
					pauseTime = 0;
				}
			}
		}
	}

}