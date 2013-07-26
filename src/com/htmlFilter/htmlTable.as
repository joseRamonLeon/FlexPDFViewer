

//#  htmlTable.as
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


 public class htmlTable extends Canvas
 {
  import flash.events.Event;
  import mx.collections.ArrayCollection;
  import mx.core.UIComponent;
  import mx.core.EdgeMetrics;
  import flash.events.MouseEvent;
  import com.htmlFilter.text;
  import mx.containers.HBox;
  import com.htmlFilter.box;
  import com.htmlFilter.tagsAndOptions;
  import com.htmlFilter.debug;

  private var theRows:ArrayCollection = new ArrayCollection();
  private var currentRow:Number = 0;
  private var theText:String;
  private var theInfo:Object;
  private var styles:StyleSheet;
  private var theClass:String = null;
  private var doReference:Boolean = false;

  public function htmlTable (inInfo:Object, inStyles:StyleSheet, width:Number)
  {
   super();

   htmlRow.maxCells = 0;
   styles = inStyles;
   horizontalScrollPolicy="off";

   var tableTag:Array = new Array();
   tableTag = tagsAndOptions.findTagStart("table", inInfo.Text);

   theClass = tagsAndOptions.getOption(tableTag.options, "class");

   percentWidth = width;

   if (tableTag != null)
   {
    var theWidth:String = tagsAndOptions.getOption(tableTag.options, "width");
    if (theWidth != null)
    {
     if (theWidth.charAt(theWidth.length-1) == "%")
     {
      percentWidth = Number(theWidth.slice(0, -1));
     }
     else
     {
      width = Number(theWidth);
     }
    }
   }
   theInfo = inInfo;
   theInfo.Text = theInfo.Text.replace("</table>", "");

   findRows(theInfo.Text);

      var foundCaption:Array = tagsAndOptions.findTag("caption", theInfo.Text);
   if (foundCaption != null)
   {
    addCaption(foundCaption.value);
   }

            for each (var row:Object in theRows)
            {
             row.fillCells();
             addChild(row.getDisplay(width));
            }

      var foundReference:Array = tagsAndOptions.findTag("reference", theInfo.Text);
   if (foundReference != null)
   {
    addReference(foundReference.value, foundReference.options);
    doReference = true;
   }
  }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            var vm:EdgeMetrics = viewMetricsAndPadding;

            var yOfComp:Number = 0;

            var xOfComp:Number = 0;

            var toX:Number;

            var obj:UIComponent;

            var i:int;

            var extra:Number = -1;

         for (i = 0; i < numChildren; i++)
         {
             obj = UIComponent(getChildAt(i));
             obj.move(obj.x, yOfComp);
             if (i == numChildren-2)
             {
              doReference ? extra = 0 : extra = -1;
             }
             else
             {
              extra = -1;
             }
             yOfComp = yOfComp + obj.height + extra;
         }

        }

        private function findRows(inText:String):void
        {
         theRows = new ArrayCollection();
         currentRow = -1;
         var tags:RegExp = new RegExp("<(?P<tag>[^<>]*)>", "g");
   var result:Array = tags.exec(inText);
   var prevPart:Object;

   while (result != null)
   {
    if (result.tag.substr(0,2) == "tr")
    {
     if (currentRow > -1)
     {
      prevPart = theRows.getItemAt(currentRow);
      prevPart.Text = inText.substring(prevPart.StartIndex, result.index);
     }
     theRows.addItem(new htmlRow(result.index, styles));
           currentRow++;

    }
    else if (result.tag == "/tr")
    {
     prevPart = theRows.getItemAt(currentRow);
     prevPart.TableClass = theClass;
     prevPart.Text = inText.substring(prevPart.StartIndex, result.index + result[0].length);
    }
    result = tags.exec(inText);
   }

   prevPart = theRows.getItemAt(currentRow);
   if (inText != null)
   {
    prevPart.Text = inText.substring(prevPart.StartIndex, inText.length);
   }
   else
   {
    prevPart.Text = "This table is loading";
   }
        }

        private function addCaption(inCaption:String):void
        {
         var cellBox:box = new box(box.TEXT);
      var newTextField:com.htmlFilter.text = new com.htmlFilter.text(); { newTextField.selectable=true; newTextField.condenseWhite=false; newTextField.percentWidth = 100; newTextField.setStyle("paddingLeft", 10); newTextField.setStyle("paddingRight", 10); newTextField.setStyle("paddingTop", 0); newTextField.setStyle("paddingBottom", 0); };
   newTextField.setStyle("paddingTop", 5);
   newTextField.htmlText = "<span class='htmlTableCaption'>" + inCaption + "</span>";
   cellBox.addChild(newTextField);
   addChild(cellBox);
   newTextField.setStyleSheet(styles);
        }

        private function addReference(inCaption:String, inOptions:String):void
        {
         var type:String = "text";
         var showAs:String = "";

         var theOptions:ArrayCollection = tagsAndOptions.findOptions(inOptions);

         for each (var option:Array in theOptions)
         {
          switch (option.optionName)
          {
           case "type" :
            type = option.optionValue;
            break;
           case "showAs" :
            showAs = option.optionValue
            break;
          }
         }

   if (type == "webAddress")
   {
    showAs == ""
    ?
     inCaption = "Reference : <a href=\"" + inCaption + "\">" + inCaption + "</a>"
    :
     inCaption = "Reference : <a href=\"" + inCaption + "\">" + showAs + "</a>";
   }

   addCaption(inCaption);
        }
 }
}

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.UIComponent;
import mx.containers.HBox;
import mx.collections.ArrayCollection;
import mx.containers.Canvas
import flash.text.StyleSheet;
import com.htmlFilter.text;
import com.htmlFilter.tagsAndOptions;
import com.htmlFilter.box;
import com.htmlFilter.special.*;
import qs.controls.SuperImage;
import com.htmlFilter.debug;

