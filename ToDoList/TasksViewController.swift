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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tasks.sortToDoTasks()
        tableView.reloadData()
    }

    // MARK: - Table view DATA SOURCE

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = tasks.tasks[(indexPath as NSIndexPath).row]
        cell.editBtn.tag = (indexPath as NSIndexPath).row
        cell.taskNameLbl.text = task.taskName
        cell.checkmark.text = task.checkmark
        return cell
    }
    
    // MARK: - Table view DELEGATE
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TaskCell
        let task = tasks.tasks[(indexPath as NSIndexPath).row]
        task.switcher()
        if !task.isDone {
            task.scheduleNotification()
        } else {
            task.cancelNotification()
        }
        cell.checkmark.text = task.checkmark
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete", handler: { action, indexPath in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commit: .delete,
                forRowAt: indexPath)
                                let currentTask = self.tasks.tasks[(indexPath as NSIndexPath).row]
                                currentTask.cancelNotification()
                                self.tasks.tasks.remove(at: (indexPath as NSIndexPath).row)
                                tableView.deleteRows(at: [indexPath], with: .automatic)
            afterDelay(0.2) {
                tableView.reloadData()
            }
        })
        deleteButton.backgroundColor = UIColor(colorLiteralRed: 255.0/255.0, green: 111.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        return [deleteButton]
    }
    
    // MARK: - TasksDetailViewControllerDelegate
    
    func tasksDetailViewControllerCancel(_ controller: TasksDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func tasksDetailViewController(_ controller : TasksDetailViewController, didFinishAdding task: Task) {
        tasks.tasks.append(task)
        if task.shouldRemind {
            afterDelay(2.5) {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tasksDetailViewController(_ controller: TasksDetailViewController, didFinishEditing task: Task) {
        if let index = tasks.tasks.index(of: task) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
                cell.taskNameLbl.text = task.taskName
            }
        }
        if task.shouldRemind {
            afterDelay(2.5) {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        switch identifier {
            case "addTask":
                let navigationController = segue.destination as! UINavigationController
                let controller = navigationController.topViewController as! TasksDetailViewController
                controller.delegate = self
            case "editTask":
                let navigationController = segue.destination as! UINavigationController
                let controller = navigationController.topViewController as! TasksDetailViewController
                controller.delegate = self
                let indexPath = IndexPath(row: (sender! as AnyObject).tag!, section: 0)
                controller.taskToEdit = tasks.tasks[(indexPath as NSIndexPath).row]
            default: break
        }
    }
}
