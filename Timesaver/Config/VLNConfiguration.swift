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
	case Black, White
	func color() -> NSColor
	{
		switch self
		{
			case .Black:
				return NSColor.blackColor();
			
			case .White:
				return NSColor.whiteColor();
			
			default:
				return NSColor.grayColor();
		}
	}
}

class VLNConfiguration: NSObject
{
	var defaults: ScreenSaverDefaults;
	
	var backgroundColor: VLNBackgroundColor!
	{
		didSet
		{
			configurationDidChange();
		}
	}
	
	override init()
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
}