class htmlRow extends EventDispatcher implements IEventDispatcher
{

 public static var maxCells:Number = 0;

 private var theStartIndex:Number;
 private var theText:String;
 private var numCells:Number;
 private var styles:StyleSheet;

 private var theCells:ArrayCollection = new ArrayCollection;
 private var currentCell:Number;
 private var tClass:String = null;

    public function htmlRow(inIndex:Number, inStyles:StyleSheet)
    {
     theStartIndex = inIndex;
     styles = inStyles;
     theText = null;
     numCells = 0;
    }

    public function getDisplay(inWidth:Number):UIComponent
    {
  var rowBox:box = new box(box.ROW);
  if (TableClass != null)
  {
   rowBox.styleName = "tableRow" + TableClass
  }

  rowBox.theItems = theCells;
  rowBox.NumItems = numCells;
  for each (var cell:Object in theCells)
  {
   rowBox.addChild(cell.getDisplay(inWidth))
  }
  return rowBox;
    }

    public function fillCells():void
    {
     for ( var i:Number = 0;i< (maxCells - numCells);i++)
     {
      theCells.addItem(new htmlCell(TableClass, 0, numCells+i, styles));
     }
    }

    private function findCells(inText:String):void
    {
     numCells = 0;
     theCells = new ArrayCollection();
     currentCell = -1;
     var tags:RegExp = new RegExp("<(?P<tag>[^<>]*)>", "g");
  var result:Array = tags.exec(inText);
  var prevPart:Object;

  var colspan:Number = 1;
  var pattern:RegExp;
  var foundColspan:Array;
  var foundAlign:Array;
  var align:String = "left";

  while (result != null)
  {
   if (result.tag.substr(0,2) == "td")
   {
    colspan = 1;
    theCells.addItem(new htmlCell(TableClass, result.index, numCells, styles));
    currentCell++;
    theCells.getItemAt(currentCell).theOptions = tagsAndOptions.findOptions(result[0]);
       numCells += colspan;
   }
   else if (result.tag.substr(0,2) == "th")
   {
    colspan = 1;
    theCells.addItem(new htmlCell(TableClass, result.index, numCells, styles, "th"));
    currentCell++;
    theCells.getItemAt(currentCell).theOptions = tagsAndOptions.findOptions(result[0]);
    numCells+=colspan;
   }
   else if (result.tag == "/td")
   {
    prevPart = theCells.getItemAt(currentCell);
    prevPart.setText(inText.substring(prevPart.StartIndex, result.index + result[0].length));
   }
   else if (result.tag == "/th")
   {
    prevPart = theCells.getItemAt(currentCell);
    prevPart.setText(inText.substring(prevPart.StartIndex, result.index + result[0].length));
   }
   result = tags.exec(inText);
  }

  maxCells = (maxCells > numCells? maxCells : numCells);

  prevPart = theCells.getItemAt(currentCell);
  if (inText != null)
  {
   prevPart.setText(inText.substring(prevPart.StartIndex, inText.length));
  }
  else
  {
   prevPart.Text = "This table is loading";
  }
    }

    public function set Text (inText:String):void
    {
     inText = inText.replace("</tr>", "");
     theText = inText;
     findCells(inText);
    }

    [Bindable] public function get StartIndex ():Number { return theStartIndex; } public function set StartIndex (inVar:Number):void { theStartIndex = inVar; };
    [Bindable] public function get TableClass ():String { return tClass; } public function set TableClass (inVar:String):void { tClass = inVar; };
    public function get Text():String { return theText; };

}

