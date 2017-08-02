//
//  ViewController.swift
//  IKSpinner
//
//  Created by ilia3546 on 08/02/2017.
//  Copyright (c) 2017 ilia3546. All rights reserved.
//

import UIKit
import IKSpinner

class ViewController: UIViewController {
    
    @IBOutlet weak var storyboardSpinner: IKSpinner!
    var vcSpinner: IKSpinner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initiate spinner
        vcSpinner = IKSpinner(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
        // Configure
        vcSpinner.lineColor = .lightGray
        vcSpinner.center = storyboardSpinner.center
        
        // Add to own view
        self.view.addSubview(vcSpinner)
        
        // Show new spinner
        self.vcSpinner.fadeIn(1.5){
            
            // Then hide storyboard spinner
            self.storyboardSpinner.fadeOut(1.5){
                
                // Then change speed and show it again
                self.storyboardSpinner.rotateSpeed = 1.5
                self.storyboardSpinner.fadeIn(1.5)
                
            
                self.vcSpinner.fadeOut(1.5)

            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

