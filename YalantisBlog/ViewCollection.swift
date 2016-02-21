//
//  ViewCollection.swift
//  YalantisBlog
//
//  Created by Sergey on 2/20/16.
//  Copyright © 2016 Jettix. All rights reserved.
//

import UIKit


class ViewController: YalantisController
{
    
    @IBOutlet weak var postTitle: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    
    var postData: NSDictionary!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        postTitle.text = postData["title"] as? String
        webView.loadRequest(NSURLRequest(URL: NSURL(string: (postData["url"] as? String)!)!))
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation)
    {
        updateOrientationLayout()
    }
    
    @IBAction func back(sender: AnyObject)
    {
        navigationController?.popToRootViewControllerAnimated(true);
    }

}