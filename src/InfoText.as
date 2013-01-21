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
		
		private var entInfoText:Entity;
		private var glistInfoText:Graphiclist;
		public var score:int = 0;
		public var lives:int = 3;
		
		public function InfoText() 
		{
			
		 textScore = new Text("SCORE: 0", 0, 0);
		 textLives = new Text("LIVES: 0", 230, 0);
		 textShadowScore = new Text("SCORE: 0", 1, 1);
		 textShadowLives = new Text("LIVES: 0", 231, 1);	
		 
		 textShadowScore.color = 0x000000;
		 textShadowLives.color = 0x000000;
		 
		 textScore.size = textShadowScore.size = textShadowLives.size = textLives.size = 8;
		 textLives.scrollX = textLives.scrollY = 0;
		 textScore.scrollX = textScore.scrollY = 0;
		 textShadowScore.scrollX = textShadowScore.scrollY = 0;
		 textShadowLives.scrollX = textShadowLives.scrollY = 0;
		  
			glistInfoText = new Graphiclist();
			glistInfoText.add(textShadowLives);
			glistInfoText.add(textShadowScore);
			glistInfoText.add(textLives);
			glistInfoText.add(textScore);


		 
		 
		 addGraphic(glistInfoText);
		 
		 layer = 1;
		 x = 0;
		 y = 0;
		}
		
		override public function update():void
		{
			textScore.text = textShadowScore.text = "SCORE: " + score;
			textLives.text = textShadowLives.text = "LIVES: " + lives;
		}
	}

}