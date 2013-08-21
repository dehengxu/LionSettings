//
//  LlamaSettings.m
//
//  Created by Scott Lawrence on 3/13/09.
//  Copyright 2009 Scott Lawrence. All rights reserved.
//
//  This module (and submodules) can be used for any purpose in any app
//  no warranty is expressed or implied.  If it works for you, great.
//  If it breaks, bummer.
//
//  This is heavily based on UICatalog from Apple's samples (as can be gleaned from the TableCells
// 
//  For a current list of what works and what doesn't, refer to LlamaSettingsNotes.txt
//

// NOTE: This needs to be cleaned up still.  I recognize it's messy and a bit inconsistant.

#import "LSColorDisplay.h"
#import "LlamaSettings.h"
#import "Constants.h"
#import "CellFullWide.h"
#import "DisplayCell.h"
#import "SourceCell.h"
#import "ButtonCell.h"
#import "SliderCell.h"

#import "MediaPlayer/MPVolumeView.h"

static LlamaSettings *_sharedLlamaSettings = nil;

@interface LlamaSettings ()
- (NSDictionary *) itemForKey:(NSString *)key;
- (void)OpenWebWindowWithURL:(NSString *)theURL restrictive:(BOOL)rst withTitle:(NSString *)title preload:(BOOL)_preload;
@end

@implementation LlamaSettings

@synthesize delegate;
@synthesize viewController;
@synthesize valid;

- (id) initWithPlist:(NSString *)plistName
{
	if( self = [super init] )
	{
		//nsap = [[NSAutoreleasePool alloc] init];
		self.valid = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];

		[self loadHeirarchyFromPlist:plistName];
	}
	return self;
}

- (id) init
{
	if( self = [super init] )
	{
		//nsap = [[NSAutoreleasePool alloc] init];
		self.valid = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
        
		[self loadHeirarchyFromDefaultPlist];
	}	
	return self;
}

- (id)initWithSettingsBundle:(NSString *)bundleName andPlistName:(NSString *)plistName
{
    if (self = [super init]) {
        self.valid = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
        
		[self loadHeirarchyFromSettingsBundle:bundleName andPlistName:plistName];
    }
    return self;
}


+ (LlamaSettings *)sharedSettings
{
	// instantiate the whole thing, and set it to be in an expected state
	if( !_sharedLlamaSettings ) {
		// get an object
		_sharedLlamaSettings = [LlamaSettings alloc];
		[_sharedLlamaSettings init];
	}
	return _sharedLlamaSettings;
}

+ (LlamaSettings *)sharedSettingsFromPlist:(NSString *)plistName
{
	// instantiate the whole thing, and set it to be in an expected state
	if( !_sharedLlamaSettings ) {
		// get an object
		_sharedLlamaSettings = [LlamaSettings alloc];
		[_sharedLlamaSettings initWithPlist:plistName];
	}
	return _sharedLlamaSettings;
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
	if( theDictionary ) [theDictionary release];
	if( theWidgets ) [theWidgets release];
	if( theWebViews ) [theWebViews release];
	[super dealloc];
}


#pragma mark -
#pragma mark Enable and Disable items

- (void) withKey:(NSString *)_itemKey setEnabledTo:(BOOL)_enable
{
	// (en|dis)able the control, if it exists
	UIControl * widg = [theWidgets objectForKey:_itemKey];
	if( widg ) {
		[widg setEnabled:_enable];
	}
		
	// next (en|dis)able the cell itself
	
}

- (void) enableItem:(NSString *) itemKey
{
	[self withKey:itemKey setEnabledTo:YES];
}

- (void) disableItem:(NSString *) itemKey
{
	[self withKey:itemKey setEnabledTo:NO];
}


- (void) autoEnableAndDisable
{
#ifdef NEVER
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// iterate over the list of widgets,
	for( id key in theWidgets ) //XXXX Ignored!
	{
		NSDictionary * thisItem = [self itemForKey:key];
		if( thisItem != nil ) {
			NSArray * enabledList = [thisItem valueForKey:@"Enable"];
			if( enabledList ) {
				NSLog( @"Enable list found for %@", key );
				for( id enableItem in enabledList ) 
				{
					NSLog( @"Enable %@", enableItem );
				}
				// for each one, look for the Enabled item
				// if found, check the state of the widget
				// enable all of the items in the section defined by the state of the widget
			}
			
			NSArray * disabledList = [thisItem valueForKey:@"Disable"];
			if( disabledList ) {
				NSLog( @"Disable list found for %@", key );
				// for each one, look for the Disabled item
				// if found, check the state of the widget
				// disable all of the items in the section defined by the state of the widget
				for( id disableItem in disabledList ) 
				{
					NSLog( @"Enable %@", disableItem );
				}
				
			}
		}
	}
#endif
}



#pragma mark -
#pragma mark Control Generators 

- (void)switchAction:(id)sender
{
	[self saveSettingsToSystem];
}

