//
//  Functions.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/30/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import Foundation
import Dispatch

func afterDelay(_ seconds: Double, closure: @escaping () -> ()) {
    let when = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    return paths[0]
}

func dataFilePath() -> String {
    return (documentsDirectory() as NSString).appendingPathComponent("ToDoList.plist")
}
