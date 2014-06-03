//
//  VLNConfiguration.m
//  Timesaver
//
//  Created by Daniel Love on 02/06/2014.
//  Copyright (c) 2014 Daniel Love. All rights reserved.
//

import Cocoa
import ScreenSaver

var VLNScreenSaverDefaultsModuleName: String = "net.daniellove.Timersaver";
var VLNScreenSaverDefaultsChangedNotification: String = "VLNScreenSaverDefaultsChangedNotification";
var VLNScreenSaverDefaultBackgroundColor: String = "VLNScreenSaverDefaultBackgroundColor";

enum VLNBackgroundColor: Int
{
	case Black, White, Blue
	func color() -> NSColor
	{
		switch self
		{
			case .Black:
				return NSColor.blackColor();
			
			case .White:
				return NSColor.whiteColor();
			
			case .Blue:
				return NSColor.blueColor();
			
			default:
				return NSColor.grayColor();
		}
	}
}

class VLNConfiguration: NSObject
{
	var defaults: ScreenSaverDefaults;
	
	init()
	{
		self.defaults = ScreenSaverDefaults.defaultsForModuleWithName(VLNScreenSaverDefaultsModuleName) as ScreenSaverDefaults;
		
		super.init();
		
		self.registerDefaults();
		self.revertChanges();
	}
	
	func registerDefaults()
	{
		self.defaults.registerDefaults([
			VLNScreenSaverDefaultBackgroundColor: NSColor.blackColor()
		]);
	}
	
	func revertChanges()
	{
		self.backgroundColor = VLNBackgroundColor.fromRaw(self.defaults.integerForKey(VLNScreenSaverDefaultBackgroundColor));
		
		configurationDidChange();
	}
	
	func saveChanges()
	{
		self.defaults.setInteger(self.backgroundColor.toRaw(), forKey: VLNScreenSaverDefaultBackgroundColor);
		self.defaults.synchronize();
		
		configurationDidChange();
	}
	
	func configurationDidChange ()
	{
		NSNotificationCenter.defaultCenter().postNotificationName(VLNScreenSaverDefaultsChangedNotification, object: nil);
	}
	
	var backgroundColor: VLNBackgroundColor!
	{
		didSet
		{
			configurationDidChange();
		}
	}
}
