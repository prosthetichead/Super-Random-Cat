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
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input
	import net.flashpunk.utils.Key;
	import net.flashpunk.Sfx;
	
	 
	public class Player extends Entity
	{
		[Embed(source = "../assets/gfx/player.png")] private const PLAYER_SPRITE:Class;
		[Embed(source = "../assets/sfx/extraLife.mp3")] private const mp3ExtraLife:Class;
		
		
		public var sprPlayer:Spritemap = new Spritemap(PLAYER_SPRITE, 32, 32);
		
        private var power:Number=0.2;
        private var sprintPower:Number=0.4;
		private var jumpPower:Number=5;
        private var hFriction:Number=0.90;
        private var vFriction:Number=0.99;
        public var xSpeed:Number=0;
        public var ySpeed:Number=0;
        private var gravity:Number = 0.3;
		private var maxFallSpeed:Number = 5;
		
        public var isJumping:Boolean=false;
        public var doubleJump:Boolean=false;
		public var onGround:Boolean = false;
		public var onPlatform:Boolean = false;
		public var superJump:Boolean = false;
		
		public var dead:Boolean = false;
		
		
		public function Player(x:int, y:int) 
		{
			sprPlayer.add("standLeft", [8,9,10,11], 5, true);
			sprPlayer.add("walkLeft", [0, 1, 2, 3], 10, true);
			sprPlayer.add("standRight", [12,13,14,15], 5, true);
			sprPlayer.add("walkRight", [4, 5, 6, 7], 10, true);
			sprPlayer.add("sit", [27], 0, false);
			sprPlayer.add("teleportIn", [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], 15, false);
			sprPlayer.add("teleportOut", [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], 15, false);
			
			Input.define("up", Key.UP);
			Input.define("left", Key.LEFT);
			Input.define("right", Key.RIGHT);
			Input.define("down", Key.DOWN);
			Input.define("jump", Key.X, Key.SPACE, Key.CONTROL);
			Input.define("sprint", Key.Z, Key.SHIFT);
			Input.define("pause", Key.P, Key.ENTER);
			
			graphic = sprPlayer;
			sprPlayer.play("teleportIn");
			
			this.x = x;
			this.y = y;

			setHitbox(20,15, -5, -17);
			type = "player";
			collidable = true;
			
			
			layer = 10;
		}
		
		override public function update():void
		{
			
			
			if (collide("collisionGrid", x, y + 1) && !dead)
			{
				onGround = true;
				onPlatform = false;
			}
			else if (collide("PlatformGrid", x, y) && !dead)
			{
				onPlatform = false;
				onGround = false;
			}
			else if (collide("PlatformGrid", x, y + 5) && !dead)
			{
				onPlatform = true;
				onGround = true;
			}
			else
			{
				onPlatform = false;
				onGround = false;
			}
			
			
            if (Input.check("left") && !dead)
			{
				sprPlayer.play("walkLeft");
                if (Input.check("sprint"))
					xSpeed -= sprintPower;
				else
					xSpeed -= power;				
            }
			else if (xSpeed < 0)
				sprPlayer.play("standLeft");
                
			
			
            if (Input.check("right") && !dead ) 
			{
				sprPlayer.play("walkRight");
                if (Input.check("sprint"))
					xSpeed += sprintPower;
				else
					xSpeed += power;	
            }
			else if (xSpeed > 0)
				sprPlayer.play("standRight");
			
				
				
            if (Input.pressed("jump") && isJumping)
			{
                doubleJump=true;
            }
            if (Input.pressed("jump") && doubleJump && isJumping)
			{
                ySpeed=-jumpPower;
                isJumping=false;
                doubleJump=false;
            }
            
			if (onGround)
			{
                isJumping=false;
                if (Input.pressed("jump")) 
				{
					if (superJump)
						ySpeed = -jumpPower * 2;
						
					else
						ySpeed = -jumpPower;
						
                    isJumping = true;
					superJump = false;
					
                }
            } 
			else
			{
                ySpeed+=gravity;
            }
			
			
            if (Math.abs(xSpeed) < 1 && !Input.check("left") && !Input.check("right"))
			{
                xSpeed=0;
            }
			
			// apply friction to speed
            xSpeed *= hFriction;
            ySpeed *= vFriction;
			
			if (ySpeed > maxFallSpeed)
				ySpeed = maxFallSpeed;
			
			//move the player
			if (!dead && onPlatform)
			{
				moveBy(xSpeed, ySpeed, ["collisionGrid", "PlatformGrid"]);
				checkEnemyCollisons();
			}
			else if (dead)
			{
				moveBy(xSpeed, ySpeed);
			}
			else 
			{
				moveBy(xSpeed, ySpeed, ["collisionGrid"]);
				checkEnemyCollisons();
			}
			
			//Check if fallen off the end of the level	
			if (y > Game.levelHeight + 50 )
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
				
        }
  
		private function checkEnemyCollisons():void 
		{
			var redBizDog:RedBizDog = collide("RedBizDog", x, y) as RedBizDog;
			var blueBizDog:BlueBizDog = collide("BlueBizDog", x, y) as BlueBizDog;
			if (redBizDog)
			{
				if (!redBizDog.dead)
				{
					if (!onGround)
					{				
						if (redBizDog.top > top)
						{
							ySpeed = -4;
							redBizDog.killed();
						}
						else
						{		
						die();
						}
					}
					else 
						die();
				}
			}
			else if (blueBizDog)
			{
				if (!blueBizDog.dead && blueBizDog.sprBlueBizDog.currentAnim != "idle")
				{	
					if (!onGround)
					{
						if (blueBizDog.top > top)
						{
							ySpeed = -4;
							blueBizDog.killed();
						}
						else
						{
							die();
						}	
					}
					else
						die();
				}
			}
			

		}
		
		public function die():void 
		{
			Game.music.stop();
			Game.musicDie.play(.1);
			ySpeed -= 8
			sprPlayer.angle = 90
			sprPlayer.play("walkLeft");
			dead = true;
		}
		override public function moveCollideX(e:Entity):Boolean 
		{
			
			xSpeed = 0;
		
			return true;
        }
       override public function moveCollideY(e:Entity):Boolean
	   {
			
		   ySpeed = 0;
				
			return true;
		}
		
	}
}