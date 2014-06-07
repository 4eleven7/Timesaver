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
		var context: CGContextRef = Unmanaged.fromOpaque(contextPointer).takeUnretainedValue()
		
		var backgroundColor = self.configuration.backgroundColor.color();
		
		CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
		CGContextFillRect(context, rect);
		
		var clockFrame: CGRect = self.clockSizeInRect(rect);
		self.drawHours(clockFrame, context:context);
		self.drawTicks(clockFrame, context:context);
	}
	
	func drawHours(rect:CGRect, context:CGContextRef)
	{
		var radius: CGFloat = CGRectGetWidth(rect) / 2;
		var center: CGPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
		
		var time:Double = 12;
		while time > 0
		{
			var angle: CGFloat = self.angleForTimeUnit(time, total: 12);
			
			var x: CGFloat = center.x + (cos(angle) * radius);
			var y: CGFloat = center.y + (sin(angle) * radius);
			
			var hour:NSString = "\(Int(time))";
			var textAttributes = [NSForegroundColorAttributeName:NSColor.whiteColor()];
			var textSize:CGSize = hour.sizeWithAttributes(textAttributes);
			
			var frame: CGRect = CGRectMake(x-textSize.width/2, y-textSize.height/2, textSize.width, textSize.height);
			hour.drawInRect(frame, withAttributes: textAttributes);
			
			time--;
		}
	}
	
	func drawTicks(rect:CGRect, context:CGContextRef)
	{
		var radius: CGFloat = CGRectGetWidth(rect) / 2;
		var center: CGPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
		
		var time:Double = 60;
		while time > 0
		{
			var angle: CGFloat = self.angleForTimeUnit(time, total: 60);
			
			var x: CGFloat = center.x + (cos(angle) * radius);
			var y: CGFloat = center.y + (sin(angle) * radius);
			
			var frame: CGRect = CGRectMake(x, y, 1, 1);
			
			CGContextSetFillColorWithColor(context, NSColor.whiteColor().CGColor);
			CGContextFillRect(context, frame);
			
			time--;
		}
	}
	
	/**
	 * Size and positioning
	 */
	func clockSizeInRect(rect:CGRect) -> CGRect
	{
		var clockFrame:CGRect = rect;
		var percentage:CGFloat = 0.3;
		if self.isPreview() == true {
			percentage = 0.5;
		}
		
		clockFrame.size.width = CGRectGetWidth(clockFrame) * percentage;
		clockFrame.size.height = clockFrame.size.width;
		
		return SSCenteredRectInRect(clockFrame, rect);
	}
	
	func angleForTimeUnit(time:CDouble, total:CDouble) -> CGFloat
	{
		var degreesPerTime: CDouble = 360 / total;
		var radians: CDouble = (degreesPerTime * M_PI) / 180;
		var angle: CDouble = -(radians * time - M_PI_2);
		
		return angle;
	}
}
