//
//  gpuView.swift
//  nv_monitor
//
//  Created by Ivan Sahumbaiev on 27/06/2018.
//  Copyright © 2018 Ivan Sahumbaiev. All rights reserved.
//

import Cocoa

class gpuView: NSView {

    @IBOutlet var view: NSView!
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var status: NSTextField!
    @IBOutlet weak var id: NSTextField!
    @IBOutlet weak var indicator: NSLevelIndicator!
    
    func updateView(name: String, id: String, status: String, percent: Double){
        self.image.image = Definitions.GPU_IMAGE
        self.name.stringValue = name
        self.id.stringValue = id
        self.status.stringValue = status
        self.indicator.doubleValue = percent
    }
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
        
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    private func commonInit(){
        let myName = type(of: self).className().components(separatedBy: ".").last!
        let nib = NSNib(nibNamed: NSNib.Name(rawValue: myName), bundle: Bundle(for: type(of: self)))
        nib?.instantiate(withOwner: self, topLevelObjects: nil)
        var newConstraints: [NSLayoutConstraint] = []
        for oldConstraint in view.constraints {
            let firstItem = oldConstraint.firstItem === view ? self : oldConstraint.firstItem!
            let secondItem = oldConstraint.secondItem === view ? self : oldConstraint.secondItem
            newConstraints.append(NSLayoutConstraint(item: firstItem, attribute: oldConstraint.firstAttribute, relatedBy: oldConstraint.relation, toItem: secondItem, attribute: oldConstraint.secondAttribute, multiplier: oldConstraint.multiplier, constant: oldConstraint.constant))
        }
                
        for newView in view.subviews {
            self.addSubview(newView)
        }
        
        self.image.imageScaling = .scaleAxesIndependently
        
    }
    
}
