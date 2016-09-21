//
//  HeadsUpDisplayView.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/30/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class HeadsUpDisplayView: UIView {
    
    var textLine1 = ""
    var textLine2 = ""

    override func draw(_ rect: CGRect) {
        let boxWidth: CGFloat = 224
        let boxHeight: CGFloat = 96
        let boxRect = CGRect(
            x: round((bounds.size.width - boxWidth) / 2),
            y: round((bounds.size.height - boxHeight) / 2),
            width: boxWidth,
            height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        
        let attribs = [ NSFontAttributeName: UIFont.systemFont(ofSize: 16),
                        NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/247.0, alpha: 1.0) ]
        
        let textLine1Size = textLine1.size(attributes: attribs)
        let textPoint1 = CGPoint(
            x: center.x - round(textLine1Size.width / 2),
            y: center.y - round(textLine1Size.height / 0.8))
        textLine1.draw(at: textPoint1, withAttributes: attribs)
        
        let textLine2Size = textLine2.size(attributes: attribs)
        let textPoint2 = CGPoint(
            x: center.x - round(textLine2Size.width / 2),
            y: center.y - round(textLine2Size.height / 2.6))
        textLine2.draw(at: textPoint2, withAttributes: attribs)
    }
    
    class func hudInView(_ view: UIView, animated: Bool) -> HeadsUpDisplayView {
        let hudView = HeadsUpDisplayView(frame: view.bounds)
        hudView.isOpaque = false
        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
        hudView.showAnimated(animated)
        return hudView
    }
    
    func showAnimated(_ animated: Bool) {
        if animated {
            alpha = 0
            transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7,
                                       initialSpringVelocity: 0.5, options: [], animations: {
                                       self.alpha = 1
                                       self.transform = CGAffineTransform.identity},
                                       completion: nil)
        }
    }
}
