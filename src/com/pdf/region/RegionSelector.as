package com.pdf.region
{
	import com.pdf.event.RegionSelectorEvent;
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import spark.components.SkinnableContainer;
	
	
	[Event(name="regionSelectorTypeChange", type="com.pdf.event.RegionSelectorEvent")]
	[Event(name="removeRegionSelection", type="com.pdf.event.RegionSelectorEvent")]
	public class RegionSelector extends SkinnableContainer
	{
		
		[Bindable]
		public var headerBackgroundColor:uint;
		[Bindable]
		public var headerText:String;
		[Bindable]
		public var borderColor:uint;
		
		private var _type:String;
		
		private var menu:ContextMenu = new ContextMenu;
		
		public function RegionSelector(x:int = 0, y:int = 0, height:int = 0, width:int = 0)
		{
			super();
			this.x = x;
			this.y = y;
			this.height = height;
			this.width = width;
			
			setStyleByType(RegionSelectionType.PARAGRAPH);
			
			contextMenu = menu;
			contextMenu.hideBuiltInItems();
			
			var paragraphMenuItem:ContextMenuItem = new ContextMenuItem(RegionSelectionType.PARAGRAPH_LABEL);
			paragraphMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, setParagraphEventHandler);
			
			var listMenuItem:ContextMenuItem = new ContextMenuItem(RegionSelectionType.LIST_LABEL);
			listMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, setListEventHandler);
			
			var tableMenuItem:ContextMenuItem = new ContextMenuItem(RegionSelectionType.TABLE_LABEL);
			tableMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, setTableEventHandler);
			
			var imageMenuItem:ContextMenuItem = new ContextMenuItem(RegionSelectionType.IMAGE_LABEL);
			imageMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, setImageEventHandler);
			
			var textWithLineBreakMenuItem:ContextMenuItem = new ContextMenuItem(RegionSelectionType.TEXT_WITH_LINE_BREAK_LABEL);
			textWithLineBreakMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, setTextLineBreakEventHandler);
			
			var removeMenuItem:ContextMenuItem = new ContextMenuItem("Remove");
			removeMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, removeEventHandler);
			
			contextMenu.customItems.push(paragraphMenuItem, listMenuItem, tableMenuItem, imageMenuItem, textWithLineBreakMenuItem, removeMenuItem);
		}
		
		[Bindable]
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{			
			_type = value;
			setStyleByType(value);
		}
		
		public function setStyleByType(selectionType:String):void
		{
			if(selectionType == RegionSelectionType.PARAGRAPH)
			{
				headerBackgroundColor = 0x2AA83D;
				headerText = RegionSelectionType.PARAGRAPH_LABEL;
				_type = RegionSelectionType.PARAGRAPH;
				borderColor = 0xAD4123;
			}
			else if(selectionType == RegionSelectionType.LIST)
			{
				headerBackgroundColor = 0x3924F2;
				headerText = RegionSelectionType.LIST_LABEL;
				_type = RegionSelectionType.LIST;
				borderColor = 0x229FF2;
			}
			else if(selectionType == RegionSelectionType.IMAGE)
			{
				headerBackgroundColor = 0xC02FF5;
				headerText = RegionSelectionType.IMAGE_LABEL;
				_type = RegionSelectionType.IMAGE;
				borderColor = 0x1B0324;
			}
			else if(selectionType == RegionSelectionType.TEXT_WITH_LINE_BREAK)
			{
				headerBackgroundColor = 0x303875;
				headerText = RegionSelectionType.TEXT_WITH_LINE_BREAK_LABEL;
				_type = RegionSelectionType.TEXT_WITH_LINE_BREAK;
				borderColor = 0x497A2C;
			}
			else if(selectionType == RegionSelectionType.TABLE)
			{
				headerBackgroundColor = 0x4C4F4F;
				headerText = RegionSelectionType.TABLE_LABEL;
				_type = RegionSelectionType.TABLE;
				borderColor = 0x181A18;
			}
			dispatchEvent(new RegionSelectorEvent("regionSelectorTypeChange",this));
		}
		protected function setParagraphEventHandler(event:ContextMenuEvent):void
		{
			setStyleByType(RegionSelectionType.PARAGRAPH);
		}
		
		protected function setListEventHandler(event:ContextMenuEvent):void
		{
			setStyleByType(RegionSelectionType.LIST);
		}
		protected function setTableEventHandler(event:ContextMenuEvent):void
		{
			setStyleByType(RegionSelectionType.TABLE);
		}
		protected function setImageEventHandler(event:ContextMenuEvent):void
		{
			setStyleByType(RegionSelectionType.IMAGE);
		}
		protected function setTextLineBreakEventHandler(event:ContextMenuEvent):void
		{
			setStyleByType(RegionSelectionType.TEXT_WITH_LINE_BREAK);
		}
		
		protected function removeEventHandler(event:ContextMenuEvent):void
		{
			parent.removeChild(this);
			dispatchEvent(new RegionSelectorEvent("removeRegionSelection",this));
		}
		
		override public function stylesInitialized():void
		{
			super.stylesInitialized();
			this.setStyle("skinClass",Class(RegionSelectorSkin));
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