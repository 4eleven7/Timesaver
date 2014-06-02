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
	init(frame: NSRect, isPreview: Bool)
	{
		super.init(frame: frame, isPreview: isPreview);
		
		self.setAnimationTimeInterval(1/30.0);
	}
	
	override func startAnimation()
	{
		super.startAnimation();
	}
	
	override func stopAnimation()
	{
		super.stopAnimation();
	}
	
	override func drawRect(rect: NSRect)
	{
		NSColor.blueColor().setFill();
		NSRectFill(rect);
	}
	
	override func animateOneFrame()
	{
		displayIfNeeded();
	}
	
	override func hasConfigureSheet() -> Bool
	{
		return true;
	}
	
	override func configureSheet() -> NSWindow!
	{
		return nil;
	}
}
