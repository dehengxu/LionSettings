

----------------------------------------
                           LlamaSettings

  http://code.google.com/p/llamasettings

                  (c)2009 Scott Lawrence
                        yorgle@gmail.com
                  http://umlautllama.com



----------------------------------------
                                   Using

To use LlamaSettings, simply drag the LlamaSettings folder from the
"src" folder of this source repository into your project and build
it.  To hook into it, you will need to do a few things;  (you can
follow along by browsing the LSExample project.)

- Create a UITableView in your project
	(ref: FlipsideView.xib, FlipsideViewController.[hm])
	
- import the "LlamaSettings.h" header
	(ref: FlipsideViewController.h)

- Make sure your view controller class is a LlamaSettingsDelegate
	(ref: FlipsideViewController.h)

- Add a class variable for LlamaSettings
	(ref: FlipsideViewController.h)

- Create the LlamaSettings object, and connect to it
	(ref: FlipsideViewController.m viewDidLoad)

- Implement the methods required for the LlamaSettingsDeleagate
	(ref: FlipsideViewController.m settingsChanged buttonPressed)


Make sure that you include the proper settings.plist in the resources group of
your project, and be sure that you initWithPlist: with the correct spelling
and case of the file.  Remember that the iPhone device is cAsE SeNsItIvE!

That's essentially it.


For a definition/list of what settings specifiers are allowed and
their parameters, please refer to LlamaSettings/LlamaSettingsNotes.txt

Please also refer to the example plist at LSExample/mySettings.plist
for examples of how to set up your own.


----------------------------------------
                                    Misc

I realize that the architecture of LlamaSettings is messy at best,
and it's also quite incomplete.  Rest assured that the API will not
majorly change, and that the library has been tested to not be
horribly leaky.  The internal architecture will be changing at some
point in the near future to make it easier to add more widgets.

The system has been extensively tested, and is leak and crash free
as of 2009-June-01.  It is used in production, shipping code, and is
considered to be stable.


----------------------------------------
                                 License

LlamaSettings is distributed with a MIT license.  You can use this
code in your own commercial or free project.  Just give me (and
optionally this project) credit in your app or support website for
your app.

If you have any questions or concerns, do not hesitate to email me
so that we may discuss them.