- (UISwitch *)create_UISwitchWithDictionary:(NSDictionary *)dict
{
	CGRect frame = CGRectMake(0.0, 0.0, kSwitchButtonWidth, kSwitchButtonHeight);
	UISwitch * switchCtl = [[UISwitch alloc] initWithFrame:frame];
	[switchCtl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
	
	// in case the parent view draws with a custom color or gradient, use a transparent color
	switchCtl.backgroundColor = [UIColor clearColor];
	
	// okay, now let's pre-fill it with the default value
	// [NSNumber numberWithBool:NO];
	BOOL val = [[dict objectForKey:@"DefaultValue"] boolValue];
	switchCtl.on = val;
	return switchCtl;
}

- (UISegmentedControl *)create_UISegmentedControlWithDictionary:(NSDictionary *)dict
{
	CGRect frame = CGRectMake(0, 0, 300, kSegmentedControlHeight);
	UISegmentedControl * seg = [[UISegmentedControl alloc] initWithItems:[dict objectForKey:@"Titles"]];
	seg.frame = frame;
	
	NSArray *images = [dict objectForKey:@"Images"];
	if( images != nil )
	{
		for( int x=0 ; x<[images count] ; x++ )
		{
			NSString *fn = (NSString *)[images objectAtIndex:x];
			if( fn != nil && ([fn length] > 0) ) {
				UIImage * im = [UIImage imageNamed:fn];
				if( im ) [seg setImage:im forSegmentAtIndex:x];
			}
		}
	}

	[seg addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
	seg.segmentedControlStyle = UITextBorderStyleBezel;
	seg.selectedSegmentIndex = [[dict objectForKey:@"DefaultValue"] intValue];
	return seg;
}

- (void) textFieldDidEndEditing:(UITextField *)tf
{
	[self saveSettingsToSystem];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textBoxName {
	[textBoxName resignFirstResponder];
	return YES;
}

- (UITextField *)create_UITextFieldWithDictionary:(NSDictionary *)dict
{
	CGRect frame = CGRectMake(0, 0, kTextFieldWidth, kTextFieldHeight);
	UITextField * tf = [[UITextField alloc] initWithFrame:frame];
    //Close Rounded border style.
	//tf.borderStyle = UITextBorderStyleRoundedRect;
	tf.returnKeyType = UIReturnKeyDone;
	tf.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf.text = [dict objectForKey:@"DefaultValue"];
	tf.secureTextEntry = [[dict objectForKey:@"IsSecure"] boolValue];
	tf.delegate = self;
    tf.textColor = kSystemValueTextColor;
	
	return tf;
}

- (void)colorChanged:(id)sender
{
	[self saveColorSettingsToSystem];
	[self autoEnableAndDisable];
    if (delegate && [delegate respondsToSelector:@selector(settingsChanged:)]) {
        [self.delegate settingsChanged:self];
    }
}


- (LSColorDisplay *)create_LSColorDisplayWithDictionary:(NSDictionary *)dict
{
	CGRect frame = CGRectMake(0.0, 0.0, kSwitchButtonWidth, kSwitchButtonHeight);
	LSColorDisplay * colorCtl = [[LSColorDisplay alloc] initWithFrame:frame];
	[colorCtl setDelegate:self];	
	
	NSString *aColor = [dict objectForKey:@"DefaultValue"];
	UIColor *newColor = [ColorHelper colorFromString:aColor];
	[colorCtl setColorWith:newColor];
	
	NSString *pickerType = [dict objectForKey:@"PickerType"];
	if( !pickerType ) { pickerType = @"TextualList"; }
	if( [pickerType isEqualToString:@"TextualList"] )    {	[colorCtl setPickerType:kPickerType_List]; }
	if( [pickerType isEqualToString:@"Color1Column"] )   {	[colorCtl setPickerType:kPickerType_1Column]; }
	if( [pickerType isEqualToString:@"Color2Columns"] )  {	[colorCtl setPickerType:kPickerType_2Columns]; }
	if( [pickerType isEqualToString:@"Touch"] )			 {	
		[colorCtl setPickerType:kPickerType_Touch];
		NSString *legend = [dict objectForKey:@"Legend"];
		if( legend ) [colorCtl setLegend:[dict objectForKey:@"Legend"]];
	}
		
	NSArray *colorNameList = [dict objectForKey:@"ColorNames"];
	if( colorNameList != nil && [colorNameList count]>0 ) {
		int cn = 0;
		for( NSString *colorName in colorNameList ) {
			[colorCtl setItem:cn++ Name:colorName];
		}
	}
	NSArray *colorValueList = [dict objectForKey:@"ColorValues"];
	if( colorValueList != nil && [colorValueList count]>0 ) {
		int cv = 0;
		for( NSString *colorValue in colorValueList ) {
			[colorCtl setItem:cv++ Color:[ColorHelper colorFromString:colorValue]];
		}
	}
	
	return colorCtl;
}

- (void)sliderAction:(id)sender
{
	[self saveSettingsToSystem];
}

- (UISlider *)create_UISliderWithDictionary:(NSDictionary *)dict
{
	CGRect frame = CGRectMake(0.0, 0.0, kSliderWidth, kSliderHeight);
	UISlider * sliderCtl = [[UISlider alloc] initWithFrame:frame];
	[sliderCtl addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	
	// in case the parent view draws with a custom color or gradient, use a transparent color
	sliderCtl.backgroundColor = [UIColor clearColor];
	
	sliderCtl.minimumValue = [[dict objectForKey:@"MinimumValue"] floatValue];
	sliderCtl.maximumValue = [[dict objectForKey:@"MaximumValue"] floatValue];
	NSString * fn = (NSString *)[dict valueForKey:@"MinimumValueImage"];
	UIImage * im;
	if( fn != nil && ([fn length] > 0) ) {
		im = [UIImage imageNamed:fn];
		if( im ) sliderCtl.minimumValueImage = im;
	}
	fn = [dict valueForKey:@"MaximumValueImage"];
	if( fn != nil && ([fn length] > 0) ) {
		im = [UIImage imageNamed:fn];
		if( im ) sliderCtl.maximumValueImage = im;
	}
	sliderCtl.continuous = NO;
	sliderCtl.value = [[dict objectForKey:@"DefaultValue"] floatValue];
	return sliderCtl;
}

- (UILabel *)create_PSTitleWithDictionary:(NSDictionary *)dict
{
	CGRect frame = CGRectMake(0.0, 0.0, 150.0, kLabelHeight);
	UILabel * labelWidget = [[UILabel alloc] initWithFrame:frame];
    labelWidget.textAlignment = NSTextAlignmentRight;
	[labelWidget setBackgroundColor:[UIColor clearColor]];
    labelWidget.text = [self titleForValue:[dict objectForKey:@"DefaultValue"] inValues:dict];
    labelWidget.textColor = kSystemValueTextColor;
    return [labelWidget autorelease];
}

- (UILabel *)create_UILabelWithDictionary:(NSDictionary *)dict
{
	CGRect frame = CGRectMake(0.0, 0.0, 150.0, kLabelHeight);
	UILabel * labelWidget = [[UILabel alloc] initWithFrame:frame];
	labelWidget.textAlignment = NSTextAlignmentRight;
	[labelWidget setBackgroundColor:[UIColor clearColor]];
	return [labelWidget autorelease];
}

- (UILabel *)create_PSMultiValuesWithDictionary:(NSDictionary *)dict
{
	CGRect frame = CGRectMake(0.0, 0.0, 150.0, kLabelHeight);
    id defaultValue = [dict objectForKey:@"DefaultValue"];
//    NSArray *values = [dict objectForKey:@"Values"];
    
	UILabel * labelWidget = [[UILabel alloc] initWithFrame:frame];
    labelWidget.textAlignment = NSTextAlignmentRight;
	[labelWidget setBackgroundColor:[UIColor clearColor]];
    
    
//    id value = nil;
//    for (int i = 0; i < [values count]; i++) {
//        value = [values objectAtIndex:i];
//        if ([value isEqual:defaultValue]) {
//            labelWidget.text = [[dict objectForKey:@"Titles"] objectAtIndex:i];
//        }
//    }
    labelWidget.text = [self titleForValue:defaultValue inValues:dict];
    
    labelWidget.textColor = kSystemValueTextColor;
    return [labelWidget autorelease];
}

- (void)precacheWebDisplayWithDictionary:(NSDictionary *)dict
{
	BOOL Preload = [[dict objectForKey:@"Preload"] boolValue];
	if( !Preload ) return;
	
	NSString * urlKey = [dict objectForKey:@"Key"];
	NSString * webTitle = [dict objectForKey:@"WebTitle"]; // defined page title
	if( webTitle == nil ) {
		webTitle = [dict objectForKey:@"Title"]; // button title
	}
	
	BOOL isRestrictive = [[dict objectForKey:@"Restrictive"] boolValue];

	// this won't actually open, but it will create the view, parse it all in, and store it aside for later.
	[self OpenWebWindowWithURL:urlKey restrictive:isRestrictive withTitle:webTitle preload:Preload];
}


#pragma mark -
#pragma mark Dictionary interface stuff 

- (void) loadHeirarchyFromDefaultPlist
{
//    NSString *settingsBundlePath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
//	[self loadHeirarchyFromPlistPath:[NSString stringWithFormat:@"%@/Root.plist", settingsBundlePath]];
    [self loadHeirarchyFromDefaultSettingsBundle];
}

- (void) loadHeirarchyFromPlist:(NSString *)plistName
{
    [self loadHeirarchyFromPlistPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:plistName]];    
}

- (void)loadHeirarchyFromPlistPath:(NSString *)plistPath
{
	readyForSaving = NO;
	if( theDictionary ) [theDictionary release];

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    theDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    if( theDictionary == nil ) {
        NSLog( @"Error loading!" );
        return;
    }
    NSArray *preferenceSpecifiers = [theDictionary valueForKey:@"PreferenceSpecifiers"];
    NSMutableArray *preferenceSpecifiersCopy = [[preferenceSpecifiers mutableCopy] autorelease];
    //Collection of illegale specifiers.
    NSMutableArray *illegaleSpecifiers = [NSMutableArray array];
    
    if( !preferenceSpecifiers ) {
        [pool drain];
        return;
    }
    
    if( [preferenceSpecifiersCopy count] == 0 ) {
        [pool drain];
        return;
    }
    self.valid = YES; // presumptuous, i admit
    
    // now, let's set up the precache web view list
    if( theWebViews ) [theWebViews release];
    theWebViews = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    // now, let's set up the widget list!
    if( theWidgets ) [theWidgets release];
    theWidgets = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    for( int x = 0 ; x < [preferenceSpecifiersCopy count] ; x++ )
    {
        NSDictionary * aSpecifier = [preferenceSpecifiersCopy objectAtIndex:x];
        NSString *PSType = [aSpecifier valueForKey:@"Type"];
        NSString *PSKey = [aSpecifier valueForKey:@"Key"];
//        NSLog(@"type :%@\n\nkey :%@", PSType, PSKey);
        
        if (!PSType) {
            [illegaleSpecifiers addObject:aSpecifier];
            continue;
        }
        
        if (![PSType isEqualToString:@"PSGroupSpecifier"] && ![PSType isEqualToString:@"PSChildPaneSpecifier"] && !PSKey) {
            [illegaleSpecifiers addObject:aSpecifier];
            continue;
        }
        
        if( PSKey && PSType ) {
            id v = nil;
            if( [PSType isEqualToString:@"PSToggleSwitchSpecifier"] ) {
                if (![aSpecifier valueForKey:@"DefaultValue"] ||
                    ![aSpecifier valueForKey:@"Title"]) {
                    [illegaleSpecifiers addObject:aSpecifier];
                }else {
                    v = [self create_UISwitchWithDictionary:aSpecifier];
                }
            }else if( [PSType isEqualToString:@"BLSegmentedSpecifier"] ) {
                v = [self create_UISegmentedControlWithDictionary:aSpecifier];
            }else if( [PSType isEqualToString:@"PSSliderSpecifier"] ) {
                if (![aSpecifier valueForKey:@"DefaultValue"] ||
                    ![aSpecifier valueForKey:@"MinimumValue"] ||
                    ![aSpecifier valueForKey:@"MaximumValue"]) {
                    [illegaleSpecifiers addObject:aSpecifier];
                }
                
                v = [self create_UISliderWithDictionary:aSpecifier];
            }else if( [PSType isEqualToString:@"BLColorPickerSpecifier"] ) {
                v = [self create_LSColorDisplayWithDictionary:aSpecifier];
            }else if( [PSType isEqualToString:@"PSTextFieldSpecifier"] ) {
                v = [self create_UITextFieldWithDictionary:aSpecifier];
            }else if ([PSType isEqualToString:@"PSTitleValueSpecifier"]) {
                if (![aSpecifier valueForKey:@"DefaultValue"]) {
                    [illegaleSpecifiers addObject:aSpecifier];
                }else {
                    v = [self create_PSTitleWithDictionary:aSpecifier];
                }
            }else if ([PSType isEqualToString:@"PSMultiValueSpecifier"]) {
                if (![aSpecifier valueForKey:@"Titles"] ||
                    ![aSpecifier valueForKey:@"Values"] ||
                    ([[aSpecifier valueForKey:@"Titles"] count] != [[aSpecifier valueForKey:@"Values"] count])) {
                    [illegaleSpecifiers addObject:aSpecifier];
                }else {
                    v = [self create_PSMultiValuesWithDictionary:aSpecifier];
                }
            }else {
//                NSLog(@"PSType :%@", PSType);
                v = [self create_UILabelWithDictionary:aSpecifier];
            }
            
            if( v != nil ) {
                [theWidgets setObject:v forKey:PSKey];
            }
            
            if( [PSType isEqualToString:@"BLURLButtonSpecifier"] ) {
                [self precacheWebDisplayWithDictionary:aSpecifier];
            }
            
            
        }
    }
    
    if (illegaleSpecifiers.count) {
        [preferenceSpecifiersCopy removeObjectsInArray:illegaleSpecifiers];
        NSMutableDictionary *tmp = [theDictionary mutableCopy];
        [tmp setValue:preferenceSpecifiersCopy forKey:@"PreferenceSpecifiers"];
        
        if (theDictionary) {
            [theDictionary release];
        }
        
        theDictionary = tmp;
    }
    
    // and load in the values...
    [self loadSettingsFromSystem];
    readyForSaving = YES;
    [pool drain];
}

- (void)loadHeirarchyFromDefaultSettingsBundle
{
    [self loadHeirarchyFromSettingsBundle:@"Settings.bundle" andPlistName:@"Root.plist"];
}

- (void)loadHeirarchyFromSettingsBundle:(NSString *)bundleName andPlistName:(NSString *)plistName
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:nil];
    [self loadHeirarchyFromPlistPath:[NSString stringWithFormat:@"%@/%@", bundlePath, plistName]];
}

- (NSInteger)numberOfSectionsInSpecifierDictionary:(NSArray *)preferenceSpecifiers
{
	if( !preferenceSpecifiers ) return 0;
	
	int totalSect = 0;
    
    beginWithOutGroupIdentifier = [self beginWithOutGroupSpecifier:[preferenceSpecifiers objectAtIndex:0]];
	for(int x = 0 ; x < [preferenceSpecifiers count]; x++)
	{
		NSDictionary * aSpecifier = [preferenceSpecifiers objectAtIndex:x];
		NSString *PSType = [aSpecifier valueForKey:@"Type"];
		
		if( [PSType isEqualToString:@"PSGroupSpecifier"] ){
			totalSect++;
		}
	}
    return totalSect + (beginWithOutGroupIdentifier ? 1 : 0);
}

- (int) indexOfSection:(int)sectno inSpecifierDictionary:(NSArray *)preferenceSpecifiers
{
	if( !preferenceSpecifiers ) return -1;
	if( sectno < 0 ) return -1;
    
    
	int sect = 0;

    beginWithOutGroupIdentifier = [self beginWithOutGroupSpecifier:[preferenceSpecifiers objectAtIndex:0]];
	for( int x = 0 ; x < [preferenceSpecifiers count] ; x++ )
	{
		NSDictionary * aSpecifier = [preferenceSpecifiers objectAtIndex:x];
		NSString *PSType = [aSpecifier valueForKey:@"Type"];
		
		if( [PSType isEqualToString:@"PSGroupSpecifier"] ){
//            NSLog(@"checking x :%d, sect :%d, sectno :%d, beginWithout :%d", x, sect, sectno, beginWithOutGroupIdentifier);
            if (beginWithOutGroupIdentifier && sectno == 0) {
//                NSLog(@"A index of section:(%d) %d", sectno, x);
                return 0;
            }
            if (beginWithOutGroupIdentifier && sectno == sect + 1) {
//                NSLog(@"B index of section:(%d) %d", sectno, x);
                return x;
            }
			if( sectno == sect ) {
//                NSLog(@"C index of section:(%d) %d", sectno, x);
                return x;
            }
			sect++;
		}
	}
	return -1;
}

- (NSDictionary *) itemForKey:(NSString *)key
{
	NSArray *preferenceSpecifiers = [theDictionary valueForKey:@"PreferenceSpecifiers"];
	for( int x = 0 ; x < [preferenceSpecifiers count] ; x++ )
	{
		NSDictionary * aSpecifier = [preferenceSpecifiers objectAtIndex:x];
		NSString *PSKey = [aSpecifier valueForKey:@"Key"];
		
		if( [PSKey isEqualToString:key] ){
			return aSpecifier;
		}
	}
	return nil;
}

- (BOOL)beginWithOutGroupSpecifier:(NSDictionary *)specifier
{
    return (![[specifier valueForKey:@"Type"] isEqualToString:@"PSGroupSpecifier"]);
}


- (NSObject *) itemAtRow:(int)row inSection:(int)section
{
	NSArray *preferenceSpecifiers = [theDictionary valueForKey:@"PreferenceSpecifiers"];
	
    beginWithOutGroupIdentifier = [self beginWithOutGroupSpecifier:[preferenceSpecifiers objectAtIndex:0]];
    
	// find the right section
	int idx = [self indexOfSection:section inSpecifierDictionary:preferenceSpecifiers];
    
    NSLog(@"row:%d, section:%d;   idx :%d", row, section, idx);
    
	if( idx < 0 ) return nil;
	
	// advance to row items
	idx++;
    // compatibale first with out group identifier
    if (beginWithOutGroupIdentifier && section == 0) {
        idx --;
    }
    
    
	// advance to specified row item
	idx += row;
    
	// range check
	if( idx > [preferenceSpecifiers count] ){
        return nil;
    }
    
    // NSLog(@"idx :%d\n", idx);
	// okey, send it back!
	return [preferenceSpecifiers objectAtIndex:idx];
}


- (NSString *) titleOfRow:(int)row inSection:(int)section
{
	NSDictionary * aSpecifier =	(NSDictionary *)[self itemAtRow:row inSection:section];
 	return [aSpecifier valueForKey:@"Title"];
}

- (NSString *) propertyForRow:(int)row inSection:(int)section ofProperty:(NSString *)property
{
	NSDictionary * aSpecifier =	(NSDictionary *)[self itemAtRow:row inSection:section];
	return [aSpecifier valueForKey:property];
}

- (NSString *) propertyForRow:(int)row inSection:(int)section ofProperty:(NSString *)propertyMain orFallBackOnProperty:(NSString *)propertyBackup
{
	NSDictionary * aSpecifier =	(NSDictionary *)[self itemAtRow:row inSection:section];
	
	if( [aSpecifier objectForKey:propertyMain] != nil ) {
		return [aSpecifier valueForKey:propertyMain];
	}
	
	return [aSpecifier valueForKey:propertyBackup];
}


- (BOOL) boolForRow:(int)row inSection:(int)section ofProperty:(NSString *)property
{

	NSDictionary * aSpecifier =	(NSDictionary *)[self itemAtRow:row inSection:section];
	return [[aSpecifier objectForKey:property] boolValue];
}

- (UIView *) widgetForRow:(int)row inSection:(int)section
{
	NSDictionary * aSpecifier =	(NSDictionary *)[self itemAtRow:row inSection:section];
	NSString *key = [aSpecifier valueForKey:@"Key"];

	if( key ) return [theWidgets objectForKey:key];
	return nil;
}

#pragma mark -
#pragma mark Loading and saving Settings to the System

- (void) loadSettingsFromSystem
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSArray *preferences = [theDictionary objectForKey:@"PreferenceSpecifiers"];
    NSString *PSType = nil;
    
	//	for( id key in theWidgets ) //XXXXXX Dangerous!
	NSArray *theKeys = [theWidgets allKeys];
	for( id key in theKeys )
	{
		id widget = [theWidgets objectForKey:key];
		id settingsValue = [defaults objectForKey:key];
        NSDictionary *item = nil;
        
		if( settingsValue != nil ) {
            //
            item = [self preferenceSpecifiersElementForKey:key];
            PSType = [self PSTypeOfSettingsElement:item];
//            NSLog(@"checking PSType :%@", PSType);

            if ([widget isKindOfClass:[UILabel class]]) {
                if ([PSType isEqualToString:@"PSMultiValueSpecifier"] ||
                    [PSType isEqualToString:@"PSTitleValueSpecifier"]) {
                    ((UILabel*)widget).text = [self titleForValue:settingsValue inValues:item];
                }else {
                    ((UILabel*)widget).text = [defaults valueForKey:key];
                }
            }
			if( [widget isKindOfClass:[UISwitch class]] ) {
				((UISwitch*)widget).on = [defaults boolForKey:key];
			}
			if( [widget isKindOfClass:[UISlider class]] ) {
				((UISlider*)widget).value = [defaults floatForKey:key];
			}
			if( [widget isKindOfClass:[UITextField class]] ) {
				((UITextField*)widget).text = [defaults stringForKey:key];
			}
			if( [widget isKindOfClass:[UISegmentedControl class]] ) {
				((UISegmentedControl*)widget).selectedSegmentIndex = [defaults integerForKey:key];
			}
			if( [widget isKindOfClass:[LSColorDisplay class]] ) {
  				UIColor * newColor = [ColorHelper colorFromString:[defaults stringForKey:key]];
				[((LSColorDisplay*)widget) setColorWith:newColor];
			}
		}
	}
//	[theKeys release];
	[pool release];
}

