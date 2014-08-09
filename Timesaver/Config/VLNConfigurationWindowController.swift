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
	@IBOutlet var backgroundPopup: NSPopUpButton!;
	
	var configuration: VLNConfiguration;
	
	required init(coder: NSCoder!)
	{
		self.configuration = VLNConfiguration();
		
		super.init(coder: coder);
	}
	
	init(configuration: VLNConfiguration)
	{
		self.configuration = configuration;
		
		super.init(window: nil);
	}
	
	override var windowNibName: String!
	{
		get {
			return "ConfigurationWindow";
		}
	}
	
	override func awakeFromNib()
	{
		loadDefaultValues();
	}
	
	func loadDefaultValues()
	{
		self.backgroundPopup.selectItemAtIndex(self.configuration.backgroundColor.toRaw());
	}
	
	@IBAction func saveAndClose(button: NSButton)
	{
		self.configuration.saveChanges();
		self.window.sheetParent.endSheet(self.window, returnCode: NSModalResponseOK);
	}
	
	@IBAction func cancelAndClose(button: NSButton)
	{
		self.configuration.revertChanges();
		loadDefaultValues();
		self.window.sheetParent.endSheet(self.window, returnCode: NSModalResponseOK);
	}
	
	@IBAction func backgroundPopUpChanged(popup: NSPopUpButton)
	{
		self.configuration.backgroundColor = VLNBackgroundColor.fromRaw(popup.indexOfSelectedItem);
	}
}
