# JumpShip Docs #


Last Updated: December 12, 2008


## Using JumpShip with Ruby on Rails ##

A brief explanation of the JumpShip Rails Gateway and how it works is available on the documentation page

Go to [osflash.org/projects/jumpship/documentation/rails] to learn about the JumpShip Rails Gateway and how you can get your JumpShip Application working with a Ruby on Rails back-end.

An Example application is also available in the rails folder of the JumpShip Framework.



## Getting Started with JumpShip ##


### JumpShip's approach to MVC: ###


The core JumpShip package comes with base classes for the View and Controller... ''JSViewBase'' and ''JSControllerBase'' respectively. These base classes can be extended to provide the functionality you need in your application. The Model class, ''JSDataModel'', is a fully implemented class which extends the ''JSEnumerable'' class and uses the ''JSDataRecord'' class.

The ''JSDataModel'' can be thought of as a table where each 'row' is a ''JSDataRecord'' Object. The ''JSDataRecord'' has some special features but acts like an Object with attributes (properties).

```
var myRecord:JSDataRecord = new JSDataRecord();
myRecord.addAttribute("attribute", 1);
trace(myRecord.attribute); // result: 1

myRecord.attribute = 2;
trace(myRecord.attribute); // result: 2
```

The ''JSDataModel'' requires that all of it's ''JSDataRecord'' Objects have the same attributes, therefore these properties can be thought of as the columns. The ''JSDataModel'' has basic methods for manipulating rows and columns as well as searching and sorting data. The ''JSDataModel'' extends ''JSEnumerable'' which is a general class that provides the ability to search, sort and traverse collections of data. Since the ''JSDataModel'' inherits from this class it gains all of that functionality, including the ability to access it's ''JSDataRecord'' Objets in array ( [.md](.md) ) notation.

The View class (JSViewBase) extends the Sprite class. In most cases, the ''JSViewBase'' class  would already contain all of it's child assets when it is instantiated. In some cases, though, the View must be able to load in graphical assets at some point after the application has initialized ( loading in external images, movies or swf's for instance ). Because this process is usually asynchronous, the problem of managing the load process and making sure assets are loaded and ready before they are used in the application becomes difficult. The JumpShip Framework, the ''JSViewBase'' class contains tools for managing child assets. Through methods like ''addAsset()'' and ''loadAssset()'' you can control the loading process and make sure that those assets aren't accessed before they are available.

When an Asset is added, its given state is "unavailable". All Views can define a ''loadAsset()'' function that is called to perform any loading or initialization which may be required before the Asset's status can be changed to "available".

At some point all Assets must be loaded to be made available. JumpShip Views have a method ''load(assetName)'' which must be called to load an Asset (if no name is given all assets are loaded). This method can be called internally after all assets have been added, or externally by another class based on timeline or other events.

The JumpShip Controller can be thought of as an event handler. Usually there is some user action (like a button press) and the View that is associated with that button will issue an event. The Controller will receive that event and carry out an action (Command).

Almost all logic should be carried out in the Commands. The Controller just decides which Command to call based on the Application state and the Event.

After the Command is done, it may return a result to the Controller, after which the Command is destroyed. Based on the result, the Controller can issue an event, and/or call other Commands. The Commands are primarily responsible for updating the Models(s) including the Application State ( ''JSApplicationState'') which is itself a ''JSDataRecord'' Object.
Commands themselves have a base class ''JSCommandBase'' that they must implement. Each Command defines an ''executeOperation()'', which should contain the Command's main logic, and ''onResultOperation()'' which should be called after the Command has finished to format and return the result to the calling class.

Commands have the ability to call other Commands (cascade) in the same way that a Controller can.



### Beyond MVC: ###


The JumpShip Framework core contains three more classes that help formalize a basic approach. Although none of these classes is are strictly required, their use is encouraged.

The JSApplicationState class helps track the state (past and present) of the application. As mentioned above, the Commands should ideally upadate the ''JSApplicationState''. The Controller may also use the ''JSApplicationState'' to check the validity of certain events to make sure they make sense in the context of the current state of the application.

The ''JSApplicationState'' keeps a history of all states and could be used to help 'undo' a sequence of events. Further, the ''JSApplicationState'' has the ability to log a pending state change to keep track of a state that may be in transition. After the requirements have been met, the ''JSApplicationState'' would then commit the pending state---making the pending state now the present state.

