package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	[SWF(width = "640", height = "480", backgroundColor = "#000000")]

	public class Main extends Engine
	{
		
		
		public function Main()
		{
			super(320, 240, 60, false);
			FP.world = new Game;
			FP.screen.color = 0x3399cc;
			FP.screen.scale = 2;
			
			FP.console.enable();
		}
		
		override public function init():void 
		{
			
		}
	}
}