class htmlCell extends EventDispatcher implements IEventDispatcher
{
 private var theStartIndex:Number;
 private var theText:String;
 private var theType:String;
 private var theColspan:Number;
 private var theCellIndex:Number;
 private var styles:StyleSheet;
 private var align:String;
 private var theClass:String;
 private var theWidth:Number;
 private var tClass:String

 private var theCells:ArrayCollection = new ArrayCollection;
 private var currentCell:Number;

 public var theOptions:ArrayCollection = new ArrayCollection();

    public function htmlCell(inTableClass:String, inIndex:Number, inCellIndex:Number, inStyles:StyleSheet, inType:String = "td")
    {
     theStartIndex = inIndex;
     styles = inStyles;
     theCellIndex = inCellIndex;
     theColspan = 1;
     theType = inType;
     theText = "";
     theClass = "";
     theWidth=-1;
     tClass = inTableClass;
    }

    public function getDisplay(inWidth:Number):UIComponent
    {
     setOptions();
  var tag:RegExp = new RegExp("<image[^>]+/>", "g");
  var image:Array = tag.exec(theText);
  var newTextField:com.htmlFilter.text = new com.htmlFilter.text(); { newTextField.selectable=true; newTextField.condenseWhite=false; newTextField.percentWidth = 100; newTextField.setStyle("paddingLeft", 10); newTextField.setStyle("paddingRight", 10); newTextField.setStyle("paddingTop", 0); newTextField.setStyle("paddingBottom", 0); };

  newTextField.htmlText = "<p align='" + align + "'>" + theText + "</p>";

  var cellBox:box = new box(box.CELL);

  switch (theType)
  {
   case "td" :
    cellBox.styleName = "tableTD";
    break;
   case "th" :
    cellBox.styleName = "tableTH";
    break;
   default :
    cellBox.styleName = "box";
    break;
  }
  if (theClass == null)
  {
   if (theCellIndex != 0)
   {
    cellBox.setStyle("borderSides", "left");
   }
   else
   {
    cellBox.setStyle("borderStyle", "none");
   }
  }
  else
  {
   cellBox.styleName += theClass;

   if (theClass == "question" || theClass == "first")
   {
    cellBox.setStyle("borderSides", "bottom");
   }
  }

  if (image != null)
  {
   var newImage:SuperImage = determineImage(image[0]);
  }

  if (newImage == null || image == null)
  {
   cellBox.addChild(newTextField);
   newTextField.setStyleSheet(styles);
  }
  else
  {

   cellBox.addChild(newImage);
  }
  return cellBox;

    }

    public function setText(inText:String):void
    {
     switch (theType)
     {
      case "td" :
       theText = inText;
       break;
      case "th" :
       theText = "<b>" + inText + "</b>";
       break;
      default :
       debug.trace("can't set the text for type : " + theType);
       break;
     }
    }

    private function determineImage (inTag:String):SuperImage
    {
  var src:String = null;
  var width:Number = -1;
  var cacheName:String = "default";
  var newObject:SuperImage = null;

  var theOptions:ArrayCollection = tagsAndOptions.findOptions(inTag);
  for each (var option:Array in theOptions)
  {
   switch (option.optionName)
   {
    case "src" :
     src = option.optionValue;
     break;
    case "width" :
     width = Number(option.optionValue);
     break;
    case "cache" :
     option.optionValue == "null"
     ?
      cacheName = null
     :
      cacheName = option.optionValue;
     break;
   }
  }
  if (src != null)
  {
   newObject = new SuperImage();
   newObject.source = src;
   width < 0
   ?
    newObject.percentWidth = 95
   :
    newObject.width = width;
   newObject.cacheName = cacheName;
   newObject.setStyle("borderStyle", "none");
  }
  return newObject;
    }


    private function setOptions():void
    {
     theClass = null;
  for each (var option:Array in theOptions)
  {
   switch (option.optionName)
   {
    case "align" :
     align = option.optionValue;
     break;
    case "colspan" :
     theColspan = option.optionValue;
     break;
    case "class" :
     theClass = option.optionValue;
     break;
    case "width":
     theWidth = option.optionValue;
    default:
     break;
   }
  }
  if (theClass == null)
  {
   if (TableClass != null)
   {
    theClass = TableClass;
   }
  }
 }

    public function set Text (inText:String):void
    {

     inText = inText.replace("<td>", "");
     inText = inText.replace("</td>", "");
     theText = inText;
    }

    [Bindable] public function get StartIndex ():Number { return theStartIndex; } public function set StartIndex (inVar:Number):void { theStartIndex = inVar; };
    [Bindable] public function get TableClass ():String { return tClass; } public function set TableClass (inVar:String):void { tClass = inVar; };
    public function get Type():String { return theType; };
    public function get Width():Number { return theWidth; };
    public function get Colspan():Number { return theColspan; };
    public function get Text():String { return theText; };
    public function set Align(inVar:String):void { align = inVar; };
}
