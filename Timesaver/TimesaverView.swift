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
	
	required init(coder: NSCoder)
	{
		self.configuration = VLNConfiguration();
		self.configurationWindowController = VLNConfigurationWindowController(configuration: self.configuration);
		
		super.init(coder: coder);
	}
	
	override init(frame: NSRect, isPreview: Bool)
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
	
// MARK: Drawing
	
	override func drawRect(rect: NSRect)
	{
		var context: CGContextRef = NSGraphicsContext.currentContext().CGContext;
		
		var backgroundColor = self.configuration.backgroundColor.color();
		
		CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
		CGContextSetAlpha(context, 0.9);
		CGContextFillRect(context, rect);
		
		var clockFrame: CGRect = self.clockSizeInRect(rect);
		self.drawClockFace(clockFrame, context: context);
		self.drawTicks(clockFrame, context:context);
		
		// Clock hands
		var date: NSDate = NSDate.date();
		
		var hours: CGFloat = date.hoursAgo();
		self.drawClockHand(clockFrame, context:context, size:0.6, progress:hours * 12, total:12);
		
		var minutes: CGFloat = date.minutesAgo();
		self.drawClockHand(clockFrame, context:context, size:0.9, progress:minutes * 60, total:60);
		
		var seconds: CGFloat = date.secondsAgo();
		self.drawClockHand(clockFrame, context:context, size:1.0, progress:seconds * 60, total:60);
	}
	
	func drawTicks(rect:CGRect, context:CGContextRef)
	{
		CGContextSaveGState(context);
		
		NSColor.whiteColor().setStroke();
		CGContextSetLineCap(context, kCGLineCapRound);
		CGContextSetLineWidth(context, self.tickWidthInRect(rect));
		CGContextSetStrokeColorWithColor(context, NSColor.blackColor().CGColor);
		CGContextSetAlpha(context, 0.5);
		
		var radius: CGFloat = CGRectGetWidth(rect) / 2 - (self.clockRadiusInRect(rect) * 2);
		var center: CGPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
		
		var hourWidth = self.tickSizeInRect(rect);
		var minuteWidth = self.tickSizeInRect(rect) * 0.5;
		
		var time: Double = 12;
		while time > 0
		{
			var angle: CGFloat = self.angleForTimeUnit(time, total: 12);
			
			var x: CGFloat = center.x + (cos(angle) * radius);
			var y: CGFloat = center.y + (sin(angle) * radius);
			
			var hour = time % 3;
			var width: CGFloat;
			if (hour == 0) {
				width = hourWidth;
			} else {
				width = minuteWidth;
			}
			
			var x2: CGFloat = center.x + (cos(angle) * (radius - width));
			var y2: CGFloat = center.y + (sin(angle) * (radius - width));
			
			CGContextBeginPath(context);
			CGContextMoveToPoint(context, x, y);
			CGContextAddLineToPoint(context, x2, y2);
			CGContextStrokePath(context);
			
			time--;
		}
		
		CGContextRestoreGState(context);
	}
	
	func drawClockFace(rect:CGRect, context:CGContextRef)
	{
		CGContextSaveGState(context);
		
		var radius = self.clockRadiusInRect(rect);
		CGContextAddEllipseInRect(context, CGRectInset(rect, radius, radius));
		CGContextSetFillColorWithColor(context, NSColor.whiteColor().CGColor);
		CGContextSetAlpha(context,0.05);
		CGContextFillPath(context);
		
		CGContextAddEllipseInRect(context, rect);
		CGContextSetLineWidth(context, radius);
		CGContextSetStrokeColorWithColor(context, NSColor.whiteColor().CGColor);
		CGContextSetAlpha(context, 0.1);
		CGContextStrokePath(context);
		
		CGContextRestoreGState(context);
	}
	
// MARK: Drawing clock hands
	
	func drawClockHand(rect:CGRect, context: CGContextRef, size:CGFloat, progress:CGFloat, total:CGFloat)
	{
		var center: CGPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
		
		var sizeHeight: CGFloat = self.clockHandHeightInRect(rect) * size;
		
		var angle: CGFloat = self.angleForTimeUnit(CDouble(progress), total: CDouble(total));
		var x: CGFloat = center.x + (cos(angle) * sizeHeight);
		var y: CGFloat = center.y + (sin(angle) * sizeHeight);
		var point: CGPoint = CGPointMake(x, y);
		
		CGContextSaveGState(context);
		
		CGContextSetLineWidth(context, self.clockHandWidthInRect(rect));
		CGContextSetStrokeColorWithColor(context, NSColor.whiteColor().CGColor);
		
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, center.x, center.y);
		CGContextAddLineToPoint(context, point.x, point.y);
		CGContextStrokePath(context);
	}
	
// MARK: Relative size and positioning
	
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
	
	func clockRadiusInRect(rect:CGRect) -> CGFloat
	{
		var percentage:CGFloat = 0.02;
		return CGRectGetWidth(rect) * percentage;
	}
	
	func clockHandHeightInRect(rect:CGRect) -> CGFloat
	{
		var percentage:CGFloat = 0.4;
		return CGRectGetWidth(rect) * percentage;
	}
	
	func clockHandWidthInRect(rect:CGRect) -> CGFloat
	{
		var percentage:CGFloat = 0.02;
		return CGRectGetWidth(rect) * percentage;
	}
	
	func tickSizeInRect(rect:CGRect) -> CGFloat
	{
		var percentage:CGFloat = 0.1;
		return CGRectGetWidth(rect) * percentage;
	}
	
	func tickWidthInRect(rect:CGRect) -> CGFloat
	{
		var percentage:CGFloat = 0.02;
		return CGRectGetWidth(rect) * percentage;
	}
	
	func angleForTimeUnit(time:CDouble, total:CDouble) -> CGFloat
	{
		var degreesPerTime: CDouble = 360 / total;
		var radians: CDouble = (degreesPerTime * M_PI) / 180;
		var angle: CDouble = -(radians * time - M_PI_2);
		
		return CGFloat(angle);
	}
}
