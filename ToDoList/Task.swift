//
//  Task.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/4/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

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
        
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification {
            print("Found an existing notification \(notification)")
            UIApplication.shared.cancelLocalNotification(notification)
        }
        if shouldRemind && deadLine.compare(Date()) != .orderedAscending {
            let localNotification = UILocalNotification()
            localNotification.fireDate = deadLine
            localNotification.timeZone = TimeZone.current
            localNotification.alertBody = taskName
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": taskID]
            UIApplication.shared.scheduleLocalNotification(localNotification)
            print("Scheduled notification \(localNotification) for itemID \(taskID)")
            
            }
        }
    
    func cancelNotification() {
        let localNotification = notificationForThisItem()
        if let notification = localNotification {
            UIApplication.shared.cancelLocalNotification(notification)
            print("Canceled notification \(notification) for itemID \(taskID)")
        }

    }
    
    func notificationForThisItem() -> UILocalNotification? {
        let allNotifications = UIApplication.shared.scheduledLocalNotifications!
        for notification in allNotifications {
            if let number = notification.userInfo?["ItemID"] as? Int
                , number == taskID {
                return notification
            }
        }
        return nil
    }
    
    func calculateIntervalToDeadline() -> String  {// not finished
        let formatter = DateComponentsFormatter()
        let interval = deadLine.timeIntervalSinceNow
        print(formatter.string(from: interval)!)
        return formatter.string(from: interval)!
    }
    
    

    deinit {
        if let notification = notificationForThisItem() {
            print("Removing existing notification \(notification)")
            UIApplication.shared.cancelLocalNotification(notification)
        }
    }
}

