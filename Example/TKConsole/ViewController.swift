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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func log(_ sender: Any) {
        Console.log("This is a log")
    }
    @IBAction func save(_ sender: Any) {
        Console.saveLog()
    }
    @IBAction func read(_ sender: Any) {
        Console.readLog(form: Date.distantPast, to: Date.distantFuture)
    }
}

