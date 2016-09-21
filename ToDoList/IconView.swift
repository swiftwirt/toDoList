//
//  IconView.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/13/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class IconView: UIView {
    
    fileprivate var iconImage: UIImageView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    init(frame: CGRect, iconName: String) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        iconImage = UIImageView(frame: CGRect(x: 5, y: 5, width: frame.size.width - 10, height: frame.size.height - 10))
        iconImage.image = UIImage(named: iconName)
        iconImage.alpha = 0.7
        addSubview(iconImage)
    }
}
