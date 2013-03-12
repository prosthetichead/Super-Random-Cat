package  
{
	import net.flashpunk.Entity;	
	import net.flashpunk.graphics.Spritemap;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
		
	 
	 
	public class BlueBizDog extends Entity
	{
		[Embed(source = "../assets/gfx/bizDogs.png")] private const imgBlueBizDog:Class;
		[Embed(source="../assets/sfx/dogDie.mp3")] private const mp3DogDie:Class;
		public var sprBlueBizDog:Spritemap = new Spritemap(imgBlueBizDog, 16, 32);
		private var sfxDogDie:Sfx = new Sfx(mp3DogDie);
		
		public var speed:Point = new Point(0, 0);
		private var onGround:Boolean;
		private var gravity:Number = 0.2;
		private var acceleration:Number = 0.6;
		private var  maxspeed:Number = .6;
		public var dead:Boolean = false;
		
		
		public function BlueBizDog(x:int, y:int) 
		{
			sprBlueBizDog.add("walkLeft", [0, 1, 2, 3], 10, true);
			sprBlueBizDog.add("walkRight", [4, 5, 6, 7], 10, true);
			sprBlueBizDog.add("idle", [0], 10, true);
			
			sprBlueBizDog.play("idle");
			this.x = x;
			this.y = y;
			graphic = sprBlueBizDog;
			setHitbox(5, 25, -5, -6);
			
			type = "BlueBizDog";
			
			layer = 15;
		}
		
		override public function update():void
		{
			if (sprBlueBizDog.currentAnim == "idle")
			{
				setHitbox(500, 500);
				centerOrigin();
			}
			else
				setHitbox(5, 25, -5, -6);
				
			if ((sprBlueBizDog.currentAnim == "idle") && ( collideWith(Game.player, x, y)))
			{
				setHitbox(5, 25, -5, -6);
				sprBlueBizDog.play("walkLeft");
			}
			onGround = (collide("collisionGrid", x, y + 1) || (collide("PlatformGrid", x, y + 1) && !collide("PlatformGrid", x, y)));
			speed.y += gravity;
			
			speed.y += gravity;
			if (dead)
			{
				if (sprBlueBizDog.angle < 180)
				{
					sprBlueBizDog.angle += 20;
				}
				speed.x = 0;
				sprBlueBizDog.centerOrigin();
				y += 5;
				
			}	
			
			
			if (sprBlueBizDog.currentAnim == "walkLeft"  && !dead)
			{
				speed.x -= acceleration;
			}
			else if  (sprBlueBizDog.currentAnim == "walkRight"  && !dead)
			{
				speed.x += acceleration;
			}	
		
			if (Math.abs(speed.x) > maxspeed)
			{ 
				speed.x = FP.sign(speed.x) * maxspeed;
				
			}
			
			for (var i:int = 0; i < Math.abs(speed.x); i += 1)
			{
				if (!collide("collisionGrid", x + FP.sign(speed.x), y))
					x += speed.x; 
				else 
				{ 
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
				if (!collide("collisionGrid", x, y + FP.sign(speed.y)) && !collide("PlatformGrid", x, y + FP.sign(speed.y))) 
				{
					y += FP.sign(speed.y);
				}
				else { speed.y = 0; }
			}
			

			
			if (y > Game.levelHeight + 40)
				destroy();
		}
		
		public function killed():void 
		{
			sfxDogDie.play(.5);
			//Game.infoText.plusScore(10 * Game.player.bounceCount);
			dead = true;
		}
		
		public function destroy():void
		{
			FP.world.remove(this);
		}
		
	}

}