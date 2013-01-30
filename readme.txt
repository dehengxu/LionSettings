
LlamaSettings is a drop-in settings module for your application.

It currently is architecturally messy, but that will soon be rectified
with a rewrite of much of the mechanism that makes it all work.

So why use this?

Stability
- It is extensively tested
- It is leak and crash free (as of June 1, 2009)
- It is in use in shipping, production, professional applications

Features
- Easy to integrate - just:
	- drop the "LlamaSettings" folder into your project
	- connect a LlamaSettings object to a list view
	- that's it.
- It lets you integrate settings into your app without much fuss
- It lets you add more settings types than what Apple allows
	- The new architecture will simplify this greatly
- It gives you things like a button in your settings list that
	- launches the mail app; to send you feedback emails
	- launches a url into another app/safari
	- launches a url into a popup window (great for help files)
	- calls a delegate in your app to perform a custom function
- It requires just a single .plist to define the settings
	- no complicated extra bundles like settings.app requires
	- button/slider/html imagery/resources are pulled from your app bundle
- It is an extended subset of the Apple settings panel
	- It implements many of Apple's settings.app widgets:
		- groups
		- text
		- switch
		- slider
	- It does implement some new settings widgets:
		- 4 different color selectors
		- system volume slider
		- segmented selector
		- web view (see above)
		- generic button 
	- It will implement some more settings widgets:
		- date selector
		- time selector
		- text view display
- Allows for multiple settings in your app
	- create another list, and point it at another LlamaSettings object.
- It will soon have the ability to install default settings once, the first
  time your application is run. (in progress)



It is released with the MIT License, so do with it as you will. 

Everything works well to get you running with this project before
the full-rewrite happens.  The updated API will likely change a
little in the final, revised-architecture version, but this will
get you going in the time being.

-Scott Lawrence
 yorgle@gmail.com
