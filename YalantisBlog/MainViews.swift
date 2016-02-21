//
//  PostView.swift
//  YalantisBlog
//
//  Created by Sergey on 2/20/16.
//  Copyright © 2016 Jettix. All rights reserved.
//

import UIKit

private func addShadow(layer: CALayer, radius: CGFloat)
{
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOffset = CGSizeMake(0, 1)
    layer.shadowOpacity = 0.3
    layer.shadowRadius = radius
}

class PostView: UICollectionViewCell
{
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var views: UILabel!
}

class PageHeader: UIView
{
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        addShadow(layer, radius: 3)
    }
}

class PageTitle: UILabel
{
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        addShadow(layer, radius: 1)
    }
}