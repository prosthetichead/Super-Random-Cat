package  
{
	
	import net.flashpunk.Entity;
	import net.flashpunk.masks.Grid;
	
	public class CollisionGrid extends Entity
	{
		private var gridCollision:Grid;
		
		public function CollisionGrid(gridW:int, gridH:int, tileW:int, tileH:int, type:String = "collisionGrid") 
		{
		gridCollision = new Grid(gridW, gridH, tileW, tileH, x, y);
		
		this.type = type;
		//setHitbox(16, 16);
		
		collidable = true;
		mask = gridCollision;
		}
		
		
		override public function update():void
		{
			//y += 1
		}
		
		public function addSolidRect(rectX:int, rectY:int, rectW:int, rectH:int):void
		{
			gridCollision.setRect(rectX, rectY, rectW, rectH, true);
			
		}
	}

}