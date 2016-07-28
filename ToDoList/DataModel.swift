//
//  DataModel.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/6/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class DataModel {
    
    var toDoLists = [ToDoList]()
    let toDoListIcons = ["Appointments",
                         "Birthdays",
                         "Chores",
                         "Drinks",
                         "Folder",
                         "Groceries",
                         "Inbox",
                         "Photos",
                         "Trips" ]
    
    init() {
        loadToDoLists()
        registerDefaults()
    }
    
    //MARK: - Serialization
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("ToDoList.plist")
    }
    
    func saveToDoLists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(toDoLists, forKey: "ToDoLists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadToDoLists() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                toDoLists = unarchiver.decodeObjectForKey("ToDoLists") as! [ToDoList]
                unarchiver.finishDecoding()
                sortToDolists()
            }
        }
    }
    
    func registerDefaults() {
        let dictionary = [ "ToDoListIndex": -1,
                           "FirstTime": true,
                           "ToDoTaskID": 0 ]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    var indexOfSelectedToDoList: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("ToDoListIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ToDoListIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func handleFirstTime() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime {
            userDefaults.setBool(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
        return firstTime
    }
    
    func sortToDolists() {
        toDoLists.sortInPlace({ toDoList1, toDoList2 in
            return toDoList1.listName.localizedStandardCompare(toDoList2.listName) == .OrderedAscending
        })
    }
    
    class func nextTaskItemID() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let taskID = userDefaults.integerForKey("ToDoTaskID")
        userDefaults.setInteger(taskID + 1, forKey: "ToDoTaskID")
        userDefaults.synchronize()
        return taskID
    }

}