- (void) tellDelegateSettingsChanged
{
    if (delegate && [delegate respondsToSelector:@selector(settingsChanged:)]) {
        [self.delegate settingsChanged:self];
    }
}

- (void) saveSettingsToSystem_Actual
{
	if( !readyForSaving ) return;

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	//	for( id key in theWidgets ) //XXXXXX Dangerous!
	NSArray *theKeys = [theWidgets allKeys];
	for( id key in theKeys )
	{
		id widget = [theWidgets objectForKey:key];
		if( [widget isKindOfClass:[UISwitch class]] ) {
//			NSLog( @"Switch %@ is %s", key, [((UISwitch *)widget) isOn]?"On":"Off" ); // ZZZZZZZZZZZZZ
			[defaults setBool:[((UISwitch*)widget) isOn] forKey:key];
		}
		if( [widget isKindOfClass:[UISlider class]] ) {
			[defaults setFloat:((UISlider*)widget).value forKey:key];
		}
		if( [widget isKindOfClass:[UITextField class]] ) {
			[defaults setObject:((UITextField*)widget).text forKey:key];
		}
		if( [widget isKindOfClass:[UISegmentedControl class]] ) {
			[defaults setInteger:((UISegmentedControl*)widget).selectedSegmentIndex forKey:key];
		}
	}
//	[theKeys release];

	[defaults synchronize];
	[self autoEnableAndDisable];
	[self performSelectorOnMainThread:@selector( tellDelegateSettingsChanged ) withObject:nil waitUntilDone:NO];
	[pool release];
}


