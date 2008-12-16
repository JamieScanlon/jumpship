﻿//////////////////////////////////////////////////////////////////////////////////// JumpShip Framework for AS3// Copyright 2007 Jamie Scanlon//// Permission is hereby granted, free of charge, to any person obtaining a copy // of this software and associated documentation files (the "Software"), to deal // in the Software without restriction, including without limitation the rights // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell // copies of the Software, and to permit persons to whom the Software is // furnished to do so, subject to the following conditions://// The above copyright notice and this permission notice shall be included in all // copies or substantial portions of the Software.//// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS // IN THE SOFTWARE.//// Project: JumpShip Framework - Core// File: JSRuntimeEnvironment.as// Created by: Jamie Scanlon//////////////////////////////////////////////////////////////////////////////////package com.jsjstudios.jumpship.core{	////////////////////////////////////////////////////////////////////////////////	// Imports	////////////////////////////////////////////////////////////////////////////////		import flash.system.Capabilities;	import flash.events.Event;	import flash.net.URLLoader;	import flash.net.URLRequest;		////////////////////////////////////////////////////////////////////////////////	//	// Class: JSRuntimeEnvironment	//	////////////////////////////////////////////////////////////////////////////////	/**	* Runtime Environment Class. This class track what environment the, whether it be production	* or development. A development environment usually assumes that all traces and Errors are	* enabled, and that performance is not the highest priority. A production environment usually 	* assumes the goal is to run efficiently and fail gracefully.	*/	public class JSRuntimeEnvironment	{				//		// On Stage		//						//		// Properties		//		private var _environment:String;		private var _configFile:String;					//		// Assets		//		/**		*	@private		*	Static class instance		*/		protected static var inst:JSRuntimeEnvironment;				private var configXML:XML;						//		// Intervals		//						//		// Constants		//		/**		*	@private		* 	Constant: Determines the default environment the application should run in.		*/		protected const DEFAULTENVIRONMENT:String = "production"						//		// Functions		//				////////////////////////////////////////////////////////////////////////////////		//		// Constructor		//		////////////////////////////////////////////////////////////////////////////////		/**		*	Constructor		*/		public function JSRuntimeEnvironment ()		{						configXML = new XML();			configXML.ignoreWhite = true;						_configFile = "config/environment.xml";						var myXMLURL:URLRequest = new URLRequest(_configFile);			var myLoader:URLLoader = new URLLoader(myXMLURL);						myLoader.addEventListener("complete", xmlLoaded);			myLoader.addEventListener("ioError", xmlError);			myLoader.addEventListener("securityError", xmlError);					}				////////////////////////////////////////////////////////////////////////////////		//		// Public Methods		//		////////////////////////////////////////////////////////////////////////////////				/**		* Singleton implementation for this class.		* @return A reference to this class instance.		*/		public static function getInstance ():JSRuntimeEnvironment {			//			// Singleton Implementation			//						if ( inst == null )			{				// create a single instance of the singleton				inst = new JSRuntimeEnvironment();							}						return inst;					}				/**		* Loads a configuration xml file. By default the path of the config 		*	file is 'config/environment.xml'. The config xml file lets this class		*	determine it's environment a runtime. The format of the config file 		*	should be: 		*	<p>		*	<code>		*	&lt;config&gt;		*	&lt;environment&gt;development&lt;/environment&gt;		*	&lt;/config&gt;		*	</code>		*	@param thePath An optional path from which to load the config file		*/		public function loadConfig(thePath:String = "config/environment.xml"):void {						_configFile = thePath;						var myXMLURL:URLRequest = new URLRequest(_configFile);			var myLoader:URLLoader = new URLLoader(myXMLURL);						myLoader.addEventListener("complete", xmlLoaded);			myLoader.addEventListener("ioError", xmlError);			myLoader.addEventListener("securityError", xmlError);					}				////////////////////////////////////////////////////////////////////////////////		//		// Private Functions		//		////////////////////////////////////////////////////////////////////////////////				private function detectEnvironment():void {						if (Capabilities.playerType == "External") {								_environment = "development";							} else {								_environment = DEFAULTENVIRONMENT;							}					}				////////////////////////////////////////////////////////////////////////////////		//		// Event Handlers		//		////////////////////////////////////////////////////////////////////////////////				private function xmlLoaded(event:Event):void {						configXML = XML(event.target.data);							_environment = configXML.elements("environment")[0].children()[0];					}				private function xmlError(event:Event):void {						detectEnvironment();					}				////////////////////////////////////////////////////////////////////////////////		//		// Getters/Setters		//		////////////////////////////////////////////////////////////////////////////////				/**		 * The environment in which the appllication is curently running. If this property has not		 * been set, this class will attempt to detect if the movi is running locally, in which case		 * the environment property will be set to "development". Otherwise the environment property		 * will be set to the default environment ("production").		 */		[Bindable]		public function get environment():String {				if (_environment == null) {				detectEnvironment();			}			return _environment;		}		public function set environment(theEnv:String):void {			_environment = theEnv;		}		}  // Class End	} // Package End