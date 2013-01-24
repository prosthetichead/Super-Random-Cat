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
			setHitbox(16, 27, 0, 0);
			setOrigin(0, -5);
			type = "BlueBizDog";
			
			layer = 15;
		}
		
		override public function update():void
		{
			onGround = (collide("collisionGrid", x, y + 1) || (collide("PlatformGrid", x, y + 1) && !collide("PlatformGrid", x, y)));
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