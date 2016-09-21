//
//  ToDoList.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/4/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class ToDoList: NSObject, NSCoding {
    
    var listName: String
    var tasks = [Task]()
    var listIcon = "No Icon"

    var listDetails: String {
            if tasks.count == 0 {
                return "(No Items)"
            } else if countUnchecked() == 0 {
                return "Tasks complete!!!"
            } else {
                return "\(countUnchecked()) Remain"
            }
    }
    
    convenience init(listName: String) {
        self.init(listName: listName, listIcon: "No Icon")
    }
    
    init(listName: String, listIcon: String) {
        self.listName = listName
        self.listIcon = listIcon
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        listName = aDecoder.decodeObject(forKey: "listName") as! String
        tasks = aDecoder.decodeObject(forKey: "tasks") as! [Task]
        listIcon = aDecoder.decodeObject(forKey: "listIcon") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(listName, forKey: "listName")
        aCoder.encode(tasks, forKey: "tasks")
        aCoder.encode(listIcon, forKey: "listIcon")
    }
    
    func countUnchecked() -> Int {
        var cnt = 0
        for task in tasks where !task.isDone {
            cnt += 1
        }
        return cnt
    }
    
    func sortToDoTasks() {
        tasks.sort(by: { task1, task2 in
            return task1.taskName.localizedStandardCompare(task2.taskName) == .orderedAscending
        })
    }
    
    func cancelNotificationsInList() {
        for task in tasks where task.shouldRemind {
            task.cancelNotification()
        }
    }
}

