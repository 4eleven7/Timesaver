//
//  VLNConfigurationWindowController.swift
//  Timesaver
//
//  Created by Daniel Love on 02/06/2014.
//  Copyright (c) 2014 Daniel Love. All rights reserved.
//

import Cocoa

class VLNConfigurationWindowController: NSWindowController
{
	override var windowNibName: String!
	{
		get
		{
			return "ConfigurationWindow";
		}
	}
	
	@IBAction func saveAndClose(id: AnyObject)
	{
		self.window.sheetParent.endSheet(self.window, returnCode: NSModalResponseOK);
	}
	
	@IBAction func cancelAndClose(id: AnyObject)
	{
		self.window.sheetParent.endSheet(self.window, returnCode: NSModalResponseOK);
	}
}
