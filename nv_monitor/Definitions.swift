//
//  Definitions.swift
//  nv_monitor
//
//  Created by Ivan Sahumbaiev on 27/06/2018.
//  Copyright © 2018 Ivan Sahumbaiev. All rights reserved.
//



import Cocoa

class Definitions{
    
    static let TARGET_GPU_ID = 1
    
    static let REMOTE_HOST = "PLACE IP ADDRESS OF THE REMOTE SERVER";
    static let REMOTE_USER = "PLACE LOGIN";
    static let REMOTE_PASSWORD = "PLACE PASSWORD";
    
    static let SSH_FILE_NAME = "ssh_load"
    
    static let UPDATE_RATE_SEC = 5 * 60.0
    
    static let GPU_IMAGE = NSImage(named: NSImage.Name("Gpu_Model"))
    static let UNKNOWN = "Unknown"
    
    static let REG_PATTERN = "GeForce GTX 1080 Ti, (?:[0-9]\\d?|100), (?:[0-9]\\d?|100), (?:[0-9]\\d?|100)"
    
    enum Status{
        case OK
        case FAIL
        case CONNECTION
        case DISSCONECTED
    }
    
    static func getImageByStatus(status: Definitions.Status) -> NSImage {
        var image_name = "Unknown"
        switch status {
        case .FAIL:
            image_name = "Status_Fail"
        case .CONNECTION:
            image_name = "Status_CONN"
        case .DISSCONECTED:
            image_name = "Status_DISCONN"
        case .OK:
            image_name = "Status_OK"
        }
        
        return NSImage(named:NSImage.Name(image_name))!
    }
}
