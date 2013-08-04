package com.pdf.event
{
	import flash.events.Event;
	import com.pdf.region.RegionSelector;
	
	public class RegionSelectorEvent extends Event
	{
		public var regionSelector:RegionSelector;
		
		public function RegionSelectorEvent(type:String, regionSelector:RegionSelector)
		{
			super(type);
			this.regionSelector = regionSelector;
		}
		
		override public function clone():Event{
			return new RegionSelectorEvent(type, regionSelector);
		}
	}
}