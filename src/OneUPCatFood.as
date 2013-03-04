package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;
	
	public class OneUPCatFood extends Entity
	{
		[Embed(source = "../assets/gfx/1UPcatFood.png")] private var imgCatFood:Class;
		[Embed(source = "../assets/sfx/collect.mp3")] private var mp3Collect:Class;
		[Embed(source="../assets/gfx/sparkle.png")] private var imgSparkle:Class;
		
		private var sprCatFood:Image;
		private var sfxCollect:Sfx = new Sfx(mp3Collect);
		private var ogX:int;
		private var ogY:int;
		private var collected:Boolean = false;
		private var emit:Emitter = new Emitter(imgSparkle, 2, 2);
		private var gList:Graphiclist = new Graphiclist();
		private var timer:Number = 0;
		
		public function OneUPCatFood(x:int, y:int) 
		{
			sprCatFood = new Image(imgCatFood);
			
			this.x = x;
			this.y = y;
			setOrigin(5, 5);
			type = "1UPcatFood";
			setHitbox(10, 10);
			
			emit.newType("test", [0]);
			//emit.setAlpha("test", 1, 0);
			emit.setGravity("test", 5, 3);
			emit.setMotion("test", 0, 0, 0, 360, 50, .5);
			
			collidable = true;
			
			addGraphic(emit);
			addGraphic(sprCatFood);
			
			//addGraphic(gList);
			layer = 95;
			
		}
		
		override public function update():void
		{
			if (collideWith(Game.player, x, y) && !Game.player.dead && !collected)
			{
				sfxCollect.play(.2);
				Game.infoText.plusScore(1);
				collected = true;
				sprCatFood.visible = false;
				Game.infoText.lives += 1;
					
			}
			
			if (collected && timer < .2)
			{
				timer += FP.elapsed;
				emit.emit("test", 0, 0);
			}
				
			
			if(collected && emit.particleCount == 0)
				FP.world.remove(this);
		}
		
		
	}

}