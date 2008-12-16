package com.jsjstudios.jumpship.examples
{
	
	import com.jsjstudios.jumpship.core.JSControllerBase;
	import com.jsjstudios.jumpship.core.JSDataModel;
	import com.jsjstudios.jumpship.examples.View;
	import flash.events.Event;
	
	public class Controller extends JSControllerBase
	{
		//
		// Assets
		//
		
		private static var inst:Controller; 	// instance of self
		private var view:View;
		private var myModel:JSDataModel;
		
		////////////////////////////////////////////////////////////////////////////
		//
		// Methods
		//
		////////////////////////////////////////////////////////////////////////////
		
		public static function getInstance ():Controller 
		{
			//
			// Singleton Implementation
			//
			
			if ( inst == null )
			{
				// create a single instance of the singleton
				inst = new Controller();
				
			}
			
			return inst;
			
		}
		
		////////////////////////////////////////////////////////////////////////////
		//
		// Hook Functions
		//
		////////////////////////////////////////////////////////////////////////////
		
		
		override protected function init():void {
 			
 			var columnsArray:Array = ["column1", "column2", "column3"];
			myModel = new JSDataModel(columnsArray);
			
			view = new View();
			
			// Registering the view here will trigger the Command mapped to "viewEvent" to
			// execute. This is one way of executing a Command.
			registerEventDispatcher( "viewEvent", view );
			
			view.load();
			
			// Another way of executing a Command is calling createCommand() directly. This
			// method has the advantage of being able to define a return function.
			createCommand("viewEvent", {variable:"good", model:myModel}, processCommandResult);
 			
		}
		
		////////////////////////////////////////////////////////////////////////////
		//
		// Primitive functions
		//
		////////////////////////////////////////////////////////////////////////////
		
		override protected function addCommands ():void 
		{
			
			addCommand ( "viewEvent", Command );
			
		}
		
		////////////////////////////////////////////////////////////////////////////
		//
		// Private functions
		//
		////////////////////////////////////////////////////////////////////////////
		
		// This function, passed in to the Command throught the createCommand(), will
		// be called by the Command itself with it's result
		protected function processCommandResult(theResultObject:Object):void 
		{
			
			switch (theResultObject.type) {
				
				case "MyCommand":
					
					if (theResultObject.result == "good") {
						
						trace("Good Result");
					
					} else {
						
						trace("Bad Result");
					
					}
					
					break;
		 
				default:
					break;
			}
			
		}
	 
	}
}