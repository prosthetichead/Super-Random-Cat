package  
{
	import net.flashpunk.Entity;	
	import net.flashpunk.graphics.Spritemap;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
		
	 
	 
	public class RedBizDog extends Entity
	{
		[Embed(source = "../assets/gfx/bizDogs.png")] private const imgBlueBizDog:Class;
		public var sprBizDog:Spritemap = new Spritemap(imgBlueBizDog, 16, 32);
		[Embed(source = "../assets/sfx/dogDie.mp3")] private const mp3DogDie:Class;
		private var sfxDogDie:Sfx = new Sfx(mp3DogDie);
		
		
		public var speed:Point = new Point(0, 0);
		private var onGround:Boolean;
		private var gravity:Number = 0.2;
		private var acceleration:Number = 0.1;
		private var  maxspeed:Number = .9;
		
		
		public function RedBizDog(x:int, y:int) 
		{
			sprBizDog.add("walkLeft", [8, 9, 10, 11], 10, true);
			sprBizDog.add("walkRight", [12, 13, 14, 15], 10, true);
			sprBizDog.play("walkLeft");
			this.x = x;
			this.y = y;
			graphic = sprBizDog;
			setHitbox(16, 32, 0, 0);
			type = "RedBizDog";
			
			layer = 15;
		}
		
		override public function update():void
		{
			onGround = (collide("collisionGrid", x, y + 1) || (collide("platform", x, y + 1) && !collide("platform", x, y)));
			speed.y += gravity;
			
			if (sprBizDog.currentAnim == "walkLeft")
			{
				speed.x -= acceleration;
			}
			else if  (sprBizDog.currentAnim == "walkRight")
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
					
					if (speed.x > 0)
					{
						sprBizDog.play("walkLeft");
					}
					else
					{
						sprBizDog.play("walkRight"); 
					}	
				}
			}
			
			if (!collide("collisionGrid", x + 10, y+5) || !collide("collisionGrid", x - 10, y+5))
			{
					//y += FP.sign(speed.y);
					x -= FP.sign(speed.x);
					
					if (speed.x > 0)
					{
						//x += 10;
						sprBizDog.play("walkLeft");
					}
					else
					{
						//x += -10;
						sprBizDog.play("walkRight"); 
					}		
			
			}
			
			//MAX SPEEDS
			if (Math.abs(speed.x) > maxspeed)
			{ 
				speed.x = FP.sign(speed.x) * maxspeed;
			}
			
			if (y > Game.levelHeight + 40)
				destroy();
		}
		
		public function destroy():void
		{
			sfxDogDie.play(.5);
			Game.infoText.score += 10;
			FP.world.remove(this);
		}
		
	}

}