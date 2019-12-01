//
//  InterfaceController.swift
//  GyMate Watch Companion Extension
//
//  Created by Ben Sykes on 2019-11-30.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet var tmrRestPeriod : WKInterfaceTimer!
    @IBOutlet var btnSkipRestPeriod : WKInterfaceButton!
    
    // The amount of time to put on the timer
    var startRestTime : Double = 60.0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate() // Activate session
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didAppear() {
        tmrRestPeriod.setDate(Date(timeIntervalSinceNow: 0.0))
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // DO nothing for now
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        // Set variables for reply and get time to set on timer
        var replyValues = Dictionary<String, AnyObject>()
        self.startRestTime = message["restTime"] as! Double
        
        // Start counting down
        inistalizeRestTimer()
        
        replyValues["status"] = "success" as AnyObject?
        replyHandler(replyValues)
    }
    
    func inistalizeRestTimer() {
        tmrRestPeriod.setDate(Date(timeIntervalSinceNow: self.startRestTime))
        tmrRestPeriod.start()
    }
    
    @IBAction func skipRestPeriod(sender: WKInterfaceButton!) {
        tmrRestPeriod.stop()
        tmrRestPeriod.setDate(Date(timeIntervalSinceNow: 0.0))
        
        // Send message to skip
        WCSession.default.sendMessage(["skip" : true], replyHandler: nil, errorHandler: {error in
            print("Error: " + error.localizedDescription)
        })
    }

}
