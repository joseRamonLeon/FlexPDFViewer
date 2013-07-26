package com.interactiveAlchemy.utils
{
        public class Debug
        {
                /**
                * Private members
                */
                import flash.net.LocalConnection
               
                private static var _lc : LocalConnection;
                private static var _isInitialized : Boolean = false;
       
                /**
                * write()
                * Traces data to the Output panel within Flash, and displays the same data
                * in DebugIt Receiver, enabling debugging outside of Flash.
                */
                public static function write ( ... arguments):void
                {
                        // Check for existing LocalConnection. If none, create one.
                        if ( ! _isInitialized)
                        {
                                _lc = new LocalConnection ();
                        }
                        // Send params to DebugIt Receiver
                        _lc.send ("_debugIt", "write", arguments);
                        // Trace each argument on its own line in the Output panel as well
                        for (var i:Number = 0; i < arguments.length; i ++)
                        {
                                trace (arguments [i]);
                        }
                }
        }
}

