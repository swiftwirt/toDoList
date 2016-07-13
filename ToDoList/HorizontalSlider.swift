//
//  HorizontalSlider.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/13/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

@objc protocol HorizontalSliderDelegate {
    func numberOfViewsForHorizontalSlider(slider: HorizontalSlider) -> Int
    func horizontalSliderViewAtIndex(slider: HorizontalSlider, index: Int) -> UIView
    func horizontalSliderClickedViewAtIndex(slider: HorizontalSlider, index: Int)
    optional func initialViewIndex(slider: HorizontalSlider) -> Int
}

class HorizontalSlider: UIView {

    private let _VIEW_PADDING = 10
    private let _VIEW_DIMENSIONS = 100
    private let _VIEW_OFFSET = 100
    
    private var _slider: UIScrollView!
    
    var viewArray = [UIView]()
    
    weak var delegate: HorizontalSliderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeScrollView()
    }
    
    func initializeScrollView() {
        _slider = UIScrollView()
        //        _slider.delegate = self
        addSubview(_slider)
        _slider.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: _slider, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: _slider, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: _slider, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: _slider, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(HorizontalSlider.sliderTapped(_:)))
        _slider.addGestureRecognizer(tapRecognizer)
        
    }
    
    
    func sliderTapped(gesture: UITapGestureRecognizer) {
        let location = gesture.locationInView(gesture.view)
        if let delegate = delegate {
            for index in 0..<delegate.numberOfViewsForHorizontalSlider(self) {
                let view = _slider.subviews[index]
                if CGRectContainsPoint(view.frame, location) {
                    delegate.horizontalSliderClickedViewAtIndex(self, index: index)
                    _slider.setContentOffset(CGPoint(x: view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, y: 0), animated:true)
                    break
                }
            }
        }
    }
    
    func viewAtIndex(index :Int) -> UIView {
        return viewArray[index]
    }
    
    
    func reload() {
        
        if let delegate = delegate {
            viewArray = []
            let views: NSArray = _slider.subviews
            
            for view in views {
                view.removeFromSuperview()
            }
            
            var xValue = _VIEW_OFFSET
            for index in 0..<delegate.numberOfViewsForHorizontalSlider(self) {
                xValue += _VIEW_PADDING
                let view = delegate.horizontalSliderViewAtIndex(self, index: index)
                view.frame = CGRectMake(CGFloat(xValue), CGFloat(_VIEW_PADDING), CGFloat(_VIEW_DIMENSIONS), CGFloat(_VIEW_DIMENSIONS))
                _slider.addSubview(view)
                xValue += _VIEW_DIMENSIONS + _VIEW_PADDING
                viewArray.append(view)
            }
            
            _slider.contentSize = CGSizeMake(CGFloat(xValue + _VIEW_OFFSET), frame.size.height)
            
            if let initialView = delegate.initialViewIndex?(self) {
                _slider.setContentOffset(CGPoint(x: CGFloat(initialView)*CGFloat((_VIEW_DIMENSIONS + (2 * _VIEW_PADDING))), y: 0), animated: true)
            }
        }
    }
    
    override func didMoveToSuperview() {
        reload()
    }
    
    func centerCurrentView() {
        var xFinal = Int(_slider.contentOffset.x) + (_VIEW_OFFSET/2) + _VIEW_PADDING
        let viewIndex = xFinal / (_VIEW_DIMENSIONS + (2*_VIEW_PADDING))
        xFinal = viewIndex * (_VIEW_DIMENSIONS + (2*_VIEW_PADDING))
        _slider.setContentOffset(CGPoint(x: xFinal, y: 0), animated: true)
        if let delegate = delegate {
            delegate.horizontalSliderClickedViewAtIndex(self, index: Int(viewIndex))
        }  
    }
}


