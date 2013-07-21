﻿package com.codeazur.as3swf.data.actions.swf5
{
	import com.codeazur.as3swf.data.actions.*;
	
	public class ActionBitRShift extends Action implements IAction
	{
		public static const CODE:uint = 0x64;
		
		public function ActionBitRShift(code:uint, length:uint) {
			super(code, length);
		}
		
		override public function toString(indent:uint = 0):String {
			return "[ActionBitRShift]";
		}
	}
}
