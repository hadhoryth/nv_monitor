//
//  GPUModel.swift
//  nvidia_monitor
//
//  Created by Ivan Sahumbaiev on 26/06/2018.
//  Copyright © 2018 Ivan Sahumbaiev. All rights reserved.
//

import Cocoa

class GPUModel{
    
    var id: String
    var name: String
    var temp: String
    var util: String
    
    var intId: Int{
        get {
            return Int(id.trimmingCharacters(in: .whitespaces))!
        }
    }
    
    var utilPercent: Double{
        get {
            return Double(util.trimmingCharacters(in: .whitespaces))!
        }
    }
    
    init(id: String, name: String, temp: String, util:String) {
        self.id = id
        self.name = name
        self.temp = temp
        self.util = util
    }
    
    func getStatus() -> String{        
        return "Utilization: \(self.util)% Temp: \(self.temp) ºC"
    }
    
    func getId() -> String{
        return "Id: \(self.id)"
    }
    
    func printModel(){
        print("GPU id -->\(self.id)\nGPU name --> \(self.name)\nGPU temp --> \(self.temp)\nGPU utilization --> \(self.util)")
        print("---------------------\n")
    }
    
}
