//////////////////////////////////////////////////////////////////////////////////// JumpShip Framework for AS3// Copyright 2008 Jamie Scanlon//// Permission is hereby granted, free of charge, to any person obtaining a copy // of this software and associated documentation files (the "Software"), to deal // in the Software without restriction, including without limitation the rights // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell // copies of the Software, and to permit persons to whom the Software is // furnished to do so, subject to the following conditions://// The above copyright notice and this permission notice shall be included in all // copies or substantial portions of the Software.//// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS // IN THE SOFTWARE.//// Project: JumpShip Framework - Core// File: JSApplicationState.as// Created by: Jamie Scanlon//////////////////////////////////////////////////////////////////////////////////package com.jsjstudios.jumpship.core {		////////////////////////////////////////////////////////////////////////////////	// Imports	////////////////////////////////////////////////////////////////////////////////		import com.jsjstudios.jumpship.core.JSDataRecord;	import com.jsjstudios.jumpship.core.events.*;		////////////////////////////////////////////////////////////////////////////////	// Compiler Meta	////////////////////////////////////////////////////////////////////////////////	[Event(name="update", type="com.jsjstudios.jumpship.core.events.DataRecordBindingEvent")]		////////////////////////////////////////////////////////////////////////////////	//	// Class: JSApplicationState	//	////////////////////////////////////////////////////////////////////////////////	/**	 * Application State Class. This class provides methods for saving and tracking	 * states.	 * 	 * <p><b>Using this class:</b>	 * 	 * <p>This class provides the ability to track multiple states or	 * state namespaces. The first time you assign a state, that state is dymically added	 * to this class as a property. Since this class extends <code>JSDataRecord</code>	 * it can take advantage of it's native data binding capability to be alerted to changes	 * in the state property and perform state history management.	 * 	 * <p>You should start by assigning state names ( or namespaces ) and initial values.	 * <br>	 * <code>var myJSApplicationState:JSApplicationState = new JSApplicationState();</code>	 * <br>	 * <code>myJSApplicationState.namespace1 = {a:'value', b:'value'};</code>	 * <br>	 * <code>myJSApplicationState.namespace2 = {c:'value', d:'value'};</code>	 * <br>	 * 	 * <p> You can retrieve the current state by reffering to the namespace.	 * <br>	 * <code>var currentState:Object = myJSApplicationState.namespace1;</code>	 * <br>	 * Or you can retrieve past states by using <code>getStateHistoryAt(theIndex:int):Object</code>	 * or <code>getLastState():Object</code>. These to methods return an object with all namespaces	 * and values. For example:	 * <br>	 * <code>var lastState:Object = myJSApplicationState.getLastState(); // {namespace1:{a:'value', b:'value'}, namespace2:{c:'value', d:'value'}}</code>	 * <br>	 */	public dynamic class JSApplicationState extends JSDataRecord	{				//		// Properties ( Backers )		//		protected var _pendingState:Object;		protected var _currentState:Object;		protected var _stateHistory:Array;				////////////////////////////////////////////////////////////////////////////////		//		// Constructor		//		////////////////////////////////////////////////////////////////////////////////		/**		 * Constructor			 */		function JSApplicationState ()		{						_stateHistory = new Array();					}				////////////////////////////////////////////////////////////////////////////////		//		// Public Methods		//		////////////////////////////////////////////////////////////////////////////////				/**		 * Registers a new state.		 * @param theState The new state object.		 */		public function newState(theState:Object):void {						_currentState = theState;						_stateHistory.splice(0,0,theState);						while (_stateHistory.length > MAXHISTORY) {								_stateHistory.pop();							}					}				/**		 * Registers a new pending state. The pending state must be commited before		 * it is logged.		 * @param theState The new pending state.		 * @param commitLast An optional Boolean parameter. If true than any previous		 * pending state will be commited before the new pending state is registered.		 * @see public function commitPendingState():void		 */		public function newPendingState(theState:Object, commitLast:Boolean = false):void {						// Commit the last pending state unless told otherwise			if (_pendingState != null && commitLast != false) {				commitPendingState();			}						_pendingState = theState;					}				/**		 * Commits a pending state.		 */		public function commitPendingState():void {						if (_pendingState != null) {				_currentState = _pendingState;								_stateHistory.splice(0,0,_pendingState);								while (_stateHistory.length > MAXHISTORY) {										_stateHistory.pop();									}			}						clearPendingState();					}				/**		 * Clears a pending state.		 */		public function clearPendingState():void {						_pendingState = null;					}				/**		 * Retuns the history of the Application state at a given index.		 * @param theIndex The index of the state to return. Index 0 is the current state.		 * @return The previous state object at the given index.		 */		public function getStateHistoryAt(theIndex:int):Object {						return _stateHistory[theIndex];					}				/**		 * Retuns the previous Application state.		 * @return The previous state object.		 */		public function getLastState():Object {						return _stateHistory[1];					}				/**		 * Reverts the Application state to a given history index. Defaulting to index 1, i.e. the		 * last state.		 * @param theIndex The optional index to revert to. defaults to 1 ( the previous state ).		 * @return The state history.		 */		public function revertState(theIndex:int = 1):Object {						for (var i:int = 0 ; i < theIndex; i++) {								_stateHistory.splice(0,1);								_currentState = _stateHistory[0];							}						return _currentState;					}				////////////////////////////////////////////////////////////////////////////		//		// Hook Methods		//		////////////////////////////////////////////////////////////////////////////		/**		 * @inheritDoc		 */		override public function setFunction(theName:String):void {			newState(this.toObject());			this.dispatchEvent(new DataRecordBindingEvent(DataRecordBindingEvent.UPDATE, this, theName))		}				/**		 * @inheritDoc		 */		override public function getFunction(theName:String):* {			// make sure the data value we are about to return matches			// the current state.			if ( _currentState == null ) {				super.record[theName] = null;			} else {				super.record[theName] = _currentState[theName];			}		}					////////////////////////////////////////////////////////////////////////////////		//		// Event Handlers		//		////////////////////////////////////////////////////////////////////////////////				/**		 *	@inheritDoc		 *	Override the default handler for the DataRecordBindingEvent so that changes in		 *	child records trigger a state change.		 */		override protected function handleChildDataBindingEvent(event:DataRecordBindingEvent):void {			super.handleChildDataBindingEvent(event);			newState(this.toObject());		}				////////////////////////////////////////////////////////////////////////////////		//		// Getters/Setters		//		////////////////////////////////////////////////////////////////////////////////				/**		* (Read Only) The current state of the Application		*/		public function get currentState():Object {			return _currentState;		}				/**		* (Read Only) The previous state of the Application		*/		public function get previousState():Object {			return _stateHistory[1];		}				/**		* (Read Only) The pending state of the Application		*/		public function get pendingState():Object {			return _pendingState;		}				////////////////////////////////////////////////////////////////////////////		// Pseudo Constants - 		// These constants are implemented as getters so that exending classes		// can override the default values.		////////////////////////////////////////////////////////////////////////////				/**		* Pseudo Constant: Determines the maximum number of commands this command will remember		* in it's history.		*/		public function get MAXHISTORY():uint {						return 100; // maximum number of history entries					}			}  // Class End	} // Package End