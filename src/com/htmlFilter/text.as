

package com.htmlFilter
{
    import mx.controls.Text;
    import flash.text.StyleSheet;
 import com.htmlFilter.debug;

    public class text extends Text
    {

        public function text()
        {
            super();
        }

        //it won't let me ovveride the setter for styleshhet
        public function setStyleSheet (inVar:StyleSheet):void
        {
           textField.styleSheet = inVar;
        };
    }
}
