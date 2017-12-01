//
//  ViewController.swift
//  extra_recipe
//
//  Created by Ian Beer on 1/23/17.
//  Copyright © 2017 Ian Beer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var bangButton: UIButton!
    var seconds:Int = 30
    var timer = Timer()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bangButton.isEnabled = false
        bangButton.alpha = 0.6
        runTimer()
    }

    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)),userInfo: nil, repeats: true)
    }

    func updateTimer() {
        seconds -= 1
        
        if (seconds == 0) {
            timer.invalidate()
            bangButton.isEnabled = true
            bangButton.alpha = 1
            timerLabel.text = "ready!"
        } else {
            timerLabel.text = "stand by: \(seconds)s"
        }
    }
    
    func attempt() {
        var status: String
        
        switch jb_go() {
        case 0:
            status = " jailbroken "
        case 1:
            status = " internal error "
        case 2:
            status = " unsupported "
        case 3:
            status = " unsupported yet "
        case 42:
            status = " hmm... ok "
        default:
            status = " failed, reboot "
        }
        
        bangButton.setTitle(status, for: .disabled)
    }
    
    @IBAction func bang(_ sender: UIButton) {
        timerLabel.text = "fingers crossed"
        sender.isEnabled = false
        sender.alpha = 0.6
        
        attempt()
    }

}

