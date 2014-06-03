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
		
		var time: CGFloat = 12;
		while time > 0
		{
			self.drawHandForTime(time, total: 12, context:context);
			time--;
		}
	}
	
	func drawHandForTime(time: CGFloat, total: CGFloat, context: CGContext)
	{
		var degreesPerTime: CGFloat = 360 / total;
		var radians: CGFloat = (degreesPerTime * M_PI) / 180;
		var angle: CGFloat = -(radians * time - M_PI_2);
		
		var x: CGFloat = cos(angle);
		var y: CGFloat = sin(angle);
		
		var xOffset: CGFloat = 100 + (cos(angle) * 100);
		var yOffset: CGFloat = 100 + (sin(angle) * 100);
		
		var frame: CGRect = CGRectMake(xOffset, yOffset, 10, 10);
		
		CGContextSetFillColorWithColor(context, NSColor.whiteColor().CGColor);
		CGContextFillRect(context, frame);
	}
}