- (void) saveSettingsToSystem
{
	if( !readyForSaving ) return;

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	[self performSelectorOnMainThread:@selector( saveSettingsToSystem_Actual ) withObject:self waitUntilDone:YES];
	[self performSelectorInBackground:@selector( saveSettingsToSystem_Actual ) withObject:self];
	[pool release];
}


- (void) saveColorSettingsToSystem
{
	if( !readyForSaving ) return;

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	//	for( id key in theWidgets ) //XXXXXX Dangerous!
	NSArray *theKeys = [theWidgets allKeys];
	for( id key in theKeys )
	{
		id widget = [theWidgets objectForKey:key];

		if( [widget isKindOfClass:[LSColorDisplay class]] ) {
			LSColorDisplay * lscd = (LSColorDisplay *)widget;
			[defaults setObject:[ColorHelper stringFromColor:[lscd getColor]] forKey:key];
		}
	}
//	[theKeys release];

	[pool release];
}

- (void)receiveNotification:(NSNotification *)notify
{
    if (notify) {
        NSLog(@"notify :%@", notify);
    }
    
    [self performSelector:@selector(loadSettingsFromSystem) withObject:nil afterDelay:1.0f];
    if (delegate && [delegate respondsToSelector:@selector(userDefaultDidChanged)]) {
        [delegate userDefaultDidChanged];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource methods 


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSArray *preferenceSpecifiers = [theDictionary valueForKey:@"PreferenceSpecifiers"];
	
	// find the right section
//	int section = 0;
//	while( [self indexOfSection:section inSpecifierDictionary:preferenceSpecifiers] >= 0 )	
//		section++;
//	return section;
    NSLog(@"number of sections :%d", [self numberOfSectionsInSpecifierDictionary:preferenceSpecifiers]);
    return [self numberOfSectionsInSpecifierDictionary:preferenceSpecifiers];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSArray *preferenceSpecifiers = [theDictionary valueForKey:@"PreferenceSpecifiers"];
	
    beginWithOutGroupIdentifier = [self beginWithOutGroupSpecifier:[preferenceSpecifiers objectAtIndex:0]];
	// find the right section
	int idx = [self indexOfSection:section inSpecifierDictionary:preferenceSpecifiers];
    if (beginWithOutGroupIdentifier && idx == 0) {
        return @"";
    }
	
	// not found?
	if( idx == -1 ) return @"Bad Group Number";
	
	// return the content
	NSDictionary * aSpecifier = [preferenceSpecifiers objectAtIndex:idx];
	return [aSpecifier valueForKey:@"Title"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *preferenceSpecifiers = [theDictionary valueForKey:@"PreferenceSpecifiers"];
    beginWithOutGroupIdentifier = [self beginWithOutGroupSpecifier:[preferenceSpecifiers objectAtIndex:0]];
    
	NSLog(@"Section :%d, beginWithOutGroupIdentifier :%d;", section, beginWithOutGroupIdentifier);
    
	// find the right section
	int idx1 = [self indexOfSection:section inSpecifierDictionary:preferenceSpecifiers];
//    NSLog(@"idx1 :%d", idx1);
	if( idx1 < 0 ) return 0;
	
	// find the next section
	int idx2 = [self indexOfSection:section+1 inSpecifierDictionary:preferenceSpecifiers];
//    NSLog(@"idx2 :%d", idx2);
	// return the difference
	if( idx2 > 0 ) {
        if (beginWithOutGroupIdentifier && idx1 == 0) {
            NSLog(@"A numbers of section(%d) :%d", section, idx2 - idx1);
            return idx2 - idx1;
        }
        NSLog(@"B numbers of section(%d) :%d", section, idx2 - idx1 - 1);
        return (idx2 - idx1 - 1);
    }
	
	// return the difference to the end, if there was no "next" section
    if (beginWithOutGroupIdentifier && idx1 == 0) {
        NSLog(@"C numbers of section(%d) :%d", section, [preferenceSpecifiers count]);
        return [preferenceSpecifiers count];
    }
    NSLog(@"D numbers of section(%d) :%d", section, [preferenceSpecifiers count] - idx1 - 1);
	return [preferenceSpecifiers count] - idx1 - 1;
}

#define kUIRowHeight 50.0

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kUIRowHeight;
}




- (UITableViewCell *) tableView:(UITableView *)tableView
		  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	UITableViewCell *cell; //= [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:0] autorelease];

	//[self obtainTableCellForRow:row];
	
	NSString * type = [self propertyForRow:[indexPath row] inSection:[indexPath section] ofProperty:@"Type"];
	UIView * widg = [self widgetForRow:[indexPath row] inSection:[indexPath section]];
    NSLog(@"%s type :%@, (%d, %d)", __func__, type, indexPath.row, indexPath.section);
    
	if([type isEqualToString:@"PSToggleSwitchSpecifier"]
	   || [type isEqualToString:@"PSSliderSpecifier"]
	   || [type isEqualToString:@"BLColorPickerSpecifier"]
	   || [type isEqualToString:@"PSTitleValueSpecifier"]
	   || [type isEqualToString:@"PSTextFieldSpecifier"]
       || [type isEqualToString:@"PSMultiValueSpecifier"])
	{
		cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:0] autorelease];
		((DisplayCell *)cell).nameLabel.text = [self titleOfRow:[indexPath row] inSection:[indexPath section]];
		((DisplayCell *)cell).view = widg;
		
		if( [type isEqualToString:@"BLColorPickerSpecifier"] )
		{
            //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		}
        if ([type isEqualToString:@"PSMultiValueSpecifier"]) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        
	}
    
    if ([type isEqualToString:@"PSChildPaneSpecifier"]) {
		cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:0] autorelease];
		((DisplayCell *)cell).nameLabel.text = [self titleOfRow:[indexPath row] inSection:[indexPath section]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    if ([type isEqualToString:@"PSSliderSpecifier"]) {
        cell = [[[SliderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:0] autorelease];
        UISlider *_slider = (UISlider *)widg;
        ((SliderCell *)cell).slider = _slider;
    }

	if( [type isEqualToString:@"BLVolumeSpecifier"] )
	{
		cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:0] autorelease];
		((DisplayCell *)cell).nameLabel.text = [self titleOfRow:[indexPath row] inSection:[indexPath section]];
		
		CGRect frame = CGRectMake(0.0, 0.0, kSliderWidth, kSliderHeight);
		((DisplayCell *)cell).view = [[[MPVolumeView alloc] initWithFrame:frame] autorelease];
	}
	
	if(	[type isEqualToString:@"BLSegmentedSpecifier"] )
	{
		cell = [[[CellFullWide alloc] initWithFrame:CGRectZero reuseIdentifier:0] autorelease];
		((CellFullWide *)cell).view = widg;	
	}
	
	if([type isEqualToString:@"BLFullButtonSpecifier"]
	   || [type isEqualToString:@"BLURLButtonSpecifier"])
	{
		cell = [[[ButtonCell alloc] initWithFrame:CGRectZero reuseIdentifier:0] autorelease];
		((ButtonCell *)cell).nameLabel.text = [self titleOfRow:[indexPath row] inSection:[indexPath section]];
		[(ButtonCell *)cell layoutSubviews];
	}
    
	return cell;
}


