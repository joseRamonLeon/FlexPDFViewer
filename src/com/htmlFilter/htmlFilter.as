


//#  htmlFilter.as
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
 public class htmlFilter
 {

  import flash.text.StyleSheet;
  import mx.collections.ArrayCollection;
  import com.htmlFilter.tagsAndOptions;
  import com.htmlFilter.debug;

  private var tagHistory:ArrayCollection;
  private var classHistory:Array;

  private var indentLevel:Number;

  private var lists:ArrayCollection;
  private var currentList:Object;

  private var knownClasses:Object;

  private var doBr:Boolean;

  public function filterContent(theData:String, inKnownClasses:Object = null):String
  {
   indentLevel = 0;
   lists = new ArrayCollection();
   tagHistory = new ArrayCollection();
   classHistory = new Array();
   doBr = false;
   tagHistory = new ArrayCollection();
      var htmlTag:RegExp = new RegExp("<(?P<tag>(/)?[^( )>]*)\s*(?P<extra>[^<>]*)>", "g");
   knownClasses = inKnownClasses;
   theData = theData.replace(/\t|\n|\r| {4}/g, "");
   theData = theData.replace(/(?<![>\s])<(?!\/)/g, " <");
   theData = theData.replace(htmlTag, replaceHTML);
   return theData;
  }

  private function replaceHTML(found:String, tag:String, extra:String, extra2:String, index:int, other:int):String
  {
   var tagClass:String = tagsAndOptions.getOption(found, "class");
   var theReturn:String = "";
   tagHistory.addItem(found);
   var lastTag:String = "";
   if (tagHistory.length-2 > 0)
   {
     lastTag = String(tagHistory.getItemAt(tagHistory.length-2));
   }

   if (tag != "all" && tag != "/all" )
   {
    if (knownClasses != null && knownClasses[tagClass] == true)
    {
     classHistory.push([tag, tagClass]);

     var classAttr:RegExp = new RegExp("class=\"[^\"]+\"", "g");
     extra2 = extra2.replace(classAttr, "");
    //	debug.trace("pushed [" + tag + ", " + tagClass + "]");
    //	debug.trace("<" + tagClass + " class=\"" + tag + "\">");
     theReturn = "<" + tagClass + " class=\"" + tag + "\"" + extra2 + ">";
    }
    else
    {
     var lastClass:Array = ["", ""];
     if (classHistory.length > 0)
     {
      lastClass = classHistory[classHistory.length-1];
     }
     if (tag.charAt(0) == "/" && lastClass[0] == tag.substring(1))
     {
      lastClass = classHistory.pop();
      //debug.trace("</" + lastClass[1] + ">");
      return "</" + lastClass[1] + ">";
     }
     else
     {
      if (tag.charAt(0) == "h" && !isNaN(Number(tag.charAt(1))))
      {
       theReturn = "<p class='" + tag.substr(0,2) + "'" + extra2 + ">";
      }
      else if (tag.substr(0,2) == "/h" && tag.length == 3)
      {
       theReturn = "</p>";
      }
      else if (tag.substr(0,1) == "p" && tag.length == 1)
      {
       lastTag.substr(0,3) == "</h" && lastTag.length == 5
       ?
        theReturn = "\n<p>"
       :
        theReturn = "<p>";
      }
      else if (tag.substr(0,2) == "/p")
      {
       theReturn = "</p>\n";
      }
      else if (foundListStart(found))
      {
       theReturn = "<span class='listItems'>";
       if (indentLevel == 1)
       {
        if (lastTag != "</p>")
        {
         theReturn += "\n";
        }
       }
      }
      else if (foundListItem(found))
      {
       if (lastTag == "</li>")
       {
        theReturn += "\n";
        if (currentList.doBr)
        {
         theReturn += "\n";
        }
       }
       else if (doBr)
       {
        theReturn += "\n";
        doBr = false;
       }

       var listIndex:String = tagsAndOptions.getOption(found, "custom");
       if (listIndex == null) { listIndex = currentList.currentIndex; }

       var indentTo:Number = 10 + indentLevel*30 + (indentLevel-1)*10;
       theReturn += "<textformat blockindent='" + indentTo + "'" +
           "indent='" + currentList.indent + "' " +
           "tabstops='[" + (indentTo) +"]'>" +
           listIndex + "\t";
      }
      else if (foundEndListItem(found))
      {
       theReturn = "</textformat>";

      }
      else if (foundEndList(found))
      {
       theReturn = "</span>";
       if (indentLevel == 0)
       {
        theReturn = "</span>\n\n";
       }

      }
      else
      {
       theReturn = found;
      }
     }
    }
   }
   else
   {
    theReturn = found;
   }
   return theReturn;

  }

  private function foundListStart (found:String):Boolean
  {
   switch (found.substr(1,2))
   {
    case "ul" :
    case "ol" :
     indentLevel++;
     if (indentLevel > 1)
     {
      doBr = true;
     }
     lists.addItem(new htmlList(found));
     currentList = lists.getItemAt(lists.length-1);
     return true;
     break;
    default :
     return false;
     break;
   }
  }

  private function foundListItem (found:String):Boolean
  {
   switch (found.substr(1,2))
   {
    case "li" :
     return true;
     break;
    default :
     return false;
     break;
   }
  }

  private function foundEndListItem (found:String):Boolean
  {
   switch (found)
   {
    case "</li>" :
     return true;
     break;
    default :
     return false;
     break;
   }
  }

  private function foundEndList (found:String):Boolean
  {
   switch (found)
   {
    case "</ul>" :
    case "</ol>" :
     indentLevel--;
     if (lists.length > 1)
     {
      lists.removeItemAt(lists.length-1);
      currentList = lists.getItemAt(lists.length-1);
     }
     return true;
     break;
    default :
     return false;
     break;
   }
  }


 }
}
