//
//  DateExtensions.swift
//  Timesaver
//
//  Created by Daniel Love on 14/06/2014.
//  Copyright (c) 2014 Daniel Love. All rights reserved.
//

import Cocoa

extension NSDate
{
	func secondsAgo() -> CGFloat
	{
		let comps: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.SecondCalendarUnit, fromDate: self);
		return CGFloat(comps.second) / 60;
	}
	
	func minutesAgo() -> CGFloat
	{
		let comps: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.MinuteCalendarUnit, fromDate: self);
		return CGFloat(comps.minute) / 60.0 + self.secondsAgo() / 60.0;
	}
	
	func hoursAgo() -> CGFloat
	{
		let comps: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.HourCalendarUnit, fromDate: self);
		return CGFloat(comps.hour) / 12.0 + (CGFloat((self.minutesAgo() / 60.0) * (60.0 / 12.0)));
	}
}
