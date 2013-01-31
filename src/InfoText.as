package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Text;
	
	
	
	public class InfoText extends Entity
	{
		
		private var textLives:Text ;
		private var textScore:Text ;
		private var textShadowLives:Text ;
		private var textShadowScore:Text ;
		private var textIncressScore:Text; 
		
		private var entInfoText:Entity;
		private var glistInfoText:Graphiclist;
		public var score:int = 0;
		public var lives:int = 3;
	
		
		public function InfoText() 
		{
			
		 textScore = new Text("SCORE: 0", 0, 0);
		 textLives = new Text("LIVES: 0", 270, 0);
		 textShadowScore = new Text("SCORE: 0", 1, 1);
		 textShadowLives = new Text("LIVES: 0", 271, 1);	
		 textShadowScore.color = 0x000000;
		 textShadowLives.color = 0x000000;

		 
		 textScore.size = textShadowScore.size = textShadowLives.size = textLives.size = 8;
		 
		 textLives.scrollX = textLives.scrollY = 0;
		 textScore.scrollX = textScore.scrollY = 0;
		 textShadowScore.scrollX = textShadowScore.scrollY = 0;
		 textShadowLives.scrollX = textShadowLives.scrollY = 0;
		  
			glistInfoText = new Graphiclist();
			addGraphic(textShadowLives);
			addGraphic(textShadowScore);
			addGraphic(textLives);
			addGraphic(textScore);
			addGraphic(glistInfoText);
		 
		 layer = 1;
		 x = 0;
		 y = 0;
		}
		
		override public function update():void
		{
			textScore.text = textShadowScore.text = "SCORE: " + score;
			textLives.text = textShadowLives.text = "LIVES: " + lives;
		
			for (var i:int = 0; i < glistInfoText.count; i++)
			{
				var tempText:Text = glistInfoText.children[i] as Text;
				if (tempText.alpha != 0)
				{
					tempText.y += -.2;
					tempText.alpha += -.05;
				}
				else
					glistInfoText.removeAt(i);
			}
		}
		
		public function plusScore(value:int):void 
		{
			var newText:Text = new Text("+" + value, 25, 10);
			var newTextShadow:Text = new Text("+" + value, 26, 11);
			
			newTextShadow.size = newText.size = 8;
			newTextShadow.scrollX = newText.scrollX = newTextShadow.scrollY = newText.scrollY = 0;
			newText.color = 0xcc3333;
			newTextShadow.color = 0x000000;
			score += value;
			glistInfoText.add(newTextShadow);
			glistInfoText.add(newText);

		}
	}

}