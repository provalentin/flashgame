package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	public class Game extends Sprite
	{
		
		[Embed(source="../images/c1.png")]
		private var Photo:Class;
		
		public function Game()
		{
			trace("first message");
			bitmapEmbedder();
		}
		
		public function bitmapEmbedder ():void {
			// Create an instance of the embedded bitmap 
			var photo:Bitmap = new Photo() as Bitmap; 
			addChild(photo); 
			trace(photo.bitmapData.getPixel(0, 0));
		}
	}
}