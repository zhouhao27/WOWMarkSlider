//
//  ViewController.swift
//  WOWMarkSlider
//
//  Created by zhouhao27 on 03/29/2017.
//  Copyright (c) 2017 zhouhao27. All rights reserved.
//

import UIKit
import WOWMarkSlider

class ViewController: UIViewController {

    @IBOutlet weak var slider: WOWMarkSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.markColor = UIColor.red
        slider.markWidth = 2.0
        slider.markPositions = [30, 50, 80]
        slider.lineCap = .square
        slider.height = 8.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

