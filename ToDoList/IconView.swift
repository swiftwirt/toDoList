//
//  IconView.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/13/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class IconView: UIView {
    
    private var iconImage: UIImageView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    init(frame: CGRect, iconName: String) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        iconImage = UIImageView(frame: CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10))
        iconImage.image = UIImage(named: iconName)
        iconImage.alpha = 0.7
        addSubview(iconImage)
    }
}