Finally the ''JSRuntimeEnvironment'' class is used to keep track the environment the application is running, whether it be in a development mode, testing mode, or in production. Often it is the case that certain settings or Service calls must be different if you are testing the application rather than deploying the final version. This class provides a single place to determine the environment so that you application can react differently depending on what mode ''JSRuntineEnvironment'' says the application is in. This avoids the common practice of having to change settings and republish the code every time you want to change environments. The using the ''JSRuntimeEnvironment'' class you can simply change the environment by using an external XML file loacted at config/environment.xml.





### Sample Implementations - the Controller: ###

In JumpShip, the Controller is usually the first thing instantiated. The base class ''JSControllerBase'' is a basic implementation of the interface ''IController''. So basic in fact that it does almost nothing unless it is extended.

The two main steps to get the Controller to do something significant is to define the Commands it will use and register with one or more ''EventDispatcher'' classes so that it can respond to events.

The Controller may also instantiate the Views and Models that it needs, and set up function s to react to Command results. Unlike most other MVC frameworks, the Controller has the ability to be more than an event handler. The JumpShip Framework encourages a relatively intelligent Controller that takes an active role in the logical flow of the application. The reason for a robust Controller is that if decisions about application flow aren't handled in the Controller than that logic usually ends up in the Views, and the Views tend to become boated.

The ''JSControllerBase'' provides two hook methods that can be used to perform basic initialization. ''preCommandInit()'' is executed before the Commands are registered with the Controller. Although ''preCommandInit()'' is available for any initialization that needs to take place early in the loading process, the method ''init()'' is the standard method for initializing the Controller and it gets called after all of the Commands have beed registered with the Controller.

Here is a piece of code from the example application included with the framework:

```

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

```

In the sample application, the View gets instantiated in the ''init()'' hook function. Along with a ''JSDataModel'' containing three fields. After that ''registerEventDispatcher()'' is called to have the Controller listen for events from the View. When the event type given in ''registerEventDispatcher()'' matches the name of a Command that was added with ''addCommand()'', that Command will get called automatically as a response to the event. This is similar to how other MVC frameworks operate where there is a on-to-one association between an event and a Command.

Where JumpShip differs from the majority of MVC Frameworks is that it gives the ability to call a Command anywhere in the Controller using ''createCommand()'', not just as a response to an event. Moreover, using ''createCommand()'' gives you the ability to define a function to receive the result of the Command. This approach to creating commands will be more familiar to those who are familiar with previous versions of JumpShip.

The final line of code to discuss is the line that loads the View ''view.load();''. Remember that in JumpShip, a View's loading process can be controlled. Usually in an application this simple, the View will just call it's own ''load()'' method internally, but this illustrates how the loading process can be controlled by an outside class. Calling ''load()'' with no parameters loads all assets in the view but finer controll can be gained by calling load with the name of one asset to load such as: ''view.load('myasset');''.

The Controller registers all of it's Commands through the ''addCommands()'' function. Here is a sample implementation from the examples included with the JumpShip Framework:

```
override protected function addCommands ():void 
{
			
	addCommand ( "viewEvent", Command );
			
}
```

A Command is added by calling ''addCommand()'' with the name of the Command and a reference to the class name. Notice that by giving this Command a name that is the same as the event type used in ''registerEventDispatcher()'', an automatic association is formed and the Command will be called any time that even is received.

Since the example application Command directly through the ''createCommand()'' method and that method defines a return function ''processCommandResult()'',  the only other thing left to define ''processCommandResult()''. This functions receives the results of the Command. It will receive an object containing the Command name and the result. This function should process the result accordingly. For example:

```
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
```

The ''theResultObject'' will be in the form:
''theResultObject.type : String'' - the name of the Command returning the result
''theResultObject.result : Object'' - the result object returned by the Command





### Sample Implementations - the Command: ###


The ''JSCommandBase'' class provides a basic implementation of ''ICommand''. Like ''JSControllerBase'' the default implementation does very little until it is extended.

All Commands must contain a ''COMMANDNAME'' constant definition. This is the name that is passed back to the Controller when a result is returned.

Every Command defines a ''executeOperation()''. ''executeOperation()'' will be the first thing called when a Command is created. It should contain the main logic that the Command needs to execute and when it's done, should call ''onResultOperation()''. Every Command returns a result (even if that result is null) so that the Controller knows when it has finished and can destroy it.

The ''onResultOperation()'' function may also be extended to process and format results to return to the Controller. The only requrement for extending the ''onResultOperation()'' function is that it needs to call ''onResult()'' which will return the result to the Controller.

