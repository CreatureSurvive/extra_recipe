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
    var fireOnCompletion = false

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bangButton.isEnabled = false
        bangButton.alpha = 0.6
        runTimer()
    }
    
    func autoRunAfterSeconds(autoRunSeconds:Int, withAlert:Bool? = true) {
        if (withAlert)! {
            let alertController = UIAlertController(title: "Auto Run Warning", message: "Automatically attemptiong to jailbreak in \(String(autoRunSeconds)) seconds!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        timer.invalidate()
        seconds = autoRunSeconds
        fireOnCompletion = true
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
            if (fireOnCompletion) {
                attempt()
            }
        } else {
            timerLabel.text = "stand by: \(seconds)s"
        }
    }
    
    func attempt() {
        OperationQueue().addOperation {
            let statusResult = jb_go()
            OperationQueue.main.addOperation {
                self.updateStatus(statusResult: Int(statusResult))
            }
        }
    }
    
    func updateStatus(statusResult:Int) {
        var status: String
        
        switch statusResult {
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

