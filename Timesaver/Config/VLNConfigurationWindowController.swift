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
	@IBOutlet var backgroundPopup: NSPopUpButton;
	
	var configuration: VLNConfiguration;
	
	init(configuration: VLNConfiguration)
	{
		self.configuration = configuration;
		
		super.init(window: nil);
	}
	
	override func awakeFromNib()
	{
		self.backgroundPopup.selectItemAtIndex(self.configuration.backgroundColor.toRaw());
	}
	
	override var windowNibName: String!
	{
		get
		{
			return "ConfigurationWindow";
		}
	}
	
	@IBAction func saveAndClose(button: NSButton)
	{
		self.configuration.saveChanges();
		self.window.sheetParent.endSheet(self.window, returnCode: NSModalResponseOK);
	}
	
	@IBAction func cancelAndClose(button: NSButton)
	{
		self.configuration.revertChanges();
		self.window.sheetParent.endSheet(self.window, returnCode: NSModalResponseOK);
	}
	
	@IBAction func backgroundPopUpChanged(popup: NSPopUpButton)
	{
		self.configuration.backgroundColor = VLNBackgroundColor.fromRaw(popup.indexOfSelectedItem);
	}
}
