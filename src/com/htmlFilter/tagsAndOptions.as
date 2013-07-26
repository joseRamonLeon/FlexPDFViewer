

//#  tagsAndOptions.as
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
 public class tagsAndOptions
 {
  import mx.collections.ArrayCollection;
     import flash.text.StyleSheet;
  import com.htmlFilter.debug;

  static public function findOptions(inString:String):ArrayCollection
  {
   var optionArray:ArrayCollection = new ArrayCollection;
   var pattern:RegExp = new RegExp("(?P<optionName>[^\" ]+)=\"(?P<optionValue>[^\"]*)\"","g");
   var foundAnOption:Array;
   foundAnOption = pattern.exec(inString);
   while (foundAnOption != null)
   {
    optionArray.addItem(foundAnOption);
    foundAnOption = pattern.exec(inString);
   }

   return optionArray;

  }

  static public function getOption(inString:String, wantedOption:String):String
  {
   var theOptions:ArrayCollection = tagsAndOptions.findOptions(inString);
   var theOption:String = null;
   for each (var option:Array in theOptions)
   {
    if (option.optionName == wantedOption)
    {
     theOption = option.optionValue;
    }
   }
   return theOption;
  }

  static public function findTag(inTag:String, inText:String):Array
  {
   var theRegExp:String = "<" + inTag + "(?P<options>[^<>]+)?>(?P<value>[^<>]+)</" + inTag + ">";
   var tag:RegExp = new RegExp(theRegExp, "g");
   return tag.exec(inText);
  }

  static public function findTagStart(inTag:String, inText:String):Array
  {
   var theRegExp:String = "<" + inTag + "(?P<options>[^>]*)?>";
   var tag:RegExp = new RegExp(theRegExp, "g");
   return tag.exec(inText);
  }

  static public function findTags(inTag:String, inText:String):ArrayCollection
  {
   var theRegExp:String = "<" + inTag + "(?P<options>[^<>]+)?>(?P<value>[^<>]+)</" + inTag + ">";
   var tag:RegExp = new RegExp(theRegExp, "g");
   var theTags:ArrayCollection = new ArrayCollection;
   var result:Array = tag.exec(inText);
   while (result != null)
   {
    theTags.addItem(result);
    result = tag.exec(inText);
   }
   return theTags;
  }
 }
}
