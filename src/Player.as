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
		private var frozen:Boolean = false;
		
		
		public function Player(x:int, y:int) 
		{
			sprPlayer.add("standLeft", [1], 0, true);
			sprPlayer.add("walkLeft", [0, 1, 2], 10, true);
			sprPlayer.add("standRight", [4], 0, false);
			sprPlayer.add("walkRight", [3, 4, 5], 10, true);
			
			
			Input.define("left", Key.LEFT);
			Input.define("right", Key.RIGHT);
			Input.define("down", Key.DOWN);
			Input.define("jump", Key.X);
			Input.define("sprint", Key.Z);
			
			graphic = sprPlayer;
			sprPlayer.play("standRight");
			
			this.x = x;
			this.y = y;

			setHitbox(32, 16);
			originY = -16;
			type = "player";
			collidable = true;
			
		}
		
		override public function update():void
		{
			
			//ground check
 			onGround = (collide("collisionGrid", x, y + 1) || (collide("platform", x, y + 1) && !collide("platform", x, y)));

			//move left
			if (Input.check("left"))
			{
				sprPlayer.play("walkLeft");
				if (onGround) { speed.x -= acceleration; }
				else { speed.x -= acceleration * airControl; }
			}
			//move right
			if (Input.check("right"))
			{
				sprPlayer.play("walkRight");
				if (onGround) { speed.x += acceleration; }
				else { speed.x += acceleration * airControl; }
			}
			//drop
			if (Input.check("down") && Input.check("jump"))
			{
				if (collide("platform", x, y + 1) && !collide("collisionGrid", x, y + 1)) { y++; }
			}
			//jump
			else if (Input.check("jump") && onGround) { speed.y = - jump; }
			if (!Input.check("jump") && speed.y < 0) { speed.y += gravity; }
			
			//falling
			speed.y += gravity;
			
			//horizontal collisions
			for (var i:int = 0; i < Math.abs(speed.x); i += 1)
			{
				if (!collide("collisionGrid", x + FP.sign(speed.x), y)) 
				{ 
					x += FP.sign(speed.x); 
				} else 
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
			
			//idling
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
			
			//speed limits
			if (Math.abs(speed.x) > maxspeed) { speed.x = FP.sign(speed.x) * maxspeed; }
			if (speed.y > maxFall) { speed.y = maxFall; }
			
			if (collide("finish", x, y)) {
				frozen = true;
				//Game.finished = true;
			}
			
			//camera
			FP.camera.x += Math.round(((x - FP.width / 4) - FP.camera.x) / 10);
			FP.camera.y += Math.round(((y - FP.height / 4) - FP.camera.y) / 10);
			
			
			
		}

		

	}
}
