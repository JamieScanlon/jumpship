package com.jsjstudios.jumpship.examples
{
	
	import com.jsjstudios.jumpship.core.JSViewBase;
	import com.jsjstudios.jumpship.core.JSDataModel;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class View extends JSViewBase
	{
		
		////////////////////////////////////////////////////////////////////////////
		//
		// Primitive Functions
		//
		////////////////////////////////////////////////////////////////////////////
		
		override protected function addAssets ():void
		{
			
			var newMovie:MovieClip = new MovieClip();
			addChild(newMovie);
			
			addAsset("myAsset", newMovie);
			
		}
		
		override protected function loadAsset(assetName:String):void
		{
			
			//
			// Note: This function should be used to load and/or initiate an asset.
			// This function is called by the load(assetName:String) method.
			// After the asset is loaded, the makeAvalable() function should
			// be called (either by this class or by a listening class) so that this
			// asset's status can be updated.
			//
			
			makeAvailable(assetName);
			
			dispatchEvent(new Event("viewEvent"));
			
		}
	
	}
}