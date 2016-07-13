//
//  NavigationController.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/4/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class NavigationBarView: UINavigationController,  UIViewControllerTransitioningDelegate {
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationBar.barStyle = UIBarStyle.Black
            self.navigationBar.tintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        }
}
