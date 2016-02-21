//
//  AppController.swift
//  YalantisBlog
//
//  Created by Sergey on 2/21/16.
//  Copyright © 2016 Jettix. All rights reserved.
//

import UIKit


class YalantisController: UIViewController
{
    @IBOutlet weak var headerTop: NSLayoutConstraint!
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateOrientationLayout()
    }
    
    func updateOrientationLayout()
    {
        if UIApplication.sharedApplication().statusBarOrientation.isPortrait {
            headerTop.constant = -20
            headerHeight.constant = 70
        } else {
            headerTop.constant = 0
            headerHeight.constant = 50
        }
    }
}