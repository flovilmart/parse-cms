ICParseCMS 
=======

A vanilla library for displaying and editing your data backed by the amazing http://parse.com




How to use
======

### Intitialization

1. clone the repo `git clone git@github.com:icangowithout/parse-cms.git`
2. Init the submodule `cd parse-cms && git submodule init`

### Setup your project

1. Create a new XCode project (single view)
2. Drop in your project the ICParseCMS.xcodeproj
3. Drop in the ParseSDK (download at https://parse.com/docs/downloads)



### Setup the code
- in your app delegate:


`#import <ICParseCMS/ICParseCMS.h>`

`#import <Parse/Parse.h>`

	-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    	self.window.backgroundColor = [UIColor whiteColor];
    	// use a default parse.plist or pass your init dictionary
   		[ICParseCMS initializeWithInfoDictionary:nil];
    	self.window.rootViewController = [ICParseCMS CMSViewController];
    	[self.window makeKeyAndVisible];
    	return YES;
	}



AND VOILA!
… not quite

Get to your build settings and setup the following


#### Target dependencies

* ICParseCMS.a (static lib)
* ICParseCMSResource (bundle)

#### Link Binary With Libaries

Add to your project:

* Parse.framework
* AudioToolbox.framework
* CFNetwork.framework
* CoreGraphics.framework
* CoreLocation.framework
* libz.1.1.3.dylib
* MobileCoreServices.framework
* QuartzCore.framework
* Security.framework
* StoreKit.framework
* SystemConfiguration.framework
* ICParseCMS.a

#### Copy Bundle Resources

* ICParseCMSResources.bundle

#### Linker flags

In your project build settings, force load the library:

Set the var 'Other Linker Flags' (OTHER_LDFLAGS) to:

-force_load ${BUILT_PRODUCTS_DIR}/libICParseCMS.a

### Create your configuration file

The CMS framework need to know a bit about your ParseAppID and Client Key, as well as the Classes you want the app to display.


##### Using a Plist
By default, it looks up for a `parse.plist` file in your bundle resources.

Using that method don't require anything, and you can initialize with: 

- `[ICParseCMS initializeWithInfoDictionary:nil]`

##### Using a NSDictionary

If you don't want to use the plist file, you can pass the infoDictionary yourself

-  `[ICParseCMS initializeWithInfoDictionary: myInfo]`

	
	
Dictionary keys:

* ParseApplicationId // Your application ID -> String
* ParseClientKey // Your client key -> String
* ParseClassNames // Class names -> Array
* ParseDefaultACL // A default ACL -> dictionary
* ParsePreferedDisplayKey // the key to display in the lists, per className -> Dictionary

Example

	NSDictionary *options = @{
	 	@"ParseApplicationId" : MY_PARSE_APP_ID,
    	@"ParseClientKey" : MY_PARSE_CLIENT_KEY,
    	@"ParseClassNames"" : @[@"ClassA", @"ClassB", @"ClassC"],
    	// Optional
    	@"ParseDefaultACL" : @{
    		@"public" : {"read": @YES, @"write": @NO},
    		@"adminRoles": [@"admin", @"superadmin"]
    	
    	},
    	//Optional by highly recommended
    	@"ParsePreferedDisplayKey" : @{
    		@"ClassA"	: @"aKey",
    		@"ClassB"	: @"myKeyB",
    		@"ClassC"	: @"myCKey"
    	};
    [ICParseCMS initializeWithInfoDictionary: options];

Using the plist method is pretty much the same, jump that dict in parse.plist in your bundle, and the framework will figure it out by itself!

### Security model

The CMS uses the Parse Object ACL's to enforce security.
Because it's not possible to use the Master Key in the iOS App, the logged in user needs to have write access when editing the objects.

The prefered strategy here, is to create an admin role that will have all rights on your objects (set it collection wide in the web data browser).
Add your users to the admin role and you're good to go.

It's a good practice to consider ACL from scratch when designing your app.


Refer to Parse Documentation for further information.


#### External edition of keys
Let's say you have an image picker that works well, that is web based, you may want the CMS to open an external editor.
Thanks to iOS URL scheme support, your can go back and forth from the app to the external editor and back to the app.
You can even manage to have your 'external editor' being the same app.

1. Define the keys to be externaly edited:
	In your info dictionary add:
	
		@"ParseCustomHandler" : @[
			@"ClassA" : @{
				// Open safari to the URL
				@"KeyA" : @"https://mycustomeditor.com/edit/",
				// Open another app responding to that URL scheme (ClassA/KeyB are optional, depending on how you wanna manage your edition app)
				@"KeyB" : @"myioseditor://edit/ClassA/"
			}
		]

2. Setup the callback URL's
	By default, the CMS is passing a callback URL scheme to parse[YOUR APPID]://
	Add that in your Info Plist in URL Types.
	
	When opening the external editor, the url will look like that:
	
		[custom handler]?key=[editedKey]&callback=parse[YOURAPPID]://update/
		
	in the example of KeyA of ClassA that will look like and if your appid is 12345ABCDEF:
	
		https://mycustomeditor.com/edit/?key=KeyA&callback=parse12345ABCDEF://update/
		
	and the parameters are properly URL encoded

3. Implement Callback from external editor

		- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    		if (![ICParseCMS handleOpenURL:url]) {
    			// do something else
    		}
    	}
    	
    The callback should be in this form: 
    	
		parse12345ABCDEF://update/?key=KeyA&value=newvalueforkeyA
		
	the handleOpenURL will take care of replacing the value for the key in the currently edited object
