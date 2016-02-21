//
//  ViewController.swift
//  YalantisBlog
//
//  Created by Sergey on 2/20/16.
//  Copyright © 2016 Jettix. All rights reserved.
//

import UIKit

private let kAnimationDuration: Double = 0.25

class MainController: YalantisController, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var collection: UICollectionView!
    
    let blogPath: String = "/blog"
    
    let blogUrl: String = "https://yalantis.com/blog"
    
    let jsonResponseFile: String = "yalantis.json"
    
    var data: [NSDictionary] = [NSDictionary]()
    
    var dataImages: [NSData?] = [NSData?]()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initStub()
        initPosts()
    }
    
    func initStub()
    {
        OHHTTPStubs.onStubActivation { (request: NSURLRequest!, stub: OHHTTPStubsDescriptor!) in
            print("[OHHTTPStubs] Request to \(request.URL!) has been stubbed with \(stub.name)")
        }
        
        stub(isPath(blogPath)) { _ in
            let stubPath = OHPathForFile(self.jsonResponseFile, self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type":"application/json"])
        }
    }
    
    func initPosts()
    {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let manager = AFURLSessionManager(sessionConfiguration: configuration)
        let request = NSURLRequest(URL: NSURL(string: blogUrl)!)
        
        let dataTask = manager.dataTaskWithRequest(request) { (response, data, error) -> Void in
            if error != nil {
                print("HTTP Session has finished with error: \(error)")
            } else {
                if data != nil && data!.isKindOfClass(NSArray)
                {
                    self.data = data as! Array
                    self.dataImages = [NSData?](count: data!.count, repeatedValue: nil)
                    self.collection.reloadData()
                }
            }
        }
        
        dataTask.resume()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(view.frame.width, 262.0)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let postData = data[indexPath.row]
        let postView: PostView = collectionView.dequeueReusableCellWithReuseIdentifier("post", forIndexPath: indexPath) as! PostView
            postView.title.text = postData["title"] as? String
            postView.desc.text = postData["description"] as? String
            postView.author.text = postData["author"] as? String
            postView.views.text = postData["views"] as? String
        
        if let imageData = dataImages[indexPath.row] {
            if imageData.isKindOfClass(NSData) {
                postView.image.image = UIImage(data: imageData)
            }
        } else {
            postView.image.layer.opacity = 0
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                if let imgUrl = postData["image"] as? String {
                    if let imageData = NSData(contentsOfURL: NSURL(string: imgUrl)!) {
                        self.dataImages[indexPath.row] = imageData
                        dispatch_async(dispatch_get_main_queue()) {
                            postView.image.image = UIImage(data: imageData)
                            UIView.animateWithDuration(kAnimationDuration, animations: {
                                postView.image.layer.opacity = 1
                            })
                        }
                    }
                }
            }
        }
        
        return postView
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation)
    {
        updateOrientationLayout()
        collection.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let postView = segue.destinationViewController as! ViewController
        let postData = data[(collection.indexPathsForSelectedItems()?.first?.row)!]
            postView.postData = postData
    }
}