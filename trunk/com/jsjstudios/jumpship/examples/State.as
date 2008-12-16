package com.jsjstudios.jumpship.examples
{
	import mx.managers.IHistoryManagerClient;
	import com.jsjstudios.jumpship.core.JSApplicationState;
	import com.jsjstudios.jumpship.core.events.DataRecordBindingEvent;

	public dynamic class State extends JSApplicationState implements IHistoryManagerClient
	{
	
		//
		// Assets
		//
		protected static var inst:State; 	// instance of self
		private var uniqueName:String
		
		////////////////////////////////////////////////////////////////////////////////
		//
		// Constructor
		//
		////////////////////////////////////////////////////////////////////////////////
		function State ()
		{
			super();
			uniqueName = String("State "+Math.floor(Math.random()*1000));
			
		}
		
		////////////////////////////////////////////////////////////////////////////////
		//
		// Methods
		//
		////////////////////////////////////////////////////////////////////////////////
		
		/**
		* Singleton implementation for this class.
		* @return A reference to this class instance.
		*/
		public static function getInstance ():State {
			//
			// Singleton Implementation
			//
			
			if ( inst == null )
			{
				// create a single instance of the singleton
				inst = new State();
				
			}
			
			return inst;
			
		}
		
		public function saveState():Object
		{
			return currentState;
		}
		
		public function loadState(state:Object):void
		{
			for (var a:* in state) {
				this[a]= state[a];
			}
		}
		
		override public function toString():String
		{
			return String("[object "+uniqueName+"]");
		}
		
	}
}