SpringBoard and Dock Plugins API
==============
Use ScrollingBoard Library to add Plugin pages on SpringBoard and the Dock
--------------------------------------------------------------------------

by Elias Limneos

web: limneos.net

email: iphone (at) limneos (dot) net

twitter: @limneos

Intro
_____

ScrollingBoard is a tweak that allows dock scrolling, dock unlimited icons, dock addon pages, folders scrolling, folders unlimited icons 
and as of 21-3-2011 , SpringBoard and Dock plugin pages (PluginManager).


Note: The SpringBoard and Dock Plugins library (PluginManager) will soon be an independent package and it will not require ScrollingBoard.
------------------------------------------------------------------------------------------------------------------------------------------

Instructions:
-------------

Before you begin, note that you can find 2 nic templates for Theos in this repository. You can use them to quickly create dock or springboard plugins.

Plugins are bundles , consisting of the bundle library, an Info.plist with the bundle's info and any other images or files you may wish to include.

Plugins for SpringBoard and Dock are found in /Library/ScrollingBoardPlugins/SpringBoardPlugins and /Library/ScrollingBoardPlugins/DockPlugins respectively.

Example
-------

So for example , to add a Dock plugin which you may call MyCoolDockPlugin , you need to create a library (the tweak) and place an Info.plist in the directory 

/Library/ScrollingBoardPlugins/DockPlugins/MyCoolDockPlugin.bundle

The structure of the bundle should consist of : 

A) A property list file called Info.plist with the following structure:
--

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>English</string>
        <key>CFBundleExecutable</key>
        <string>MyCoolDockPlugin</string>
        <key>CFBundleIdentifier</key>
        <string>My Cool Plugin</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundlePackageType</key>
        <string>BNDL</string>
        <key>CFBundleShortVersionString</key>
        <string>1.0.0</string>
        <key>CFBundleSignature</key>
        <string>????</string>
        <key>CFBundleVersion</key>
        <string>1.0</string>
        <key>DTPlatformName</key>
        <string>iphoneos</string>
        <key>MinimumOSVersion</key>
        <string>3.0</string>
        <key>NSPrincipalClass</key>
        <string>MyCoolDockPluginObject</string>
</dict>
</plist>

B) A compiled library that implements a class named MyCoolDockPluginObject as defined in the Info.plist 's NSPrincipalClass property.
--

The class MyCoolDockPluginObject should respond to selector -(id)view (required). 

The above is the only requirement for your plugin to work. 



@interface MyCoolDockPluginObject : NSObject
@property (nonatomic,retain) UIView *myView;
@end

@implementation MyCoolDockPluginObject
@synthesize myView;
-(id)view{

	if (!self.myView){
	
		self.myView=[[UIView alloc] init];
        self.myView.backgroundColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.4 alpha:0.7];
        self.myView.layer.cornerRadius=14;
        CGRect screenBounds=[[UIScreen mainScreen] bounds];
        UILabel *myLabel=[[UILabel alloc] initWithFrame:CGRectMake(screenBounds.size.width/2-200/2,35,200,20)];
        myLabel.textColor=[UIColor whiteColor];
        myLabel.textAlignment=UITextAlignmentCenter;
        myLabel.backgroundColor=[UIColor clearColor];
        myLabel.font=[[myLabel font] fontWithSize:12];
        myLabel.text=@"My first cool dock plugin!";
        [self.myView addSubview:myLabel];
        [myLabel release];
	
	}
	
	return myView;
}
@end



When the PluginManager initalizes, it loads all bundles from the plugins directory and instantiates the PrincipalClass objects with the -(id)init method.
The view that is added to the dock or springboard is what YOU return in your object's method -(id)view.

This view is autoresized to fit the dock or springboard, so I suggest you consider it as a wrapper view and leave it alone, and add subviews inside it to work with.
Note that the view will get an autoresizingMask = 18 (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) by the PluginManager upon initialization, 
so it fits correctly upon rotations.


Optional Methods
----------------
If you implement any of these 4 methods , it will be called when the dock scrolls to your view or leaves your view, respectively.

-(void)viewDidBecomeVisible; // Your view appeared on the dock's scrollview, or better, user just scrolled ON your view.
-(void)viewWillLoseFocus; // Your view will start moving away of the dock's focus, or better, user just started scrolling AWAY from your view.
-(void)viewDidLoseFocus; // Your view lost focus , or better , user scrolled AWAY from your view and ended in another view .
-(BOOL)requiresKeyboard; // Required if you need user input. If you implement this method and return YES, PluginManager will enable the SpringBoard's keyboard. (SpringBoard plugins only) 



Cycript - Quick Test
--------------------

If you need to quickly test a plugin with cycript without creating a bundle:
	
	No bundle example:

	# cycript -p SpringBoard
	
	cy# view=[UIView new];
	cy# view.backgroundColor=[UIColor redColor];
	cy# [[PMDockPlugins sharedInstance] insertPluginNamed:@"MyCoolPlugin" withView:view force:YES];
	
	Or with an already made bundle: 
	cy# myBundle=[NSBundle bundleWithPath:@"/path/to/the/bundle"];
	cy# [[PMDockPlugins sharedInstance] insertPluginFromBundle:myBundle force:YES];
	
	
	
Settings
--------

You can enable/disable SpringBoard and Dock plugins and change their appearing order from within ScrollingBoard's settings.


TroubleShooting
---------------

Your bundle's library is what gets loaded. If it has errors, it will crash SpringBoard.

If you don't implement a -(id)view method, your plugin will not be loaded.

If your main class that implements the view method has a different name than the one you defined as a bundle's NSPrincipalClass in your Info.plist, it will not be loaded.


Compile
-------

All the plugin examples and API posted here, is compiled using Theos. For more information about 
Theos/Logos, visit http://bit.ly/af0Evu and http://hwtt.net/ths


Thanks
------

Permanent Thanks to:

 Optimo for being my mentor

 DHowett for Theos/Logos and all the background work he's done for the community

 Saurik for cycript and everything else
 
 Many other developers from IRC from which I've learned a lot, including
 rpetrich, BigBoss, DB42, kennytm, chpwn, mringwal, TheZimm, Yllier


