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
	func secondsAgo() -> Double
	{
		let comps: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.SecondCalendarUnit, fromDate: self);
		return Double(comps.second) / 60;
	}
	
	func minutesAgo() -> Double
	{
		let comps: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.MinuteCalendarUnit, fromDate: self);
		return Double(comps.minute) / 60.0 + self.secondsAgo() / 60.0;
	}
	
	func hoursAgo() -> Double
	{
		let comps: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.HourCalendarUnit, fromDate: self);
		return Double(comps.hour) / 12.0 + (Double((self.minutesAgo() / 60.0) * (60.0 / 12.0)));
	}
}
