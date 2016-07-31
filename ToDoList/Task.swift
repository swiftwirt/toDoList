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
    var deadLine = NSDate()
    var shouldRemind = false
    var taskID: Int
    
    var checkmark: String {
        if isDone {
            return "☑️"
        } else {
            return ""
        }
    }
    
    func switcher() {
        isDone = !isDone
    }
    
    override init() {
        taskID = DataModel.nextTaskItemID()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        taskName = aDecoder.decodeObjectForKey("taskName") as! String
        isDone = aDecoder.decodeBoolForKey("isDone")
        deadLine = aDecoder.decodeObjectForKey("deadLine") as! NSDate
        shouldRemind = aDecoder.decodeBoolForKey("shouldRemind")
        taskID = aDecoder.decodeIntegerForKey("taskID")
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(taskName, forKey: "taskName")
        aCoder.encodeBool(isDone, forKey: "isDone")
        aCoder.encodeObject(deadLine, forKey: "deadLine")
        aCoder.encodeBool(shouldRemind, forKey: "shouldRemind")
        aCoder.encodeInteger(taskID, forKey: "taskID")
    }

    func scheduleNotification() {
        
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification {
            print("Found an existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        if shouldRemind && deadLine.compare(NSDate()) != .OrderedAscending {
            let localNotification = UILocalNotification()
            localNotification.fireDate = deadLine
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = taskName
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": taskID]
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            print("Scheduled notification \(localNotification) for itemID \(taskID)")
            
            }
        }
    
    func cancelNotification() {
        let localNotification = notificationForThisItem()
        if let notification = localNotification {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
            print("Canceled notification \(notification) for itemID \(taskID)")
        }

    }
    
    func notificationForThisItem() -> UILocalNotification? {
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        for notification in allNotifications {
            if let number = notification.userInfo?["ItemID"] as? Int
                where number == taskID {
                return notification
            }
        }
        return nil
    }
    
    func calculateIntervalToDeadline() -> String  {// not finished
        let formatter = NSDateComponentsFormatter()
        let interval = deadLine.timeIntervalSinceNow
        print(formatter.stringFromTimeInterval(interval)!)
        return formatter.stringFromTimeInterval(interval)!
    }
    
    

    deinit {
        if let notification = notificationForThisItem() {
            print("Removing existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
}

