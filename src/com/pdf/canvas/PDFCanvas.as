package com.pdf.canvas
{
	import com.pdf.*;
	import com.pdf.event.*;
	import com.pdf.region.*;
	import com.pdf.xml.*;
	
	import flash.display.AVM1Movie;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.controls.ProgressBarMode;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;


	/**
	 * This calss dispatch some events-
	 * dispatched events are:
	 * 1.	unRecognizedFileType event, 
	 * 2.	securityErrorEvent, 
	 * 3.	IOErrorEvent
	 * 
	 * */
	[Event(name="unRecognizedFileType", type = "flash.events.Event")]
	public class PDFCanvas extends SelectionCanvas
	{
		private var fLoader:ForcibleLoader = new ForcibleLoader;
		private var progressBar:CustomProgressBar = new CustomProgressBar;
		private var movieClip:MovieClip = new MovieClip;
		private var configPages:Pages = new Pages;  
		
		[Bindable]
		public var noOfPages:int = 1;
		[Bindable]
		public var currentPageNo:int = 1;
		[Bindable]
		private var _regionConfigContent:String = "";

		public function get regionConfigContent():String
		{
			return configPages.pdfXML.toXMLString();
		}
		
		public function set regionConfigContent(value:String):void
		{
			_regionConfigContent = value;
		}
		
		public function PDFCanvas()
		{
			super();
			
			/**
			 * Setting progress bar manual so that we 
			 * can set lable and progress manually
			 * */
			progressBar.mode = ProgressBarMode.MANUAL;
			
		

			/**
			 * Adding eventListener
			 * 1.	startup
			 * 2.	progress
			 * 3.	complete loading
			 * 4.	ioError/fileNotFoundError
			 * 5.	security error if not access the url
			 * 6.	A region selection complete event
			 * */
			fLoader.addEventListener(Event.OPEN, function(event:Event):void{});
			fLoader.addEventListener(ProgressEvent.PROGRESS, fLoader_progressEventHandler);
			fLoader.addEventListener(Event.COMPLETE, fLoader__completeEventHandler);
			fLoader.addEventListener(IOErrorEvent.IO_ERROR,function(event: IOErrorEvent):void
			{
				dispatchEvent(event);
				PopUpManager.removePopUp(progressBar);
			});
			fLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(event:SecurityErrorEvent):void
			{
				dispatchEvent(event);
				PopUpManager.removePopUp(progressBar);
			});
			
			addEventListener("selectionComplete", pdfCanvas_selectionCompleteEventHandler);
		}
		
		public function loadFile(documentURL:String, regionConfigContent:String = null):void
		{
			/**
			 *Add a progressbar before loading a file 
			 * */
			PopUpManager.addPopUp(progressBar, FlexGlobals.topLevelApplication.valueOf(), true);
			PopUpManager.centerPopUp(progressBar);
			progressBar.setProgress(0, 0);
			
			this._regionConfigContent = regionConfigContent;
			
			/**
			 * Loading a file from the url
			 * */
			fLoader.loadFromURL(documentURL);
			
			/**
			 * Add the file in the canvas
			 * */
			addChild(fLoader.loader);
		}
		public function nextPage():void
		{
			if( currentPageNo < noOfPages )
			{
				currentPageNo ++;
				clearAllSelection();
				drawPageRegion();
				movieClip.nextFrame();
			}
		}
		
		public function prevPage():void 
		{
			if( currentPageNo > 1 )
			{
				currentPageNo --;
				clearAllSelection();
				drawPageRegion();
				movieClip.prevFrame();
			}
		}
		private function fLoader__completeEventHandler(event:Event):void
		{
			clearAllSelection();
			/**
			 * Remove progress bar after loading file
			 * */
			PopUpManager.removePopUp(progressBar);
			
			/**
			 * Loading stared here so show the first page
			 * */
			currentPageNo = 1;
			
			/**
			 * event.currentTarge.content is MovieClip when
			 * the docuemnt is multipage
			 * single page docuement is AVM1Movie
			 * */
			if(event.currentTarget.content is MovieClip)
			{
				/**
				 * stop the movie clip in first page
				 * and set height and width
				 * */
				movieClip = event.currentTarget.content as MovieClip;
				movieClip.gotoAndStop(1);
				
				/**
				 * No of pages
				 * */
				noOfPages = movieClip.totalFrames;
				
				height = movieClip.height;
				width = movieClip.width;
				
				
			}
			else if(event.currentTarget.content is AVM1Movie)
			{
				/**
				 * Set canvas height and width
				 * */
				var avm1Movie:AVM1Movie = event.currentTarget.content as AVM1Movie;
				height = avm1Movie.height;
				width = avm1Movie.width;
				
				noOfPages = 1;
			}
			else
			{
				dispatchEvent(new Event("unRecognizedFileType"));
			}
			
			
			/**
			 * If a file has no config file then we will initialize
			 * otherwise setting the config 
			 * */
			if(_regionConfigContent == null || _regionConfigContent == "")
			{
				initConfigFile();
			}
			else
			{
				configPages.pdfXML = XML(_regionConfigContent);
			}
			drawPageRegion();
		}

		private function fLoader_progressEventHandler(event:ProgressEvent):void
		{
			/**
			 * Progress bar showing porgress
			 * and set the label of percentage of loading
			 * */
			progressBar.setProgress(event.bytesLoaded, event.bytesTotal);
			progressBar.label = Math.round(event.bytesLoaded / event.bytesTotal * 100) + "%";
		}
		
		protected function pdfCanvas_selectionCompleteEventHandler(event:RegionSelectorEvent):void
		{
			/**
			 * Adding a shape after selecting a region
			 * */
			var regionSelector:RegionSelector = event.regionSelector; 
			addChild(regionSelector);
			
			var region:Region = new Region;
			region.x = regionSelector.x;
			region.y = regionSelector.y;
			region.height = regionSelector.height;
			region.width = regionSelector.width;
			region.type = regionSelector.type;
			
			currentPage.regionList.addItem(region);
		}
		
		private function get currentPage():Page
		{
			return configPages.pageList.getItemAt( currentPageNo - 1 ) as Page;
		}
		
		private function drawPageRegion():void
		{
			for each (var selectedRegion:Region in currentPage.regionList) 
			{
				
				var regionSelector:RegionSelector = new RegionSelector;
				regionSelector.x = selectedRegion.x;
				regionSelector.y = selectedRegion.y;
				regionSelector.height = selectedRegion.height;
				regionSelector.width = selectedRegion.width;
				regionSelector.type = selectedRegion.type;
				
				addChild(regionSelector);
			}
			
		}
		
		private function clearAllSelection():void
		{
			/**
			 * Clear all selection which are RegionSelector type
			 * */
			for(var i:int = numChildren - 1; i >= 0; i --)
			{
				if(getChildAt(i) is RegionSelector)
				{
					removeChildAt(i);
				}
			}
		}
		
		private function initConfigFile():void
		{
			configPages = new Pages;
			/**
			 * Initialzie pages
			 * */
			for (var i:int = 0; i < noOfPages; i ++)
			{
				var page:Page = new Page;
				page.no = i + 1;
				configPages.pageList.addItem(page);
			}
			
			/**
			 * setting the new pages config the the config region  
			 * */
			_regionConfigContent = configPages.pdfXML.toXMLString();
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