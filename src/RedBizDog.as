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
		private var  maxspeed:Number = .5;
		
		public var dead:Boolean = false;
		
		public function RedBizDog(x:int, y:int) 
		{
			sprBizDog.add("walkLeft", [8, 9, 10, 11], 10, true);
			sprBizDog.add("walkRight", [12, 13, 14, 15], 10, true);
			sprBizDog.play("walkLeft");
			this.x = x;
			this.y = y;
			graphic = sprBizDog;
			setHitbox(5, 25, -5, -6);
			type = "RedBizDog";
			
			layer = 15;
		}
		
		override public function update():void
		{
			//onGround = (collide("collisionGrid", x, y + 1) || (collide("PlatformGrid", x, y + 1) && !collide("PlatformGrid", x, y)));
			speed.y += gravity;
			if (dead)
			{
				if (sprBizDog.angle < 180)
				{
					sprBizDog.angle += 20;
				}
				speed.x = 0;
				sprBizDog.centerOrigin();
				y += 5;
				
			}	
				
			if (sprBizDog.currentAnim == "walkLeft" && !dead)
			{
				speed.x -= acceleration;
			}
			else if  (sprBizDog.currentAnim == "walkRight" && !dead)
			{
				speed.x += acceleration;
			}	
		
			for (var i:int = 0; i < Math.abs(speed.x); i += 1)
			{
				if (!collide("collisionGrid", x + FP.sign(speed.x), y))
					x += speed.x; 
				else 
				{ 
					//speed.x = 0;
					
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
			
			
			if ((!collide("PlatformGrid", x + 10 , y + halfHeight) || !collide("PlatformGrid", x -10 , y + halfHeight)) && (!collide("collisionGrid", x + 10, y+5) || !collide("collisionGrid", x - 10, y+5)))
			//if ((!collide("collisionGrid", x + 10, y+5) || !collide("collisionGrid", x - 10, y+5)) && (!collide("PlatformGrid", x + 10, y+1) || !collide("PlatformGrid", x - 10, y+1)) )
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
		
		public function killed():void 
		{
			sfxDogDie.play(.5);
			Game.infoText.plusScore(10 * Game.player.bounceCount);
			dead = true;
		}
		
		public function destroy():void
		{
			FP.world.remove(this);
		}
		
	}

}