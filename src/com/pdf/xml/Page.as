package com.pdf.xml
{
	import mx.collections.ArrayCollection;

	[XmlClass(alias="Page")]
	public class Page
	{
		private var region:Region = new Region;
		
		[XmlAttribute] 
		public var no:int;
		
		[Bindable]
		[XmlArray(alias="*", memberName="Region", type="com.pdf.xml.Region")]
		public var regionList:ArrayCollection = new ArrayCollection;
	}
}