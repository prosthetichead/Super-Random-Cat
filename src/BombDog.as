package  
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Emitter;
	
	public class BombDog extends Entity
	{
		[Embed(source = "../assets/gfx/bombDog.png")] private const imgBombDog:Class;
		[Embed(source = "../assets/gfx/bombPar.png")] private const imgBombPar:Class;
		public var sprBombDog:Spritemap = new Spritemap(imgBombDog, 13, 15);
		public var parBomb:Emitter = new Emitter(imgBombPar, 4, 4);
		
		
		public var speed:Point = new Point(0, 0);
		
		private var onGround:Boolean;
		private var gravity:Number = 0.2;
		private var acceleration:Number = 0.6;
		private var  maxspeed:Number = .6;
		public var dead:Boolean = false;
		public var boomCountDown:Boolean = false;
		public var boom:Boolean = false;
		
		
		private var countDownTime:Number = 3;
		private var explodeFlashTime:Number = .5;
		private var countDownTimeRemaining:Number = 3;
		
		
		public function BombDog(x:int, y:int) 
		{
			sprBombDog.add("walkLeft", [0, 1, 2, 3], 10, true);
			sprBombDog.add("walkRight", [4, 5, 6, 7], 10, true);
			sprBombDog.add("explodeCountDownLeft", [8, 9, 10, 11, 12, 13, 14, 15], 3, false);
			sprBombDog.add("explodeCountDownRight", [23, 22, 21, 20, 19, 18, 17, 16], 3, false);
			sprBombDog.play("walkLeft");
			
			parBomb.newType("Boom", [0]);
			parBomb.setAlpha("Boom", 1, 0);
			parBomb.setGravity("Boom", .3, .5);
			parBomb.setMotion("Boom", 0, 0, 0, 200, 50, 2);
			
			
			addGraphic(parBomb);
			addGraphic(sprBombDog);
			this.x = x;
			this.y = y;
			
			setHitbox(13, 15);
			
			type = "bombDog";
		}
		
		
		override public function update():void
		{
			onGround = (collide("collisionGrid", x, y + 1) || (collide("PlatformGrid", x, y + 1) && !collide("PlatformGrid", x, y)));
			speed.y += gravity;
			
			if (sprBombDog.currentAnim == "walkLeft"  && !dead)
			{
				speed.x -= acceleration;
			}
			else if  (sprBombDog.currentAnim == "walkRight"  && !dead)
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
						sprBombDog.play("walkLeft");
					}
					else
					{
						sprBombDog.play("walkRight"); 
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
			
			
			if (collideWith(Game.player, x + 30, y) || collideWith(Game.player, x - 30, y))
			{
				boomCountDown = true;
				speed.x = 0;
				//sprBombDog.play("explodeCountDownLeft");
				//parBomb.emit("Boom", 6.5 , 7.5);
				//sprBombDog.visible = false;
			}
			if (boomCountDown)
			{
				maxspeed = 2;
				countDownTimeRemaining -= FP.elapsed;
				sprBombDog.play("explodeCountDownLeft");
				
				trace (int(countDownTimeRemaining+1));
				
				if (collideWith(Game.player, x, y))
				{
					speed.y -= 1;
					speed.x += 2;
				}
				
				if (countDownTimeRemaining <= 0)
				{
					speed.x = 0;
					speed.y = 0;
					boom = true;
					boomCountDown = false;
					//countDownTimeRemaining = countDownTime;
				
					if (collideWith(Game.player, x, y))
					{
						Game.player.die();
					}
				}
			}
			if (boom)
			{
				gravity = 0;
				explodeFlashTime -= FP.elapsed;
				sprBombDog.visible = false;
				if (explodeFlashTime >= 0)
					parBomb.emit("Boom", 6.5 , 7.5);
				else	
					world.remove(this);
				
			}
			
		}
		
		
		
	}

}