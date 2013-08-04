package com.pdf.xml
{
	import com.googlecode.flexxb.FlexXBEngine;
	
	import mx.collections.ArrayCollection;

	[XmlClass(alias="Pages")]
	public class Pages
	{
		private var page:Page = new Page;
		
		[Bindable]
		[XmlArray(alias="*", memberName="Page", type="com.pdf.xml.Page")]
		public var pageList:ArrayCollection = new ArrayCollection;
		
		private var _pdfXML:XML;
		
		public function set pdfXML(value:XML):void
		{
			var pages:Pages =  FlexXBEngine.instance.deserialize(value, Pages);;
			pageList = pages.pageList;
			_pdfXML = value;
		}
		
		public function get pdfXML():XML
		{
			_pdfXML = FlexXBEngine.instance.serialize(this);
			return _pdfXML;
		}
	}
	
}