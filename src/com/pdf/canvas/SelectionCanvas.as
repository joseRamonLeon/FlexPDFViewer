package com.pdf.canvas
{
	import com.pdf.event.RegionSelectorEvent;
	import com.pdf.region.RegionSelector;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;

	/**
	 * This class dispatched only one event
	 * the evnet is:
	 * 1.	selectionComplete Event
	 * this event occurs when user selects a region
	 * */
	[Event(name="selectionComplete", type="com.pdf.event.RegionSelectorEvent")]
	public class SelectionCanvas extends UIComponent
	{
		private var startPoint:Point;
		private var drawLayer:Sprite;
		private var selectionLeft:int;
		private var selectionTop:int;
		private var selectionWidth:int;
		private var selectionHeight:int;
		
		private var MIN_SELECTION_HEIGHT:int = 10;
		private var MIN_SELECTION_WIDTH:int = 10;
		
		public function SelectionCanvas()
		{
			super();
			/**
			 * adding mouse down event and adding stage
			 * user will be able to selects within a coordinate from the pdfcanvas
			 * but he can relase mouse outside of the pdfcanvas
			 * so we have to determine mouse release inside or outside of pdfcanvas
			 * so we add the stage so that we can get any coordinate of the application
			 * */
			addEventListener(MouseEvent.MOUSE_DOWN, selectionCanvas_mouseDownEventHandler);
			addEventListener(Event.ADDED_TO_STAGE, function ():void{});
		}
		
		protected function selectionCanvas_mouseDownEventHandler(event:MouseEvent):void
		{
			/**
			 * drawLayer is a layer where we draw the selection
			 * and after completing the drawing we will remove this layer
			 * */
			drawLayer = new Sprite();
			addChild(drawLayer);
			
			/**
			 * selection region initialize
			 * */
			selectionLeft = 0;
			selectionTop = 0;
			selectionHeight = 0;
			selectionWidth = 0;
			
			/**
			 * Start Point wehre mouse click
			 * */
			startPoint = new Point(event.stageX, event.stageY);
			
			/**
			 * adding mouse move and mouse release event
			 * we will remove those event after releaseing mouse
			 * */
			addEventListener(MouseEvent.MOUSE_MOVE, selectionCanvas_mouseMoveEventHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, selectionCanvas_mouseUpEventHandler);
		}
		
		protected function selectionCanvas_mouseMoveEventHandler(event:MouseEvent):void
		{
			/**
			 * clear drawing layer
			 * */
			drawLayer.graphics.clear();
			drawLayer.graphics.lineStyle(1, 0x000000);
			
			/**
			 * convert selection canvas cooridnate (local coordinate) from global coordinate system 
			 * */
			var localStartPoint:Point = globalToLocal(startPoint);
			var localEndPoint:Point = globalToLocal(new Point(event.stageX, event.stageY));
			
			/**
			 * Calculate top, left, height and width
			 * */
			selectionTop = Math.min(localEndPoint.y, localStartPoint.y);
			selectionLeft = Math.min(localEndPoint.x, localStartPoint.x);
			selectionWidth = Math.abs(localEndPoint.x - localStartPoint.x);
			selectionHeight = Math.abs(localEndPoint.y - localStartPoint.y);
			
			/**
			 * drawing rectangle
			 * */
			drawLayer.graphics.drawRect(selectionLeft, selectionTop, selectionWidth, selectionHeight);
			
		}
		protected function selectionCanvas_mouseUpEventHandler(event:MouseEvent):void
		{
			/**
			 * remove drawlayer from the canvas
			 * */
			for(var i:int = numChildren - 1; i >= 0; i -- )
			{
				if(getChildAt(i) == drawLayer)
				{
					removeChildAt(i);
				}
			}
			
			/**
			 * dispatch selection complete evnet if there is a
			 * drawing shape in the canvas
			 * */
			if(selectionHeight > MIN_SELECTION_HEIGHT && selectionWidth > MIN_SELECTION_WIDTH)
			{
				var regionSelector:RegionSelector = new RegionSelector(selectionLeft, selectionTop, selectionHeight, selectionWidth);
				dispatchEvent(new RegionSelectorEvent("selectionComplete", regionSelector));
			}
			
			/**
			 * removing the mouse move and release evnet
			 * */
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