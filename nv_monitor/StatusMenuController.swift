//
//  StatusMenuController.swift
//  nv_monitor
//
//  Created by Ivan Sahumbaiev on 26/06/2018.
//  Copyright © 2018 Ivan Sahumbaiev. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var infoLabel: NSTextField = NSTextField()
    
    var numGPU: Int = 3
    var gpuViews = [NSView]()
    var sshClient: SCLient = SCLient()
    weak var timer: Timer?
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: Definitions.UPDATE_RATE_SEC, repeats: true) { [weak self] _ in
            self?.doUpdate()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    deinit {
        stopTimer()
    }
    
    override func awakeFromNib() {
        statusItem.menu = statusMenu
        self.requestUpdate()
        createMenu()
        startTimer()
        
    }
    
    @objc func doUpdate(){
        self.sshClient.cleanCache()
        self.requestUpdate()
    }
    
    private func addInfo(){
        let stack = NSStackView(frame: NSRect(x: 0, y: 0, width: 265, height: 15))
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        self.infoLabel = NSElements.getInfoLabel(rect: NSRect(x: 0, y: 0, width: 60, height: 12))
        stack.addView(self.infoLabel, in: .center)

        let quitButton = NSElements.getQuitButton(rect: NSRect(x: 0, y: 0, width: 40, height: 15))
        quitButton.target = self
        quitButton.action = #selector(self.closeApp)
        stack.addView(quitButton, in: .center)
        
        let infoItem = NSMenuItem()
        infoItem.view = stack        
        self.statusMenu.addItem(infoItem)
    }
    
    func addForceUpdate(){
        let stack = NSStackView(frame: NSRect(x: 0, y: 0, width: 265, height: 17))
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let targetLabel = NSElements.getInfoLabel(rect: NSRect(x: 0, y: 0, width: 40, height: 15))
        targetLabel.stringValue = "Target GPU ID: \(Definitions.TARGET_GPU_ID)"
        stack.addView(targetLabel, in: .center)
        
        let refreshButton = NSElements.getForceRefrash(rect: NSRect(x: 0, y: 0, width: 40, height: 15))
        refreshButton.target = self
        refreshButton.action = #selector(self.doUpdate)
        stack.addView(refreshButton, in: .trailing)
        
        let refreshItem = NSMenuItem()
        refreshItem.view = stack
        self.statusMenu.insertItem(refreshItem, at: 0)
        stack.edgeInsets = NSEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 13)
    }
    
    private func createMenu(){
        addForceUpdate()
        let N = (self.numGPU - 1)
        for i in 0...N{
            let item = NSMenuItem()
            let gpu = gpuView(frame: NSRect(x: 0, y: 0, width: 265, height: 65))
            gpu.updateView(name: Definitions.UNKNOWN, id: Definitions.UNKNOWN,status: Definitions.UNKNOWN, percent: 10.0)
            item.view = gpu
            statusMenu.addItem(item)
            if i != N{
                let sep = NSMenuItem()
                sep.view = NSBox(frame: NSRect(x: 0, y: 0, width: 265, height: 1))
                statusMenu.addItem(sep)
            }
            gpuViews.append(gpu)
        }
        
        addInfo()
    
    }
    
    func checkGPUAVailability(){
        var _status = Definitions.Status.OK
        print(self.sshClient.GPUList[Definitions.TARGET_GPU_ID].utilPercent)
        if self.sshClient.GPUList[Definitions.TARGET_GPU_ID].utilPercent > 2{
            _status = Definitions.Status.FAIL
        }
        self.statusItem.image = Definitions.getImageByStatus(status: _status)
    }
    
    private func updateGpus(){
        for vi in self.sshClient.GPUList{
            (gpuViews[vi.intId]  as! gpuView).updateView(name: vi.name, id: vi.getId(), status: vi.getStatus(), percent: vi.utilPercent)
        }
        
        self.infoLabel.stringValue = "Last update at " + Date().toString(dateFormat: "HH:mm:ss")
        checkGPUAVailability()
       
    }
    
    private func requestUpdate()
    {
        self.statusItem.image = Definitions.getImageByStatus(status: Definitions.Status.CONNECTION)
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        taskQueue.async {
            
            let path = self.sshClient.getCommandPath(commandName: Definitions.SSH_FILE_NAME)
            if (path ?? "").isEmpty{
                return
            }
            
            self.sshClient.buildTask = Process()
            self.sshClient.buildTask.launchPath = path
            self.sshClient.buildTask.arguments = [Definitions.REMOTE_USER, Definitions.REMOTE_HOST, Definitions.REMOTE_PASSWORD]
            self.sshClient.buildTask.terminationHandler = {
                task in
                
                DispatchQueue.main.async(execute: {                    
                    if self.sshClient.GPUList.count > 0
                    {
                        NSLog("Request completed...Updating views")
                        self.updateGpus()
                    }else{
                        self.statusItem.image = Definitions.getImageByStatus(status: Definitions.Status.DISSCONECTED)
                        self.infoLabel.stringValue = "Connection error!"
                    }
                    
                })
            }
            
            
            self.sshClient.captureStandardOutput(self.sshClient.buildTask)
            self.sshClient.buildTask.launch()
            self.sshClient.buildTask.waitUntilExit()
        }
    }
    
    @objc func closeApp(){
        self.stopTimer()
        NSApplication.shared.terminate(self)
    }
    
   
}
