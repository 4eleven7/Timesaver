//
//  AppDelegate.swift
//  TimesaverApp
//
//  Created by Daniel Love on 02/06/2014.
//  Copyright (c) 2014 Daniel Love. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate
{
	@IBOutlet var window: NSWindow;
	
	var screensaver: TimesaverView;
	var animationTimer: NSTimer?;
	
	init()
	{
		self.screensaver = TimesaverView(frame: NSZeroRect, isPreview: false);
		
		super.init();
	}
	
	func applicationDidFinishLaunching(notification: NSNotification!)
	{
		self.screensaver.frame = self.window.contentView.bounds;
		self.window.contentView.addSubview(self.screensaver);
		
		self.startAnimation();
	}
	
	@IBAction func openConfiguration(sender: AnyObject)
	{
		if !self.screensaver.hasConfigureSheet() {
			return;
		}
		
		stopAnimation();
		
		self.window.beginSheet(self.screensaver.configureSheet(), completionHandler: { (NSModalResponse) -> Void in
																							self.startAnimation();
																					 });

	}
	
	func startAnimation ()
	{
		if self.animationTimer? {
			return;
		}
		
		self.animationTimer = NSTimer.scheduledTimerWithTimeInterval(self.screensaver.animationTimeInterval(), target: self.screensaver, selector: "animateOneFrame", userInfo: nil, repeats: true);
	}
	
	func stopAnimation ()
	{
		self.animationTimer?.invalidate();
		self.animationTimer = nil;
	}
}