The Command can receive parameters from the Controller (or Command) that called it. the parameters object is available to the Command as the variable 'parameters'. When the Command is called through a direct association with an event, the parameters object will be the event object that was received by the Controller. If the Command is called using ''createCommand()'' the parameters object is an Object containing parameters.

A simple implementation from the exapme application included with the JumpShip Framework looks like:

```
override public function executeOperation ():void
{
	
	trace (COMMANDNAME+" has executed!");
	
	if (parameters is Event) {
		onResultOperation ();
	} else {
		onResultOperation (parameters.variable);
	}
			
}
```

Remember that all commands must override the COMMANDNAME pseudo Constants so that returned values can contain the name of the Command that is returning a value.

```
override public function get COMMANDNAME():String {
			
	return "MyCommand";
	
}
```






### Sample Implementations - the View: ###



The ''JSViewBase'' general implementation of ''IView'' and just as with the ''JSComtrollerBase'' and ''JSCommandBase'' it doesn't do much until it's extended. The ''JSViewBase'' Class extends the ''Sprite'' class so it is a display object and inherits all of its properties and methods.

The First thing a View class should do is add its Assets through the ''addAssets()'' function. Assets can be any Object but usually are ''DisplayObject''s. The Assets do not have to be previously defined in order to be added, the ''addAssets()'' can be responsible for both defining and adding Assets. the ''addAssets()'' function takes a name (used to reference the asset in the future) and the Asset as parameters.

Here is sample code from the exapmle application included with the JumpShip Framework:
```
override protected function addAssets ():void
{
	
	var newMovie:MovieClip = new MovieClip();
	addChild(newMovie);
	
	addAsset("myAsset", newMovie);
	
}
```

After assets are added they have to be made available in order to be accessed by other classes. The way to make an asset available is by calling the ''makeAvailable()'' function with the ''assetName''. Assets can also be made unavailable by calling the ''makeUnavailable()'' function in the same way.

All Views should define a ''loadAsset()'' function which should perform the job of loading the Asset (if needed) and calling ''makeAvailable()'' to make the asset available to other classes. the ''loadAsset()'' function will be called by the View's ''load()'' method. The View's ''load()'' method should be used (internally or externally) to load one or all of the Assets. In most cases, the ''addAssets()'' function will call the ''load()'' method after it has added all of its Assets, thereby automatically making all of the Assets available to other classes. However, if you need more control of exactly what Assets are loaded and when, outside classes can be in charge of calling the View's ''load()'' method when required.

A sample implementation would look like:
```
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
```

Any class can access a View's Assets by using the ''getAssetRef()'' method with the name of the Asset. If the Asset is unavailable, ''null'' is returned.

The JumpShip View implements its own form of data binding. When a ''JSDataModel'' is registered with the View, the hook function ''update()'' will be called on the View each time the Model changes. To register a Model with a view, call the View's method ''registerModel()'' with a reference to the Model to bind to. Note that a View can bind to more than one Model. When the ''update()'' hook function is called, it is called with one parameter that will be a reference to the Model that has changed. You can unregister a Model by calling ''unregisterModel()'' in the same way.

The View has two other hook functions, ''preAssetInit()'', and ''init()''. Similar to the way the Controllers init hook functions work, these functions can be used to initialize variables. The only difference being that preAssetInit() is called BEFORE the function ''addAssets()'' is called and ''init()'' is called after.





### Sample Implementations - the Model: ###



The JumpShip Model really represents the core of the framework. As mentioned above the ''JSDataModel'' is best thought of as a table where the rows are ''JSDataRecord'' Objects. The true flexibility of the ''JSDataModel'' comes from the ''JSDataRecord''.

The ''JSDataRecord'' is meant to behave like any Object but it actually allows much greater control. The JSDataRecord is a dynamic class (where properties, functions, etc. can be added outside of the class definition). Attributes (properties) can also be added by using the ''addAttribute()'' method. But when you add an attribute to a ''JSDataRecord'', it actually adds that attribute as an internal private attribute and creates Getter and Setter methods for it. By doing this, the ''JSDataRecord'' is able to call hook functions ''getFunction()'' and ''setFunction()'' each time an attribute is changed or accessed. This is the way data binding is implemented. As of JumpShip version 4, the JSDataRecord also recognizes when it's attributes are themselves JSDataRecord instances and is able to listen for and respond to data binding events from these objects.

Advanced users can extend the ''JSDataRecord'' class, defining the ''getFunction()'' and ''setFunction()'' hook functions to perform an action each time an attribute is read or saved. For instance a Record class can be written to, read from, and saved to a server-side back end.

