package com.pdf.canvas
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import com.pdf.region.RegionSelector;
	import com.pdf.event.RegionSelectorEvent;

	[Event(name="selectionComplete", type="com.pdf.event.RegionSelectorEvent")]
	public class SelectionCanvas extends UIComponent
	{
		private var startPoint:Point;
		private var drawLayer:Sprite;
		private var selectionLeft:int;
		private var selectionTop:int;
		private var selectionWidth:int;
		private var selectionHeight:int;
		
		public function SelectionCanvas()
		{
			super();
			addEventListener(MouseEvent.MOUSE_DOWN, selectionCanvas_mouseDownEventHandler);
			addEventListener(Event.ADDED_TO_STAGE, function ():void{});
		}
		
		protected function selectionCanvas_mouseDownEventHandler(event:MouseEvent):void
		{
			drawLayer = new Sprite();
			addChild(drawLayer);
			
			selectionLeft = 0;
			selectionTop = 0;
			selectionHeight = 0;
			selectionWidth = 0;
			
			startPoint = new Point(event.stageX, event.stageY);
			addEventListener(MouseEvent.MOUSE_MOVE, selectionCanvas_mouseMoveEventHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, selectionCanvas_mouseUpEventHandler);
		}
		
		protected function selectionCanvas_mouseMoveEventHandler(event:MouseEvent):void
		{
			drawLayer.graphics.clear();
			drawLayer.graphics.lineStyle(1, 0x000000);
			
			var localStartPoint:Point = globalToLocal(startPoint);
			var localEndPoint:Point = globalToLocal(new Point(event.stageX, event.stageY));
			
			selectionTop = Math.min(localEndPoint.y, localStartPoint.y);
			selectionLeft = Math.min(localEndPoint.x, localStartPoint.x);
			selectionWidth = Math.abs(localEndPoint.x - localStartPoint.x);
			selectionHeight = Math.abs(localEndPoint.y - localStartPoint.y);
			
			drawLayer.graphics.drawRect(selectionLeft, selectionTop, selectionWidth, selectionHeight);
			
		}
		protected function selectionCanvas_mouseUpEventHandler(event:MouseEvent):void
		{
			for(var i:int = numChildren - 1; i >= 0; i -- )
			{
				if(getChildAt(i) == drawLayer)
				{
					removeChildAt(i);
				}
			}
			if(selectionHeight > 10 && selectionWidth > 10)
			{
				var regionSelector:RegionSelector = new RegionSelector(selectionLeft, selectionTop, selectionHeight, selectionWidth);
				dispatchEvent(new RegionSelectorEvent("selectionComplete", regionSelector));
			}
			
			removeEventListener(MouseEvent.MOUSE_MOVE, selectionCanvas_mouseMoveEventHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, selectionCanvas_mouseUpEventHandler);
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.clear();
			graphics.beginFill(0xFFFFFF, 0.0000001);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
		}
	}
}