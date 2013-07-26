

//#  box.as
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
 import flash.events.EventDispatcher;
 import flash.events.IEventDispatcher;
 import mx.core.UIComponent;
 import mx.containers.Canvas;
 import mx.collections.ArrayCollection;
 import com.htmlFilter.debug;

 public class box extends Canvas
 {
  public static const ROW:String = "row";
  public static const SROW:String = "srow";
  public static const CELL:String = "cell";
  public static const TEXT:String = "text";
  public static const PLACE:String = "placeHolder";
  public static const FWPLACE:String = "fullWidthPlaceHolder";
  public static const OPAQUE:String = "opaque";

  public var theItems:ArrayCollection;

  private var type:String;
  private var numItems:Number;

  public function box(inType:String=PLACE, width:Number=20, height:Number=100)
  {
   type = inType;
   horizontalScrollPolicy="off";
   verticalScrollPolicy="off";
   alpha = 0.9;
   switch (type)
   {
    case ROW :
     styleName = "tableRow";
     percentWidth=100;
     break;
    case CELL :
     //handled in htmlTable.as -> htmlCell -> getDisplay()
     percentWidth=100;
     alpha = 0.7;
     break;
    case PLACE :
     percentWidth=width;
     percentHeight=100;
     styleName = "placeHolder";
     break;
    case FWPLACE:
     percentWidth=100;
     height=10;
     styleName = "placeHolder";
     break;
    case OPAQUE:
     percentWidth=100;
     height=10;
     styleName = "placeHolder";
     alpha = 1.0;
     break;
    case TEXT :
    case SROW :
     styleName = "plain";
     percentWidth=100;
     break;
   }


  }

  override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
  {
      super.updateDisplayList(unscaledWidth, unscaledHeight);

      var xOfComp:Number = 0;

      var obj:UIComponent;

      var i:int;

      switch (type)
      {
       case TEXT :
       case SROW :
       case CELL :

     for (i = 0; i < numChildren; i++)
     {
      obj = UIComponent(getChildAt(i));
      obj.setActualSize(obj.width, obj.height+5);
     }
     for (i = 0; i < numChildren; i++)
     {
      obj = UIComponent(getChildAt(i));
      obj.move(xOfComp, obj.y);
      xOfComp = xOfComp + obj.width;
     }
     break;

          case ROW :

           var colspan:Number;
           var width:Number;
           var widthLeft:Number = unscaledWidth;

     if (numChildren > numItems)
     {
      numItems = numChildren;
     }

           var numItemsLeft:Number = numItems;

     for (i = 0; i < numChildren; i++)
     {
      obj = UIComponent(getChildAt(i));
      colspan = theItems.getItemAt(i).Colspan;
      width = theItems.getItemAt(i).Width;
      if (width == -1)
      {
       width = (widthLeft / numItemsLeft) * colspan
      }
      else
      {
       width = width
      }
      widthLeft -= width
      numItemsLeft -= 1
      obj.setActualSize(width, unscaledHeight);
     }
     for (i = 0; i < numChildren; i++)
     {
      colspan = theItems.getItemAt(i).Colspan
      obj = UIComponent(getChildAt(i));
      obj.move(xOfComp, obj.y);
      xOfComp = xOfComp + obj.width;
     }

     break;
      }

  }

  public function set NumItems (inNum:Number):void
  {
   numItems = inNum;
  }
 }
}
