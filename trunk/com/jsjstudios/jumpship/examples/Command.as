package com.jsjstudios.jumpship.examples
{
	
	import com.jsjstudios.jumpship.core.JSCommandBase;
	import flash.events.Event;
	
	public class Command extends JSCommandBase
	{
		
		// 
		// Properties
		//
	 
		////////////////////////////////////////////////////////////////////////////
		//
		// Primitive operations
		//
		////////////////////////////////////////////////////////////////////////////
		
		override public function executeOperation ():void
		{
			
			trace (COMMANDNAME+" has executed!");
			
			if (parameters is Event) {
				onResultOperation ();
			} else {
				onResultOperation (parameters.variable);
			}
			
		}
		
		////////////////////////////////////////////////////////////////////////////
		// Pseudo Constants - 
		// These constants are implemented as getters so that exending classes
		// can override the default values.
		////////////////////////////////////////////////////////////////////////////
		
		/**
		* Pseudo Constant: The Name Of thie Command.
		*/
		override public function get COMMANDNAME():String {
			
			return "MyCommand";
			
		}
	
	}
}