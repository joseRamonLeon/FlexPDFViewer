package com.pdf.xml
{
	[XmlClass(alias="Region")]
	public class Region
	{
		[XmlAttribute] 
		public var x:int;
		[XmlAttribute] 
		public var y:int;
		[XmlAttribute] 
		public var width:int;
		[XmlAttribute] 
		public var height:int;
		[XmlAttribute] 
		public var type:String;
		
		[Bindable]
		[XmlElement(alias="HtmlContent")]
		public var htmlContent:String = null;
	}
}