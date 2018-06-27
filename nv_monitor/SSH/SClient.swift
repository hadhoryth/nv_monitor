//
//  ServerConnector.swift
//  nvidia_monitor
//
//  Created by Ivan Sahumbaiev on 25/06/2018.
//  Copyright © 2018 Ivan Sahumbaiev. All rights reserved.
//

import Foundation

extension String {
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}


class SCLient{
    
    var outputPipe:Pipe!
    var buildTask:Process!
    var GPUList = [GPUModel]()
    
    func cleanCache(){
        if self.GPUList.count > 0{
            print("cleaning cache")
            self.GPUList.removeAll()
        }
    }
    
    
    func getCommandPath(commandName:String) -> String? {
        guard let path = Bundle.main.path(forResource: commandName, ofType:"command") else { print("Unable to locate .command script")
            return nil
        }
        return path
    }
    
    func captureStandardOutput(_ task:Process){
        outputPipe = Pipe()
        task.standardOutput = outputPipe
    
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) {
            notification in
            
            let output = self.outputPipe.fileHandleForReading.availableData
            let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
            
            let tmp = self.matches(for: Definitions.REG_PATTERN, in: outputString)
            if tmp.count > 0{
                for match in tmp{
                    let parts = match.split{$0 == ","}.map(String.init)
                    let model = GPUModel(id: parts[1], name: parts[0], temp: parts[2], util: parts[3])
                    self.GPUList.append(model)
                }
            }
//            if outputString.hasPrefix("GeForce"){
//                print(outputString)
//                for str in outputString.lines{
//                    print(str)
//
//
//                }
//            }else{
            self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
//            }
        }
        
    }
    
    private func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    
    
}
