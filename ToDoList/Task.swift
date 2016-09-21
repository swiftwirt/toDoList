//
//  Task.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/4/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit
import UserNotifications

class Task: NSObject, NSCoding {
    var taskName = ""
    var taskCheckmark = ""
    var isDone = false
    var deadLine = Date()
    var shouldRemind = false
    var taskID: Int
    
    var checkmark: String {
        return isDone ? "☑️" : ""
    }
    
    func switcher() {
        isDone = !isDone
    }
    
    override init() {
        taskID = DataModel.nextTaskItemID()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        taskName = aDecoder.decodeObject(forKey: "taskName") as! String
        isDone = aDecoder.decodeBool(forKey: "isDone")
        deadLine = aDecoder.decodeObject(forKey: "deadLine") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "shouldRemind")
        taskID = aDecoder.decodeInteger(forKey: "taskID")
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(taskName, forKey: "taskName")
        aCoder.encode(isDone, forKey: "isDone")
        aCoder.encode(deadLine, forKey: "deadLine")
        aCoder.encode(shouldRemind, forKey: "shouldRemind")
        aCoder.encode(taskID, forKey: "taskID")
    }
    
    func scheduleNotification() {
        if shouldRemind && deadLine.compare(Date()) != .orderedAscending {
            let content = UNMutableNotificationContent()
            content.body = taskName
            
            let timeInterval = deadLine.timeIntervalSinceNow
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: String(taskID), content: content, trigger: trigger)
     
            UNUserNotificationCenter.current().add(request, withCompletionHandler:
                { (error) in
                    if let error = error {
                        print(error)
                    } else {
                        print("Scheduled notification \(content.body) for itemID \(self.taskID)")
                    }
            })
        }
    }
    
    func cancelNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [String(taskID)])
        print("Canceled notification for itemID \(taskID)")
    }
    
    func calculateIntervalToDeadline() -> String  {// not finished
        let formatter = DateComponentsFormatter()
        let interval = deadLine.timeIntervalSinceNow
        print(formatter.string(from: interval)!)
        return formatter.string(from: interval)!
    }

}


