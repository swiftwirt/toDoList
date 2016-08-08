//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/4/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class TasksViewController: UITableViewController, TasksDetailViewControllerDelegate {

    var tasks: ToDoList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tasks.listName
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tasks.sortToDoTasks()
        tableView.reloadData()
    }

    // MARK: - Table view DATA SOURCE

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.tasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath) as! TaskCell
        let task = tasks.tasks[indexPath.row]
        cell.editBtn.tag = indexPath.row
        cell.taskNameLbl.text = task.taskName
        cell.checkmark.text = task.checkmark
        return cell
    }
    
    // MARK: - Table view DELEGATE
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TaskCell
        let task = tasks.tasks[indexPath.row]
        task.switcher()
        if !task.isDone {
            task.scheduleNotification()
        } else {
            task.cancelNotification()
        }
        cell.checkmark.text = task.checkmark
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .Default, title: "Delete", handler: { action, indexPath in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commitEditingStyle: .Delete,
                forRowAtIndexPath: indexPath)
                                let currentTask = self.tasks.tasks[indexPath.row]
                                currentTask.cancelNotification()
                                self.tasks.tasks.removeAtIndex(indexPath.row)
                                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            afterDelay(0.2) {
                tableView.reloadData()
            }
        })
        deleteButton.backgroundColor = UIColor(colorLiteralRed: 255.0/255.0, green: 111.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        return [deleteButton]
    }
    
    // MARK: - TasksDetailViewControllerDelegate
    
    func tasksDetailViewControllerCancel(controller: TasksDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tasksDetailViewController(controller : TasksDetailViewController, didFinishAdding task: Task) {
        tasks.tasks.append(task)
        if task.shouldRemind {
            afterDelay(2.5) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func tasksDetailViewController(controller: TasksDetailViewController, didFinishEditing task: Task) {
        if let index = tasks.tasks.indexOf(task) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TaskCell {
                cell.taskNameLbl.text = task.taskName
            }
        }
        if task.shouldRemind {
            afterDelay(2.5) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {return}
        switch identifier {
            case "addTask":
                let navigationController = segue.destinationViewController as! UINavigationController
                let controller = navigationController.topViewController as! TasksDetailViewController
                controller.delegate = self
            case "editTask":
                let navigationController = segue.destinationViewController as! UINavigationController
                let controller = navigationController.topViewController as! TasksDetailViewController
                controller.delegate = self
                let indexPath = NSIndexPath(forRow: sender!.tag!, inSection: 0)
                controller.taskToEdit = tasks.tasks[indexPath.row]
            default: break
        }
    }
}
