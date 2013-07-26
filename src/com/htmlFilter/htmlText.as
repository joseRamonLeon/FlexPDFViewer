

//#  htmlText.as
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

 public class htmlText extends Canvas
 {
  import flash.events.Event;
  import mx.collections.ArrayCollection;
  import mx.core.UIComponent;
  import mx.core.EdgeMetrics;
  import flash.events.MouseEvent;
  import com.htmlFilter.text;
  import mx.containers.HBox;
  import flash.display.Sprite;
     import flash.net.URLLoader;
     import flash.net.URLRequest;
     import flash.text.StyleSheet;
     import qs.controls.SuperImage;
     import com.htmlFilter.tagsAndOptions;
     import com.htmlFilter.box;
     import com.htmlFilter.*;
     import flash.utils.*;
  import com.htmlFilter.debug;

  private var theParts:ArrayCollection = new ArrayCollection();

  private var currentPart:Number = 0;

  private var theText:String;

  private var customCss:Boolean = false;

  private var cssLoaded:Boolean = false;

  private var styles:StyleSheet;

  private var loader:URLLoader;

  private var knownClasses:Object;

  private var theHeight:Number;

  private var theTotalWidth:Number = 0;

  private var haveAddedAllparts:Boolean;

  private var isGoodToGo:Boolean = true;

  public function htmlText ()
  {
   super();

   horizontalScrollPolicy="off";

   verticalScrollPolicy = "on";

   styles = new StyleSheet; var h1:Object = new Object(); h1.fontFamily = "Verdana"; h1.fontWeight = "bold"; h1.color = "#000000"; h1.fontSize = 20; h1.leading = 10; var h2:Object = new Object(); h2.fontFamily = "Verdana"; h2.fontWeight = "bold"; h2.color = "#333333"; h2.fontSize = 16; h2.leading = 4; var a:Object = new Object(); a.fontFamily = "Verdana"; a.fontSize = 12; a.color = "#0066FF"; a.textDecoration = "underline"; var para:Object = new Object(); para.fontFamily = "Verdana"; para.fontSize = 12; para.paddingLeft = 10; para.paddingTop = 5; para.paddingBottom = 10; var htmlTableCaption:Object = new Object(); htmlTableCaption.fontFamily = "Verdana"; htmlTableCaption.fontSize = 12; htmlTableCaption.borderStyle = "none"; htmlTableCaption.textAlign = "center"; htmlTableCaption.fontWeight = "bold"; styles.setStyle("h1", h1); styles.setStyle("h2", h2); styles.setStyle("p", para); styles.setStyle("a", a); styles.setStyle("htmlCelltext", para); styles.setStyle("htmlTableCaption", htmlTableCaption); styles.setStyle("listItems", para);;

   knownClasses = new Object();
  }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            if (numChildren == 0 && goodToGo)
            {
             if (theText != null)
             {
              invalidateProperties()
             }
            }
            else
            {
          var vm:EdgeMetrics = viewMetricsAndPadding;

          var yOfComp:Number = 0;

          var toX:Number;

          var obj:UIComponent;

          var extra:Number = 0;

          for (var i:int = 0; i < numChildren-1; i++)
          {
              obj = UIComponent(getChildAt(i));
              toX = obj.x;
              if (theParts.getItemAt(i).Type == "image")
              {
               toX = (width-obj.width-10)/2
              }
              if (theParts.getItemAt(i).Type == "empty")
              {
               obj.height = 10;
              }
              obj.move(toX, yOfComp);
              yOfComp = yOfComp + obj.height + extra;
          }

          if (numChildren >= 1)
          {
        tHeight = yOfComp;
     obj = UIComponent(getChildAt(numChildren-1));
        if (tHeight < unscaledHeight)
        {
         obj.height = unscaledHeight-tHeight;
         obj.move(0, yOfComp);

        }
        else
        {
         obj.height = 0;

        }
    }
          dispatchEvent(new Event("ready"));
   }


        }

        override protected function commitProperties():void
        {
         if (theText != null)
         {
    removeAllChildren();
    findParts();
       if (customCss)
       {
        if (cssLoaded)
        {
      addNewItems();
     }
    }
    else
    {
     addNewItems();
    }
   }
   invalidateDisplayList();

        }

        private function addNewItems():void
        {
      for each (var part:Object in theParts)
      {
       addNewItem(part.Type, part)
      }
      addNewItem("empty", {});
      addedAllParts = true;
        }

        private function findParts():void
        {
         //The text must not be null before entering this function
   theParts = new ArrayCollection();
      currentPart = -1;
      addItem("text", 0);
      var tags:RegExp = new RegExp("<(?P<tag>(/)?[^( )>]*)\s*(?P<extra>[^<>]*)>", "g");
   var result:Array = tags.exec(theText);
   var prevPart:Object;

   while (result != null)
   {
    prevPart = theParts.getItemAt(currentPart);
    if (prevPart.Type == "empty")
    {
     prevPart = theParts.getItemAt(currentPart-1);
    }
    if (knownClasses != null && knownClasses[result.tag] == true)
    {
     if (result.tag.charAt(0) != "/")
     {
      prevPart.Text = theText.substring(prevPart.startIndex, result.index);
      addItem(result.tag, result.index);
     }
     else
     {
      prevPart.Text = theText.substring(prevPart.startIndex, result.index + result[0].length);
      addItem("text", result.index);
     }
    }
    else
    {
     switch (result.tag)
     {
      case "table":
       prevPart.Text = theText.substring(prevPart.startIndex, result.index);
       addItem(result.tag, result.index, result.extra);
       break;
      case "image":
       if (prevPart.Type != "table")
       {
        prevPart.Text = theText.substring(prevPart.startIndex, result.index);
        addItem(result.tag, result.index, result.extra);
        if (result.extra.slice(-1) == "/")
        {
         addItem("text", result.index);
        }
       }
       break;
      case "/table":
       prevPart.Text = theText.substring(prevPart.startIndex, result.index + result[0].length);
       addItem("text", result.index);
       break;
      case "/image":
       if (prevPart.Type != "table")
       {
        prevPart.Text = theText.substring(prevPart.startIndex, result.index + result[0].length);
        addItem("text", result.index);
       }
       break;
     }
    }
    result = tags.exec(theText);
   }

   prevPart = theParts.getItemAt(currentPart);
   if (prevPart.Type == "empty")
   {
    prevPart = theParts.getItemAt(currentPart-1);
   }
   prevPart.Text = theText.substring(prevPart.startIndex, theText.length);

        }

        private function addNewItem(inType:String, inPart:Object):void
        {
         if (knownClasses != null && knownClasses[inType] == true)
         {
          var sPart:special = new special();
          sPart.width = totalWidth;
          sPart.type = inType;
          sPart.Txt = inPart.Text;
          sPart.styles = styles;
          addChild(sPart);
         }
         else
         {
       switch (inType)
       {
     case "text" :
      var pTag:Array = tagsAndOptions.findTagStart("p", inPart.Text);
      if (pTag != null)
      {
       var extraPadding:String = tagsAndOptions.getOption(pTag.options, "extraPadding");
      }
      if (extraPadding == null)
      {
       extraPadding = String(0);
      }
      var newTextField:com.htmlFilter.text = new com.htmlFilter.text(); { newTextField.selectable=true; newTextField.condenseWhite=false; newTextField.percentWidth = 100; newTextField.setStyle("paddingLeft", 10); newTextField.setStyle("paddingRight", 10); newTextField.setStyle("paddingTop", Number(extraPadding)); newTextField.setStyle("paddingBottom", Number(extraPadding)); };

                  var spaceAtStart:RegExp = new RegExp("^[^<]+");
                  var useStr:String = inPart.Text.replace(spaceAtStart, "");
      newTextField.htmlText = useStr;

      var newBox:box = new box(box.TEXT);
      newBox.addChild(newTextField);
      newTextField.setStyleSheet(styles);
      addChild(newBox);
      break;

     case "table" :
      var tableTag:Array = tagsAndOptions.findTagStart("table", inPart.Text);
      var theClass:String = tagsAndOptions.getOption(tableTag.options, "class");
      var W:String = tagsAndOptions.getOption(tableTag.options, "width");

      var pw:Number = 80;

      if (W != null)
      {
       if (W.charAt(W.length-1) == "%")
       {
        pw = Number(W.slice(0, -1));
       }
       else
       {
        pw = (Number(W) / totalWidth) * 100;
       }
      }

      if (theClass == "question")
      {
       pw = 95;
      }

      var table:objectWrapper = new objectWrapper(inPart, styles, pw, "table", totalWidth, vScroll);
      //newTable.percentWidth = 80;
      addChild(table);
      break;

     case "image" :
      var newImage:objectWrapper = new objectWrapper(inPart, styles, 0, "image", totalWidth, vScroll);
      addChild(newImage);
      break;

     case "empty" :
      var empty:box = new box(box.FWPLACE);
      addChild(empty);
      break;

     default :
      debug.trace("the " + inType + " part doesn't exist");
      break;
    }
   }
        }

        private function addItem(inType:String, inIndex:Number, inTag:String = ""):void
        {
         var newPart:Object;
         if (knownClasses != null && knownClasses[inType] == true)
         {
          newPart = new Object;
          newPart.startIndex = inIndex;
          newPart.Text = null;
          newPart.Type = inType;
          theParts.addItem(newPart);
          currentPart++;
         }
         else
         {
          switch (inType)
          {
           case "text" :
      newPart = new Object;
      newPart.startIndex = inIndex;
      newPart.Text = null;
      newPart.Type = "text"
      theParts.addItem(newPart);
      currentPart++;
      break;

     case "table" :
      newPart = new Object;
      newPart.startIndex = inIndex;
      newPart.Type = "table"
      newPart.Text = null;
      theParts.addItem(newPart);
      theParts.addItem({"Type" : "empty"});
      currentPart+=2;
      break;

     case "image" :
      var src:String = null;
      var width:Number = -1;
      var cacheName:String = "default";
      newPart = new Object;

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
       width > 0
       ?
        newPart.width = width
       :
        newPart.percentWidth = 95;
       newPart.src = src;
       newPart.startIndex = inIndex;
       newPart.Type = "image"
       newPart.Text = null;
       newPart.cacheName = cacheName;
       theParts.addItem(newPart);
       theParts.addItem({"Type" : "empty"});
       currentPart+=2;
      }
      break;
    }
   }

        }


  [Bindable]
  public function get text ():String
  {
   return theText;
  }
  public function set text (inText:String):void
  {
   if (goodToGo)
   {
    theText = inText;
    addedAllParts = false;
    invalidateProperties()
   }
  }

  public function set cssFile (inCssFile:String):void
  {
   customCss = true;

   var req:URLRequest = new URLRequest(inCssFile);
            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, onCSSFileLoaded);
            try
            {
                loader.load(req);
            }
            catch (error:ArgumentError)
            {
                debug.trace("An ArgumentError has occurred.");
            }
            catch (error:SecurityError)
            {
                debug.trace("A SecurityError has occurred.");
            }
  }

        public function onCSSFileLoaded(event:Event):void
        {
            styles = new StyleSheet();
            styles.parseCSS(loader.data);
            cssLoaded = true;
        }


  [Bindable]
  public function get vScroll():String
  {
   return verticalScrollPolicy;
  }
  public function set vScroll(inOption:String):void
  {
   if (inOption == "on")
   {
    totalWidth = width - 10;
   }
   else
   {
    totalWidth = width;
   }
   verticalScrollPolicy = inOption;
  }

        [Bindable]
  public function get kc ():Object
  {
   return knownClasses;
  }
  public function set kc(inClasses:Object):void
  {
   knownClasses = inClasses;
  }

        [Bindable]
  public function get tHeight ():Number
  {
   return theHeight;
  }
  public function set tHeight(inHeight:Number):void
  {
   theHeight = inHeight;
  }

  [Bindable]
  public function get totalWidth ():Number
  {
   if (theTotalWidth == 0)
   {
    theTotalWidth = width;
    if (vScroll == "on")
    {
     theTotalWidth -= 10;
    }
   }
   return theTotalWidth;
  }
  public function set totalWidth (inWidth:Number):void
  {
   theTotalWidth = inWidth;
  }


  [Bindable] public function get goodToGo ():Boolean { return isGoodToGo; } public function set goodToGo (inVar:Boolean):void { isGoodToGo = inVar; }
  [Bindable] public function get addedAllParts ():Boolean { return haveAddedAllparts; } public function set addedAllParts (inVar:Boolean):void { haveAddedAllparts = inVar; }
 }


}
