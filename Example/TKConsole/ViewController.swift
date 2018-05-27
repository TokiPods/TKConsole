//
//  ViewController.swift
//  TKConsole
//
//  Created by zhengxianda on 05/23/2018.
//  Copyright (c) 2018 zhengxianda. All rights reserved.
//

import UIKit
import TKConsole

class ViewController: UIViewController {

    var logNumber = 0
    
    @IBOutlet weak var date: UIButton!
    @IBOutlet weak var from: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Console.initGate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func log(_ sender: Any) {
        Console.log("This is a log", logNumber)
        logNumber += 1
    }
    @IBAction func save(_ sender: Any) {
        Console.shared.saveLog()
    }
    @IBAction func date(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func from(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func read(_ sender: Any) {
        Console.shared.ptintAllLog(form: Date.distantPast, to: Date.distantFuture,
                                   hasDate: date.isSelected, hasFrom: from.isSelected)
    }
    @IBAction func clean(_ sender: Any) {
        Console.shared.removeAllLog(form: Date.distantPast, to: Date.distantFuture)
    }
}

