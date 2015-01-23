// Playground - noun: a place where people can play

import Cocoa

var totalHours: CGFloat = 12;

for hour in 0..totalHours
{
	var degreesPerTime: CGFloat = 360 / totalHours;
	var radians: CGFloat = (degreesPerTime * M_PI) / 180;
	var angle: CGFloat = -(radians * hour - M_PI_2);
	
	var x: CGFloat = cos(angle);
	var y: CGFloat = sin(angle);
	
	var xOffset: CGFloat = 100 + (cos(angle) * 100);
	var yOffset: CGFloat = 100 + (sin(angle) * 100);
}