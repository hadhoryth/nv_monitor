//
//  NSElements.swift
//  nv_monitor
//
//  Created by Ivan Sahumbaiev on 27/06/2018.
//  Copyright © 2018 Ivan Sahumbaiev. All rights reserved.
//

import Cocoa

class NSElements{
    
    static func getQuitButton(rect: NSRect) -> NSButton{
        let quitButton = NSButton(frame: rect)
        quitButton.title = "Quit"
        quitButton.isBordered = false
        quitButton.font = NSFont(name: "Helvetica Bold", size: 12)
        quitButton.isHighlighted = false
        return quitButton
    }
    
    static func getInfoLabel(rect: NSRect) -> NSTextField{
        let infoLabel = NSTextField(frame: rect)
        infoLabel.isBordered = false
        infoLabel.stringValue = "Last update undefined"
        infoLabel.alignment = .center
        infoLabel.font = NSFont(name: "Helvetica Light", size: 10)
        infoLabel.textColor = NSColor.lightGray
        infoLabel.drawsBackground = false
        infoLabel.isSelectable = false
        return infoLabel
    }
    
    static func getForceRefrash(rect: NSRect) -> NSButton{
        let forceRefresh = NSButton(frame: rect)
        forceRefresh.isBordered = false
        forceRefresh.image = NSImage(named: NSImage.Name("Refresh"))
        
        return forceRefresh
    }
    
}
