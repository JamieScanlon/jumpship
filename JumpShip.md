# JumpShip #

JumpShip Framework
An MVC Based ActionScript with the following features:
  * A Standardized Data Model
  * A [Command Pattern](http://en.wikipedia.org/wiki/Command_pattern) Based Controller
  * A standardized View Mediator with asset loading tools.
  * Model / View Data Binding
  * Controller Before / After filtering
  * Controller Command Cascading (the ability for commands to call other commands).

### JumpShip Framework Blog: ###
[jumpshipframework.blogspot.com](http://jumpshipframework.blogspot.com/).

## Download ##

You can download a zip containing the full framework and ASDoc generated documentation in the downloads section

## Latest News ##

  * 12/16/08: JumpShip UPDATE, version 4.0. This update coincides with moving the project to google code. This update focuses on eliminating dependancies on the Singleton pattern. Also included are added features for the state and data model classes as well as fixes for potential memory leaks.

  * 05/16/08: JumpShip for AS3 UPDATE, version 3.2. See Downloads.

  * 05/21/08: JumpShip for AS3 UPDATE, version 3.1. See Downloads.

  * 02/03/08: JumpShip for AS3 UPDATE, version 3.0. See Downloads.

  * 01/02/08: JumpShip for AS3 UPDATE, version 2.1. See Downloads.

  * 09/01/07: JumpShip for AS3 RELEASE! and major update JumpShip AS2,  version 1.5. See Downloads.

  * 04/29/07: JumpShip FINAL RELEASE! Major Update JumpShip version 1.2 Released. See Downloads.

  * 02/18/07: Major Update JumpShip version 1.1 Released. See Downloads.


  * 12/19/06: Documentation (Alpha v1.0) Released. [[projects:jumpship:documentation | JumpShip Docs](.md)].

  * 12/16/06: Pizza Service Example Released. [version 1.0](http://www.jsjstudios.com/jumpship/JumpShip_Examples.v.1.0.zip) released.

  * 12/11/06: Extras Beta [version 1.0](http://www.jsjstudios.com/jumpship/JumpShip_Extras.v.1.0.zip) released.

  * 12/11/06: Core Beta [version 1.0](http://www.jsjstudios.com/jumpship/JumpShip_Core.v.1.0.zip) released.

## Usage instructions ##

Visit the JumpShipDocs page for the basics.

See "documentation" folder within the package for the class specifications.

## Mailing list ##

There is a community of users and developers for this project who share their experiences on the mailing list. Please search through the archives to see if your question has been answered before submitting it to the mailing list.

> JumpShip Mailing List http://osflash.org/mailman/listinfo/jumpship_osflash.org: Subscribe and manage your subscription

## About ##

What Is JumpShip?

JumpShip is a Flash Framework, yes another one.

The difference between JumpShip and other frameworks, and the reason I decided to release this as it's own project, is that it makes an effort not to assume that you are using Flash Remoting (or one of it's OS incarnations) or Flex. But it also makes an effort not to limit those of you who are. JumpShip also encourages an MVC approach to development.  And more specifically a [Ruby on Rails](http://rubyonrails.org) approach which assumes a standard development practice rather than trying to accommodate every possible design style. Ruby on Rails calls it "convention over configuration". It assumes that once we all settle on the best way to accomplish a task, we can assume that we will use that convention for most of what we write in the future, and we can thereby gloss over most of the inane grunt work that is required to get any application off the ground.

Why?

And this is the point where you moan an say, "Oh Man, not another Ruby on Rails bandwagon jumper." But Wait! I used to be just like you. And to be fair, JumpShip actually only implements the spirit of the Ruby on Rails philosophy. Obviously we are not Ruby developers, but ActionScript, as an object oriented language,  shares the basic principals of Ruby, another object oriented language. So actually a lot of the core concepts behind Rails can be applied equally to ActionScript. But what it borrows most from it is the approach to the Model.

Those of you familiar with [MVC](http://en.wikipedia.org/wiki/MVC) know that the Model is the data. The meat and bones. The problem is that in an effort to be flexible, the Model usually ends up being loosely defined and therefore very specific to each application. The JumpShip Framework starts with a Model that has out-of-the-box search, sort, filtering, transforming, and grouping capabilities.

The Framework also leverages a standard Model to give you a Ruby on Rails Gateway that works with the standard (RESTful) scaffolding. It is literally as easy as defining a URL to your Rails server and you can be up and running with a database-driven Flash application.

How?

Basically, the Model represents a database table which is essentially a collection of records, all having the same fields. It's not hard to abstract this in Flash as a collection of Objects all having the same properties. Add the ability to search and sort, manipulate the columns and rows (properties and objects) and you have the the JumpShip Data Model.

Although the JumpShip Framework is not limited to Rails developers, if you use the Ruby on Rails Gateway to provide Create, Request, Update, Delete ( CRUD ) functionality, and you can have a Model that is a literal representation of your Rails Model.

Not using Rails? No problem... the Gateway sends and receives all of it's data through XML. Even though it's called the Ruby in Rails Gateway, actually, the framework has no idea what it's talking to. And even is you don't want to use XML, you are free to extend the base Gateway and implement your preferred protocol be it JSON, AMF or SWX.

But that's just the "M", what about the "V" and "C"?

Let's start with the "C", the Controller. JumpShip started out as a variation of the MVC-Command Design Pattern similar to Cairngorm, ARP, or [PureMVC](http://puremvc.org). The Controller is where you can see the most evidence of that. The Controller implements the [Command Design Pattern](http://en.wikipedia.org/wiki/Command_pattern). The JumpShip framework adds a couple of key features though.

JumpShip adds the ability for commands to cascade (in other words, Commands can call other commands). The benefit is that in order to separate functionality you have to break down Commands into their most basic elements. The other similar frameworks mentioned above have similar capabilities but they are implemented in a haphazard fashion with special Classes. The JumpShip Framework is the only one of these to have this feature implemented as a standard.

Another feature that the JumpShip framework adds is before and after filters. These are hook functions that are automatically called before and after every Command. This provides an easy way to implement validation within your Controller and to independently monitor Controller logic. This feature is heavily leveraged in the Ruby on Rails world to provide validation and security among other things.

View?

The JumpShip framework provides a formal structure for defining the View. Along with the ability to abstract the physical objects on the stage ( see the [Mediator Design Pattern](http://en.wikipedia.org/wiki/Mediator_pattern) ) from the Controller and Model, the View also has built in loading control.

If you are dealing with a large application, you definitely do NOT want everything loading at once on the first frame. The view provides basic functionality to have these elements load when you want them to and make sure that nothing else tries to access them before they are loaded.

The View Also provides basic data binding. Once the Model is registered with the View, any change in the Model will cause the View to call an update hook function.

What else you got?

The JumpShip Framework also has basic Application State Model , Application Environment manager, and Service Locator classes. The Application State Model tracks the state of the Application as well as records state history. Application State has a state history in order to possibly an "undo" capability or user statistics tracking.

The Application Environment tracks whether the current build is a development version ( which may sacrifice performance and reliability at the cost of more bug reporting ) or a production environment ( which probably is most concerned with performance and graceful application errors ). You can use this class to have your application behave differently depending on in which environment it is running.

The Service Locator provides basic abstraction between your Flash Application and your data gateway be it Flash Remoting, Flash Media Server or [Ruby on Rails](http://rubyonrails.org).

## Credits ##

By Jamie Scanlon, Flash / Flex Developer.

## License (MIT) ##

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.