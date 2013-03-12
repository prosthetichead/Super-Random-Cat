package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.motion.LinearPath;
	import net.flashpunk.utils.Ease;
	
		
	
	public class MoveBlock extends Entity
	{
	
		[Embed(source = "../assets/gfx/moveBlock.png")] private const imgMoveBlock:Class;
		
		private var sprMoveBlock:Image = new Image(imgMoveBlock);
		private var Move:LinearPath = new LinearPath();
		
		private var pauseTime:Number = 0;
		
		public function MoveBlock(x:int, y:int) 
		{
			this.x = x;
			this.y = y;
			sprMoveBlock.originX = 48;
			addGraphic(sprMoveBlock);
			Move.addPoint(x, y);
			//Move.object = this;
			
			addTween(Move);
			
			type = "collisionGrid";
			setHitbox(96, 16, 0, 0);
			setOrigin(48, 0);
		
			
		}
		
		public function addPathNode(nodeX:int, nodeY:int):void 
		{
			Move.addPoint(nodeX, nodeY);
			Move.setMotionSpeed(50);
			Move.start();
		}
		
		override public function update():void 
		{
			
			var difranceX:int = Move.x - x;
			var difranceY:int = Move.y - y;
			if (collideWith(Game.player,x, y - 5))
			{
				
				Game.player.moveBy(difranceX, difranceY, ["collisionGrid"],true); 
			}
			else if (collideWith(Game.player, x + 1, y) || collideWith(Game.player, x - 1, y))
			{
				Game.player.moveBy(difranceX, 0); 
			}
			moveBy(difranceX, difranceY); 
		}
	}

}