- (void)OpenWebWindowWithURL:(NSString *)theURL restrictive:(BOOL)rst withTitle:(NSString *)title preload:(BOOL)_preload
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// first check to see if we've already loaded it in the list
	WebViewController * cwvc = [theWebViews objectForKey:theURL];
	if( cwvc ) {
		wvc = cwvc;
		[wvc addViewAndTransitionIn];
		[pool release];
		return;
	}
	
	// nope.  it's a live load.
	wvc = [[WebViewController alloc] init];
	if( _preload ) {
		[wvc setDisplayLater:YES];
	} else {
		[wvc setWaitUntilLoad:NO];
		[wvc setBlackScreenUntilLoad:YES];
	}
	[wvc loadView:rst withTitle:title];
	if( [[[theURL substringToIndex:4] uppercaseString]isEqualToString:@"HTTP"] )
	{
		// offsite link
		[wvc loadURL:theURL];
	} else if( [[[theURL substringToIndex:4] uppercaseString]isEqualToString:@"FILE"] )
	{
		// local file link
		[wvc loadURL:theURL];
	} else {
		// WebKitErrorDomain error 101
		NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:theURL];
		[wvc loadLocalFile:filePath];
	}
	
	if( _preload && !cwvc) {
		[theWebViews setObject:wvc forKey:theURL];
		wvc = nil;
	}
	
	[pool release];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	/*
	 To conform to the Human Interface Guidelines, selections should not be persistent --
	 deselect the row after it has been selected.
	 */
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString * webTitle = [self propertyForRow:[indexPath row] inSection:[indexPath section] ofProperty:@"WebTitle" orFallBackOnProperty:@"Title"]; 
	NSString * type = [self propertyForRow:[indexPath row] inSection:[indexPath section] ofProperty:@"Type"];
	NSString * key = [self propertyForRow:[indexPath row] inSection:[indexPath section] ofProperty:@"Key"];
	if( [type isEqualToString:@"BLFullButtonSpecifier"] ) {
        if (delegate && [delegate respondsToSelector:@selector(buttonPressed:inSettings:)]) {
            [self.delegate buttonPressed:key inSettings:self];
        }
    }
	if( [type isEqualToString:@"BLURLButtonSpecifier"] ) {
		BOOL Preload = [self boolForRow:[indexPath row] inSection:[indexPath section] ofProperty:@"Preload"];
		BOOL ExternalLaunch = [self boolForRow:[indexPath row] inSection:[indexPath section] ofProperty:@"ExternalLaunch"];
		if( !ExternalLaunch ) {
			BOOL isRestrictive = [self boolForRow:[indexPath row] inSection:[indexPath section] ofProperty:@"Restrictive"];
			[self OpenWebWindowWithURL:key restrictive:isRestrictive withTitle:webTitle preload:Preload];
		} else {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:key]];
		}
	}
	/*
	if( [type isEqualToString:@"BLColorPickerSpecifier"] ) {
		[self pickNewColorForRow:[indexPath row] inSection:[indexPath section]];
	}
	 */
    if ([type isEqualToString:@"PSMultiValueSpecifier"]) {
        if (delegate && [delegate respondsToSelector:@selector(buttonPressed:inSettings:)]) {
            [self.delegate buttonPressed:key inSettings:self];
        }
    }
    
    if ([type isEqualToString:@"PSChildPaneSpecifier"]) {
        if (delegate && [delegate respondsToSelector:@selector(childPanelPressed:inSettings:)]) {
            [self.delegate childPanelPressed:(NSDictionary *)[self itemAtRow:indexPath.row inSection:indexPath.section] inSettings:self];
        }
    }
    
	[pool release];
}

