

//#  tableWrapper.as
//#  
//#  Author : Stephen Moore - delfick755@gmail.com
//#  
//#  This program is free software; you can redistribute it and/or modify
//#  it under the terms of the GNU General Public License as published by
//#  the Free Software Foundation; either version 2 of the License, or
//#  (at your option) any later version.
//#   
//#  This program is distributed in the hope that it will be useful,
//#  but WITHOUT ANY WARRANTY; without even the implied warranty of
//#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//#  GNU General Public License for more details.
//#   
//#  You should have received a copy of the GNU General Public License
//#  along with this program; if not, write to the Free Software
//#  Foundation, Inc., 59 Temple Place, Suite 330,
//#  Boston, MA 02111-1307, USA.



package com.htmlFilter
{
 import mx.containers.Canvas;
 import flash.text.StyleSheet;
 import mx.core.UIComponent;
 import qs.controls.SuperImage;
 import mx.core.EdgeMetrics;
 import com.htmlFilter.debug;

 import com.htmlFilter.box;
 import mx.containers.*;

 public class objectWrapper extends Canvas
 {

  private var middleWidth:Number;
  private var boxWidth:Number;
  private var startWidth:Number;
  private var endWidth:Number;
  private var specialWidth:Number = 0;
  private var totalWidth:Number;
  private var theType:String;
  private var vScroll:String;

  public function objectWrapper (inPart:Object, inStyles:StyleSheet, inWidth:Number, type:String, inTotalWidth:Number, hasVScroll:String)
  {
   vScroll = hasVScroll
   theType = type;
   totalWidth = inTotalWidth;
   width = inTotalWidth

   inWidth = inWidth;

   var newObject:*;

   if (inWidth == 0)
   {
    inWidth = 95;
   }

   if (inPart.width != null)
   {
    specialWidth = inPart.width;
   }

   middleWidth = inWidth;
   boxWidth = (100-inWidth)/2;

   var emptyBox1:box = new box(box.PLACE, boxWidth);
  //	emptyBox1.setStyle("backgroundColor", "0xF56FFF");
   var emptyBox2:box = new box(box.PLACE, boxWidth);
  //	emptyBox2.setStyle("backgroundColor", "0x000FFF");


   switch (type)
   {
    case "table" :
     newObject = new htmlTable(inPart, inStyles, inWidth);
     break;

    case "image" :
     newObject = new SuperImage();
     newObject.source = inPart.src;
     inPart.width == null
     ?
      newObject.percentWidth = 95
     :
      newObject.width = inPart.width;
     newObject.cacheName = inPart.cacheName;
     newObject.setStyle("borderStyle", "none");
     break;
    default:
     debug.trace("bad object wrapper type", type);
     break;
   }
   addChild(emptyBox1);

   addChild(newObject);

   addChild(emptyBox2);

  }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            var vm:EdgeMetrics = viewMetricsAndPadding;

            var xOfComp:Number = 0;

            var theWidth:Number = unscaledWidth;

            var middle:UIComponent = null;
            var start:UIComponent = null;
            var end:UIComponent = null;
            var emptyBoxWidth:Number;

            if (numChildren == 3)
            {
             if (unscaledWidth > totalWidth && theType != "image")
             {
              theWidth = totalWidth;
             }
          if (specialWidth != 0)
          {
           middleWidth = (specialWidth / theWidth) * 100;
           boxWidth = (100-middleWidth)/2
          }
            }



            if (vScroll == "on" && middleWidth > 95)
            {
             startWidth = boxWidth/1.8;
             endWidth = 100-(startWidth + middleWidth);
            }
            else
            {
          startWidth = boxWidth;
          endWidth = boxWidth;
            }

            if (numChildren == 3)
            {
             start = UIComponent(getChildAt(0));
             middle = UIComponent(getChildAt(1));
             end = UIComponent(getChildAt(2));

          start.setActualSize(theWidth * (startWidth/100), middle.height);
          start.move(0, 0);

          middle.setActualSize(theWidth * (middleWidth/100), middle.height);
          middle.move(theWidth * (startWidth/100), 0);

          end.setActualSize(theWidth * (endWidth/100), middle.height);
          end.move(theWidth * ((startWidth+ middleWidth)/100), 0);

            }
        }
 }


}
