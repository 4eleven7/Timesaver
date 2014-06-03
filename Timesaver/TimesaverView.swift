//
//  TimesaverView.swift
//  Timesaver
//
//  Created by Daniel Love on 02/06/2014.
//  Copyright (c) 2014 Daniel Love. All rights reserved.
//

import Cocoa
import ScreenSaver

class TimesaverView: ScreenSaverView
{
	var configurationWindowController: VLNConfigurationWindowController;
	var configuration: VLNConfiguration;
	
	init(frame: NSRect, isPreview: Bool)
	{
		self.configuration = VLNConfiguration();
		self.configurationWindowController = VLNConfigurationWindowController(configuration: self.configuration);
		
		super.init(frame: frame, isPreview: isPreview);
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "configurationChanged", name: VLNScreenSaverDefaultsChangedNotification, object: nil);
		
		self.setAnimationTimeInterval(1/30.0);
	}
	
	deinit
	{
		NSNotificationCenter.defaultCenter().removeObserver(self, name: VLNScreenSaverDefaultsChangedNotification, object: nil);
	}
	
	func configurationChanged()
	{
		needsDisplay = true;
	}
	
	override func startAnimation()
	{
		super.startAnimation();
	}
	
	override func stopAnimation()
	{
		super.stopAnimation();
	}
	
	override func animateOneFrame()
	{
		needsDisplay = true;
	}
	
	override func hasConfigureSheet() -> Bool
	{
		return true;
	}
	
	override func configureSheet() -> NSWindow!
	{
		return self.configurationWindowController.window;
	}
	
	override func drawRect(rect: NSRect)
	{
		var contextPointer: COpaquePointer = NSGraphicsContext.currentContext().graphicsPort();
		var context: CGContext = Unmanaged.fromOpaque(contextPointer).takeUnretainedValue()
		
		var backgroundColor = self.configuration.backgroundColor.color();
		
		CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
		
		CGContextFillRect(context, rect);
	}
}
