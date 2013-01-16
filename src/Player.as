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
	//import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input
	import net.flashpunk.utils.Key;
	 
	public class Player extends Entity
	{
		[Embed(source = "../assets/gfx/player.png")] private const PLAYER_SPRITE:Class;
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
		private var dead:Boolean = false;
		
		private var blueBizDog:BlueBizDog;
		
		public static var score:int;
		public static var lives:int;
		
		public function Player(x:int, y:int) 
		{
			sprPlayer.add("standLeft", [1], 0, true);
			sprPlayer.add("walkLeft", [0, 1, 2], 10, true);
			sprPlayer.add("standRight", [4], 0, false);
			sprPlayer.add("walkRight", [3, 4, 5], 10, true);
			
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
			acceleration = 5;
			speed.y = - 5
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
				if (collide("platform", x, y + 1) && !collide("collisionGrid", x, y + 1)) { y++; }
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
			blueBizDog = collide("blueBizDog", x, y) as BlueBizDog;
			if (blueBizDog && !onGround)
			{
				if (blueBizDog.top < this.top)
				{
					speed.y = - 5;
					blueBizDog.destroy();
				}
			}
			else if (blueBizDog)
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
					if (!collide("collisionGrid", x, y + FP.sign(speed.y)) && !(collide("platform", x, y + 1) && speed.y > 0 && !collide("platform", x, y)))
					{
						y += FP.sign(speed.y);
					}
					else { speed.y = 0; }
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
			
			
			if (y > Game.levelHeight + 40 )
			{
				Game.livesInfo.livesRemaining -= 1;
				if (Game.livesInfo.livesRemaining > 0)
					Game.reset = true;
				else
					Game.gameOver = true;
			}
		}
		
		
		
		override public function update():void
		{
			//ground check
 			onGround = (collide("collisionGrid", x, y + 1) || (collide("platform", x, y + 1) && !collide("platform", x, y)));
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