package  
{
	import net.flashpunk.Entity;	
	import net.flashpunk.graphics.Spritemap;
	import flash.geom.Point;
	import net.flashpunk.FP;
		
	 
	 
	public class BlueBizDog extends Entity
	{
		[Embed(source = "../assets/gfx/bizDogs.png")] private const imgBlueBizDog:Class;
		public var sprBlueBizDog:Spritemap = new Spritemap(imgBlueBizDog, 16, 32);
		
		public var speed:Point = new Point(0, 0);
		private var onGround:Boolean;
		private var gravity:Number = 0.2;
		private var acceleration:Number = 0.1;
		private var  maxspeed:Number = .9;
		
		
		public function BlueBizDog(x:int, y:int) 
		{
			sprBlueBizDog.add("walkLeft", [0, 1, 2, 3], 10, true);
			sprBlueBizDog.add("walkRight", [4, 5, 6, 7], 10, true);
			sprBlueBizDog.play("walkLeft");
			this.x = x;
			this.y = y;
			graphic = sprBlueBizDog;
			setHitbox(16, 32, 0, 0);
		}
		
		override public function update():void
		{
			onGround = (collide("collisionGrid", x, y + 1) || (collide("platform", x, y + 1) && !collide("platform", x, y)));
			speed.y += gravity;
			
			if (sprBlueBizDog.currentAnim == "walkLeft")
			{
				speed.x -= acceleration;
			}
			else if  (sprBlueBizDog.currentAnim == "walkRight")
			{
				speed.x += acceleration;
			}	
		
			for (var i:int = 0; i < Math.abs(speed.x); i += 1)
			{
				if (!collide("collisionGrid", x + FP.sign(speed.x), y))
					x += FP.sign(speed.x); 
				else 
				{ 
					speed.x = 0;
					trace("POP");
					
					if (speed.x > 0)
					{
						sprBlueBizDog.play("walkLeft");
					}
					else
					{
						sprBlueBizDog.play("walkRight"); 
					}	
				}
			}
			for (i = 0; i < Math.abs(speed.y); i += 1)
			{
				if (!collide("collisionGrid", x, y + FP.sign(speed.y)) && !(collide("platform", x, y + 1) && speed.y > 0 && !collide("platform", x, y)))
				{
					y += FP.sign(speed.y);
				}
				else { speed.y = 0; }
			}
			
			//MAX SPEEDS
			if (Math.abs(speed.x) > maxspeed)
			{ 
				speed.x = FP.sign(speed.x) * maxspeed;
			}
		}
		
	}

}