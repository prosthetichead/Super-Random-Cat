package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	
	public class Teleport extends Entity
	{
		
		[Embed(source = "../assets/gfx/teleport.png")] private const imgTeleport:Class;
		private var sprTeleport:Spritemap = new Spritemap(imgTeleport, 32, 32);
		private var exit:Boolean;
		
		public function Teleport(x:int, y:int) 
		{
			sprTeleport.add("normal", [0, 1, 2, 3, 4, 5, 6, 7], 10);
			sprTeleport.add("exit", [8, 9, 10, 11, 12, 13, 14, 15,16,17,18,19,20,21,22,23,24,25,26,27,28,29], 10, false);
			sprTeleport.add("show", [29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8], 10, false);
			sprTeleport.add("hidden", [29], 0, false);
			
			sprTeleport.play("normal");
			
			graphic = sprTeleport;
			
			this.x = x;
			this.y = y;
			setHitbox(1, 1, -15, -25);
			layer = 95;
		}
		
		public override function update():void 
		{
			if (collideWith(Game.player, x, y))
			{
				sprTeleport.play("exit");
				Game.player.finishLevel();
			}
			if (sprTeleport.currentAnim == "exit" && sprTeleport.complete)
			{
				Game.currentLevel += 1;
				Game.reset = true;
			}
		}
		
	}

}