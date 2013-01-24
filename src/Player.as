package  
{
	/**
	 * ...
	 * @author ash
	 */
	
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input
	import net.flashpunk.utils.Key;
	import net.flashpunk.Sfx;
	 
	public class Player extends Entity
	{
		[Embed(source = "../assets/gfx/player.png")] private const PLAYER_SPRITE:Class;
		[Embed(source = "../assets/sfx/jumpLand.mp3")] private const mp3JumpLand:Class;
		public var sprPlayer:Spritemap = new Spritemap(PLAYER_SPRITE, 32, 32);
		
		
		public var speed:Point = new Point(0, 0);
		public var acceleration:Number = 0.5;
		public var friction:Number = 0.5;
		public var gravity:Number = 0.2;
		public var jump:Number = 3.5;
		public var maxspeed:Number = 2;
		public var maxFall:Number = 3.6;
		public var airControl:Number = .5; //Percentage of control when airborne. Should be between 0 and 1 (inclusive).
		public var onGround:Boolean = false;
		public var dead:Boolean = false;
		private var landed:Boolean = true;
		
		
		public static var score:int;
		public static var lives:int;
		
		public var sfxJumpLand:Sfx = new Sfx(mp3JumpLand);
		
		public function Player(x:int, y:int) 
		{
			sprPlayer.add("standLeft", [8,9,10,11], 5, true);
			sprPlayer.add("walkLeft", [0, 1, 2, 3], 10, true);
			sprPlayer.add("standRight", [12,13,14,15], 5, true);
			sprPlayer.add("walkRight", [4, 5, 6,7], 10, true);
			
			Input.define("up", Key.UP);
			Input.define("left", Key.LEFT);
			Input.define("right", Key.RIGHT);
			Input.define("down", Key.DOWN);
			Input.define("jump", Key.X);
			Input.define("sprint", Key.Z);
			Input.define("pause", Key.SPACE, Key.ENTER);
			
			graphic = sprPlayer;
			sprPlayer.play("standRight");
			
			this.x = x;
			this.y = y;

			setHitbox(18,19,-10, -13);
			type = "player";
			collidable = true;
			
			
			layer = 10;
		}
		
		private function die():void 
		{
			
			
			
			Game.music.stop();
			Game.musicDie.play(.1);
			acceleration = 5;
			speed.y = - 7
			sprPlayer.angle = 90
			sprPlayer.play("walkLeft");
			dead = true;
			
		}
		
		
		private function checkForInput():void 
		{
			if(sprPlayer.currentAnim == "walkLeft" || sprPlayer.currentAnim == "standLeft")
			{
				setHitbox(18, 19, -4, -13);
			}
			else
			{
				setHitbox(18, 19, -10, -13);
			}
		
			if (Input.check("sprint"))
			{
				maxspeed = 4;
				acceleration = 2;
			}
			else
			{
				maxspeed = 2;
				acceleration = .5;
			}
			
			if (Input.check("left"))
			{
				sprPlayer.play("walkLeft");
				if (onGround) { speed.x -= acceleration; }
				else { speed.x -= acceleration * airControl; }
			}
			if (Input.check("right"))
			{
				sprPlayer.play("walkRight");
				if (onGround) { speed.x += acceleration; }
				else { speed.x += acceleration * airControl; }
			}
			
			if (Input.check("down") && Input.check("jump"))
			{
				if (collide("PlatformGrid", x, y + 1) && !collide("collisionGrid", x, y + 1)) { y++; }
			}
			else if (Input.pressed("jump") && onGround) { speed.y = - jump; }
			
			if (!Input.check("jump") && speed.y < 0) { speed.y += gravity; }
			
			if ((!Input.check("left") && !Input.check("right")) || (Input.check("left") && Input.check("right")))
			{
				if (speed.x > 0) 
				{ 
					sprPlayer.play("standRight");
					//For friction when in the air, leave the next line uncommented.
					//speed.x -= friction;
					//For no friction in the air, comment the above line and uncomment the next. (Recommended when airControl < 1)
					if (onGround) { speed.x -= friction; }
					if (speed.x < 0) { speed.x = 0; }
				}
				if (speed.x < 0) 
				{
					sprPlayer.play("standLeft");
					//For friction when in the air, leave the next line uncommented.
					//speed.x += friction;
					//For no friction in the air, comment the above line and uncomment the next. (Recommended when airControl < 1)
					if (onGround) { speed.x += friction; }
					if (speed.x > 0) { speed.x = 0; }
				}
			}
		}
		
		private function checkEnemyCollisons():void 
		{
			var redBizDog:RedBizDog = collide("RedBizDog", x, y) as RedBizDog;
			var blueBizDog:BlueBizDog = collide("BlueBizDog", x, y) as BlueBizDog;
			if (redBizDog && !onGround)
			{
				
				if (redBizDog.top > top)
				{
					speed.y = - 5;
					redBizDog.destroy();
				}
				else
					die();
			}
			else if (blueBizDog && !onGround)
			{
				if (blueBizDog.top > top)
				{
					speed.y = - 5;
					blueBizDog.destroy();
				}
				else
					die();
			}
			else if (redBizDog || blueBizDog)
			{
				die()
			}	
		}
		
		private function movement(colide:Boolean = true):void 
		{
			if (colide)
			{
				//horizontal collisions
				for (var i:int = 0; i < Math.abs(speed.x); i += 1)
				{
					if (!collide("collisionGrid", x + FP.sign(speed.x), y)) 
					{ 
						x += FP.sign(speed.x); 
					} 
					else 
					{ 
						if (speed.x > 0) { sprPlayer.play("standRight"); } else { sprPlayer.play("standLeft"); }
							speed.x = 0; 
					}
				}
				//vertical collisions
				for (i = 0; i < Math.abs(speed.y); i += 1)
				{
					if (!collide("collisionGrid", x, y + FP.sign(speed.y)) && !(collide("PlatformGrid", x, y + 1) && speed.y > 0 && !collide("PlatformGrid", x, y)))
					{
						y += FP.sign(speed.y);
					}
					else
					{ 
						
						speed.y = 0; 
					}
				}
				
				if (Math.abs(speed.x) > maxspeed) { speed.x = FP.sign(speed.x) * maxspeed; }
				if (speed.y > maxFall) { speed.y = maxFall; }
			}
			else
			{
				for (var i:int = 0; i < Math.abs(speed.y); i += 1)
					y += FP.sign(speed.y);
					
				for (i = 0; i < Math.abs(speed.x); i += 1)
					x += FP.sign(speed.x);
			}
			
			
			if (y > Game.levelHeight + 5 )
			{
				if (dead)
				{
				Game.infoText.lives -= 1;
				if (Game.infoText.lives > 0)
					Game.reset = true;
				else
					Game.gameOver = true;
				}
				else 
				{
					die();	
				}	
			}
			
			
			clampHorizontal(0, Game.levelWidth, 0);
			
		}
		
		
		
		override public function update():void
		{
			//ground check
 			onGround = (collide("collisionGrid", x, y + 1) || (collide("PlatformGrid", x, y + 1) && !collide("PlatformGrid", x, y)) || dead);
			if (!onGround)
				landed = false;
			if (onGround && !landed)
			{
				sfxJumpLand.play();
				landed = true;
			}	
			//gravity
			speed.y += gravity;

			if (!dead)
			{
				checkEnemyCollisons();					
				checkForInput();
				movement();
			}
			else
			{
				movement(false);
			}

			if (collide("finish", x, y)) {
				
				//Game.finished = true;
			}
			
			//camera			

		}

		

	}
}