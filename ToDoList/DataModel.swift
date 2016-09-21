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
    
    func saveToDoLists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(toDoLists, forKey: "ToDoLists")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    func loadToDoLists() {
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                toDoLists = unarchiver.decodeObject(forKey: "ToDoLists") as! [ToDoList]
                unarchiver.finishDecoding()
                sortToDolists()
            }
        }
    
    func registerDefaults() {
        let dictionary = [ "ToDoListIndex": -1,
                           "FirstTime": true,
                           "ToDoTaskID": 0 ] as [String : Any]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    var indexOfSelectedToDoList: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ToDoListIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ToDoListIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    func handleFirstTime() -> Bool {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime {
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
        return firstTime
    }
    
    func sortToDolists() {
        toDoLists.sort(by: { toDoList1, toDoList2 in
            return toDoList1.listName.localizedStandardCompare(toDoList2.listName) == .orderedAscending
        })
    }
    
    class func nextTaskItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let taskID = userDefaults.integer(forKey: "ToDoTaskID")
        userDefaults.set(taskID + 1, forKey: "ToDoTaskID")
        userDefaults.synchronize()
        return taskID
    }

}
