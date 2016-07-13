//
//  AllListsViewController.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/6/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if dataModel.handleFirstTime() {
            performSegueWithIdentifier("AddList", sender: nil)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.toDoLists.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath) as! ListsCell
        
        let list = dataModel.toDoLists[indexPath.row]
        cell.list = list
        cell.editBtn.tag = indexPath.row
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.toDoLists.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // MARK: - Table view delegate
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commitEditingStyle: .Delete,
                forRowAtIndexPath: indexPath)
            return
        })
        deleteButton.backgroundColor = UIColor.magentaColor()
        return [deleteButton]
    }
    
    // MARK: - ListDetailViewControllerDelegate
    
    func listDetailViewControllerCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller : ListDetailViewController, didFinishAdding list: ToDoList) {
        dataModel.toDoLists.append(list)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller : ListDetailViewController, didFinishEditing list: ToDoList) {
        if let index = dataModel.toDoLists.indexOf(list) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ListsCell {
                cell.listNameLbl?.text = list.listName
                dataModel.toDoLists[indexPath.row].listIcon = list.listIcon
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowTask" {
            let controller = segue.destinationViewController as! TasksViewController
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.tasks = dataModel.toDoLists[indexPath.row]
            }
        } else if segue.identifier == "AddList" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditList" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            let indexPath = NSIndexPath(forRow: (sender?.tag)!, inSection: 0)
            controller.listToEdit = dataModel.toDoLists[indexPath.row]
        }
    }
    
}