#pragma mark - Extended

/**
 Return title for the value if which exist in values titles paire of the settings element or value self.
 */
- (id)titleForValue:(id)value inValues:(NSDictionary *)dictionary
{
    NSArray *titles = [dictionary objectForKey:@"Titles"];
    NSArray *values = [dictionary objectForKey:@"Values"];
    if (!titles || !values) {
        return value;
    }
    
    id _value = nil;
    int i = 0;
    for (_value in values) {
        if ([_value isEqual:value]) {
            break;
        }
        i++;
    }
    if (_value && i >= 0 && i < [titles count]) {
        return [titles objectAtIndex:i];
    }
    
    return value;
}

- (NSString *)PSTypeOfSettingsElement:(NSDictionary *)dict
{
    return [dict objectForKey:@"Type"];
}

/**
 Return an element from
 */
- (NSDictionary *)preferenceSpecifiersElementForKey:(NSString *)key
{
    NSArray *preferences = [theDictionary objectForKey:@"PreferenceSpecifiers"];
    for (NSDictionary *element in preferences) {
        if ([[element valueForKey:@"Key"] isEqualToString:key]) {
            return element;
        }
    }
    return nil;
}

- (id)settingsValueForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id value = [defaults valueForKey:key];
    if (value) {
        return value;
    }
    
    NSDictionary *aSpecifiers = [self itemForKey:key];
    return [aSpecifiers valueForKey:@"DefaultValue"];
}

#pragma mark - testing

- (void)testCase
{
    NSArray *preferenceSpecifiers = [theDictionary valueForKey:@"PreferenceSpecifiers"];
    NSInteger testid = -1;
    
    NSLog(@"pre :%@\n\n\n\n", [preferenceSpecifiers classForCoder]);
    
    testid = [self indexOfSection:0 inSpecifierDictionary:preferenceSpecifiers];
    NSLog(@"testid :%d", testid);
    testid = [self indexOfSection:1 inSpecifierDictionary:preferenceSpecifiers];
    NSLog(@"testid :%d", testid);
    
    testid = [self numberOfSectionsInSpecifierDictionary:preferenceSpecifiers];
    NSLog(@"testid :%d", testid);
    
    
    NSLog(@"\n\n\n\n");
}

@end
