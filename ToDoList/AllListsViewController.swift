//
//  AllListsViewController.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/6/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {

    @IBOutlet weak var scroller: HorizontalScroller!

    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dataModel.handleFirstTime() {
            performSegueWithIdentifier("AddList", sender: nil)
        }
        scroller.delegate = self
        scroller.reload()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dataModel.sortToDolists()
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
    
    // MARK: - Table view delegate
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .Default, title: "Delete", handler: { action, indexPath in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commitEditingStyle: .Delete,
                forRowAtIndexPath: indexPath)
            
                self.dataModel.toDoLists[indexPath.row].cancelNotificationsInList()
                self.dataModel.toDoLists.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                return
        })
        deleteButton.backgroundColor = UIColor(colorLiteralRed: 255.0/255.0, green: 111.0/255.0, blue: 207.0/255.0, alpha: 1.0)
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
        guard let index = dataModel.toDoLists.indexOf(list) else {
            dataModel.toDoLists.append(list)
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ListsCell {
                cell.listNameLbl?.text = list.listName
                dataModel.toDoLists[indexPath.row].listIcon = list.listIcon
                dismissViewControllerAnimated(true, completion: nil)
        }
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

extension AllListsViewController: HorizontalScrollerDelegate {
    
    func horizontalScrollerClickedViewAtIndex(scroller: HorizontalScroller, index: Int) {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier(
                
                "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        
        let newlist = ToDoList(listName: dataModel.toDoListIcons[index], listIcon: dataModel.toDoListIcons[index])
        controller.listToEdit = newlist
        presentViewController(navigationController, animated: true,
                              completion: nil)
    }
    
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> (Int) {
        return dataModel.toDoListIcons.count
    }
    
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index: Int) -> (UIView) {
        let icon = dataModel.toDoListIcons[index]
        let iconView = IconView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), iconName: icon)
        return iconView
    }
}
