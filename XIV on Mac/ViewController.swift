//
//  ViewController.swift
//  XIV on Mac
//
//  Created by Marc-Aurel Zent on 20.12.21.
//

import Cocoa

class XIVController: NSViewController {
    
    @IBOutlet private var status: NSTextField!
    @IBOutlet private var button: NSButton!
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if !FileManager.default.fileExists(atPath: Util.localSettings + "XIVLauncher") {
            NotificationCenter.default.addObserver(self,selector: #selector(depsDone(_:)),name: .depInstallDone, object: nil)
            button.isHidden = true
            DispatchQueue.main.async {
                Setup.dependencies()
                Setup.DXVK()
            }
        }
        else {
            self.view.window?.title = "XIV on Mac"
            self.status.stringValue = "Click Play to start the game"
        }
    }
    
    @objc
    func depsDone(_ notif: Notification) {
        Setup.XL()
        button.isHidden = false
        self.view.window?.title = "XIV on Mac"
        self.status.stringValue = "Click Play to start the game"
    }
    
    @IBAction func play(_ sender: Any) {
        Util.launchXL()
        NSApp.hide(nil)
    }
    
    @IBAction func installDeps(_ sender: Any) {
        Setup.dependencies()
    }
    
    @IBAction func installDXVK(_ sender: Any) {
        Setup.DXVK()
    }
    
    @IBAction func installXL(_ sender: Any) {
        Setup.XL()
    }
    
    @IBAction func regedit(_ sender: Any) {
        Util.launchWine(args: ["regedit"])
    }
    
    @IBAction func winecfg(_ sender: Any) {
        Util.launchWine(args: ["winecfg"])
    }
    
    @IBAction func explorer(_ sender: Any) {
        Util.launchWine(args: ["explorer"])
    }
    
    @IBAction func cmd(_ sender: Any) {
        Util.launchWine(args: ["cmd"]) //fixme
    }
    


}

class XIVWindowController: NSWindowController, NSWindowDelegate {
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApp.hide(nil)
        return false
    }
}

extension NSTextView {
    func append(string: String) {
        DispatchQueue.main.async {
            self.textStorage?.append(NSAttributedString(string: string))
            self.scrollToEndOfDocument(nil)
        }
    }
}