Although the ''JSDataModel'' is a two-dimensional data structure, the ''JSDataRecord'' is multi-dimensional. Records can be saved within Records to give the ''JSDataModel'' an appearance of multi-dimensionality.

Along with ''addAttribute()'' the method ''create()'' can be used to define all of the attributes in one pass. The ''create()'' method takes an Object as the parameter and uses the Objects property names as the attribute names and property values as attribute values. As an example, the following two methods produce the same result:

```
// The following creates two identical JSDataRecords by two different means
//
// Method 1:

var myRecord1 = new JSDataRecord();
myRecord1.addAttribute("attribute", 1);

// Method 2:

var myRecord2 = new JSDataRecord();
myRecord2.create({attribute:1});
```

Similar to the ''create()'' method, the ''update()'' method uses an Object parameter to update the values of the given attributes. for example:

```
var myRecord = new JSDataRecord();
myRecord.create({attribute:1});
trace (myRecord.attribute) // result: 1

myRecord.update({attribute:2});
trace (myRecord.attribute) // result: 2
```

The last two methods of the ''JSDataRecord'' are ''removeAttribute()'' and ''destroy()''. The ''removeAttribute()'' simply deletes an attribute while the ''destroy()'' method deletes all attributes.

Finally the ''JSDataRecord'' has one property that provides access to the raw data stored in the Record. This property, ''JSDataRecord.record'', Should not be used under normal circumstances but provides access to the data without triggering the getter / setter hook functions. using the above example:

```
trace(myRecord.record.attribute) // result (without triggering the hook function): 2
```

When the ''JSDataModel'' is instantiated, it is given a list of column names that it will look for in its Records. And When a Record is added it will be given an attribute called "id" (if a attribute of this name is not already present) with a unique id number (usually the corresponding to the number at which the Record was added).

Under normal circumstances, once the Records have been added to the ''JSDataModel'', all the data can be accessed through the ''JSDataModel''. The ''JSDataModel'' provides numerous methods for retrieving the Records within it. The most basic method is ''getItemAt()'' with an index number as a parameter. This will return the ''JSDataRecord'' at the given index.

The most powerful way to retrieve Records is by using the ''find()'' method. This method will return the first or all Records matching the conditions given. The first parameter in ''find()'' is either "first" or "all" which tells the method what to return. If "first" is given, the method will return the first Record it finds which matches the search conditions. If "all" is given, the method returns an Array will all of the Records it finds matching the search criteria given. Note that if "all" is given but only one result is found, an Array of length 1 will be returned.

The second parameter is the search criteria given as an Object where the property name is the column (attribute) name to search for and the property value is the value to match in that column (attribute). If more that one property is specified, it is treated as an "and" search where the result must match all property values. For Example:

```
//
// Set up the Data Model
//
var myModel = new JSDataModel(["name","age"])

var myRecord1 = new JSDataRecord();
myRecord1.create({name:"Joe", age:25});
myModel.addItem(myRecord1);

var myRecord2 = new JSDataRecord();
myRecord2.create({name:"Linda", age:25});
myModel.addItem(myRecord2);

//
// Perform the search
//
var result1 = myModel.find("first",{age:25}); // result1 is equal to myRecord1

var result2 = myModel.find("all", {age:25}); // result2 is equal to [myRecord1,myRecord2]
```

Along with manipulating rows, the ''JSDataModel'' can also manipulate columns. When Records are added to the ''JSDataModel'' it checks the Record against it list of column names. If the Record is missing one or more of those columns (attributes) the ''JSDataModel'' will add that column (attribute) to the Record. The ''JSDataModel'' doesn't care if the Record contains attributes other than the ones listed in it's column names list, it only cares that, at the minimum, the Record has the columns (attributes) that the ''JSDataModel'''s column names list specify.

The ''JSDataModel'' can add or remove entire columns by calling the ''addColumn()'' or ''removeColumn()'' methods. It can also update or retrieve entire columns by calling the ''updateColumn()'' or ''getColumn()'' methods. In the case of ''getColumn()'', the method returns an object with the property names being the id's of the Records, and the property values being the Values of that Record's column.

Besides using the methods, the ''JSDataModel'' items can also be accessed with array nototion ( ''[.md](.md)'' ) or through the properties ''JSDataModel.items'' and ''JSDataModel.records'' which are synonymous. These two properties are Arrays containing all of the Records.