//
//  ViewController.swift
//  Twenty
//
//  Created by Rohin Tangirala on 10/30/16.
//  Copyright © 2016 Rohin Tangirala. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class ViewController: UIViewController {

    
    var workTimer = Timer()
    var soundTimer = Timer()
    var breakTimer = Timer()
    var breakSoundTimer = Timer()
    var voiceTimer = Timer()
    var breakVoiceTimer = Timer()
    var count = 1200
    let originalCount = 1200
    var totalMin = 1
    let defaults = UserDefaults.standard
    var usageTimes = [Double]()
    var date = Date()
    var calendar = Calendar.current
    var currentDateTime = String()
    var month = Int()
    var day = Int()
    var year = Int()
    var hour = Int()
    var minutes = Int()
    var minutesString = String()
    var usageDates = [String]()
    var startEndDateTime = String()
    
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    let speechUtterance = AVSpeechUtterance(string: "Time for a break")
    
    let breakSpeechUtterance = AVSpeechUtterance(string: "You may resume your work")
    
    
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var voiceSwitch: UISwitch!
    @IBOutlet weak var progressIndicator: UIProgressView!
    @IBAction func startButton(_ sender: AnyObject) {
        if (sender.currentTitle == "Start Working Period") {
            sender.setTitle( "Stop Working Period" , for: UIControlState.normal )
            startStopButton.backgroundColor = UIColor(red:0.76, green:0.01, blue:0.00, alpha:1.0)
            month = calendar.component(.month, from: date)
            day = calendar.component(.day, from: date)
            year = calendar.component(.year, from: date) % 100
            hour = calendar.component(.hour, from: date)
            minutes = calendar.component(.minute, from: date)
            if (minutes < 10) {
                minutesString = "0" + String(minutes)
            } else {
                minutesString = String(minutes)
            }
            
            currentDateTime = String(month) + "/" + String(day) + "/" + String(year) + " " + String(hour) + ":" + minutesString
            
            startEndDateTime = currentDateTime
            
            createMainTimers()
            
        } else {
            sender.setTitle( "Start Working Period" , for: UIControlState.normal )
            startStopButton.backgroundColor = UIColor(red:0.12, green:0.64, blue:0.13, alpha:1.0)
            workTimer.invalidate()
            soundTimer.invalidate()
            breakTimer.invalidate()
            breakSoundTimer.invalidate()
            count = 1200
            timeLabel.text = "0 min"
            progressIndicator.setProgress(Float(0.0), animated: true)
            usageTimes.append(Double(totalMin))
            
            
            defaults.set(usageTimes, forKey: "usageTimes")
            defaults.synchronize()
            
            month = calendar.component(.month, from: date)
            day = calendar.component(.day, from: date)
            year = calendar.component(.year, from: date) % 100
            hour = calendar.component(.hour, from: date)
            minutes = calendar.component(.minute, from: date)
            if (minutes < 10) {
                minutesString = "0" + String(minutes)
            } else {
                minutesString = String(minutes)
            }
            
            currentDateTime = String(month) + "/" + String(day) + "/" + String(year) + " " + String(hour) + ":" + minutesString
            
            startEndDateTime = startEndDateTime + " to " + currentDateTime
            
            usageDates.append(startEndDateTime)
            defaults.set(usageDates, forKey: "usageDates")
            defaults.synchronize()
        }
    }
    
    
    
    func createMainTimers() {
        workTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        soundTimer = Timer.scheduledTimer(timeInterval: TimeInterval(count), target: self, selector: #selector(ViewController.endTimer), userInfo: nil, repeats: false)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        backgroundImage.image = UIImage(named: "pexels-photo")
        self.view.insertSubview(backgroundImage, at: 0)
        startStopButton.backgroundColor = UIColor(red:0.12, green:0.64, blue:0.13, alpha:1.0)
        if let usageTimesStored = defaults.object(forKey: "usageTimes") as AnyObject? {
            usageTimes = usageTimesStored as! [Double]
        }
        if let usageDatesStored = defaults.object(forKey: "usageDates") as AnyObject? {
            usageDates = usageDatesStored as! [String]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        
        if(count > 0) {
            count = count - 1
            progressIndicator.setProgress(Float(1-(Double(count)/Double(originalCount))), animated: true)
            timeLabel.text = String(Int(round(Double(1000*(count/60)))/1000)+1) + " min"
            if (Double(count)/Double(60) == floor(Double(count)/Double(60))) {
                totalMin = totalMin + 1
            }
        }
    }
    
    func breakUpdate() {
        if(count > 0) {
            count = count - 1
            progressIndicator.setProgress(Float(1-(Double(count)/Double(20))), animated: true)
            
            timeLabel.text = String(count) + " seconds"
        }
    }
    
    func voice() {
        speechSynthesizer.speak(speechUtterance)
        voiceTimer.invalidate()
    }
    
    func breakVoice() {
        speechSynthesizer.speak(breakSpeechUtterance)
        breakVoiceTimer.invalidate()
    }
    
    func endTimer() {
        AudioServicesPlaySystemSound (1028)
        if (voiceSwitch.isOn) {
            voiceTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.voice), userInfo: nil, repeats: false)
        }
        
        
        workTimer.invalidate()
        soundTimer.invalidate()
        
        timeLabel.text = "0 min"
        count = 21
        breakTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.breakUpdate), userInfo: nil, repeats: true)
        breakSoundTimer = Timer.scheduledTimer(timeInterval: TimeInterval(count), target: self, selector: #selector(ViewController.endBreakTimer), userInfo: nil, repeats: false)
    }
    
    func endBreakTimer() {
        AudioServicesPlaySystemSound(1025)
        if (voiceSwitch.isOn) {
            breakVoiceTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.breakVoice), userInfo: nil, repeats: false)
        }
        breakTimer.invalidate()
        breakSoundTimer.invalidate()
        count = 1200
        
        
        createMainTimers()
    }
    
    
    
}

