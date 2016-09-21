//
//  AllListsViewController.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/6/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AllListsViewController: UIViewController, ListDetailViewControllerDelegate {

    @IBOutlet weak var scroller: HorizontalScroller!
    @IBOutlet weak var tableView: UITableView!

    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dataModel.handleFirstTime() {
            performSegue(withIdentifier: "AddList", sender: nil)
        }
        scroller.delegate = self
        scroller.initializeScrollView()
        scroller.reload()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataModel.sortToDolists()
        tableView.reloadData()
    }
    
    func listDetailViewControllerCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller : ListDetailViewController, didFinishAdding list: ToDoList) {
        dataModel.toDoLists.append(list)
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller : ListDetailViewController, didFinishEditing list: ToDoList) {
        guard let index = dataModel.toDoLists.index(of: list) else {
            dataModel.toDoLists.append(list)
            dismiss(animated: true, completion: nil)
            return
        }
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? ListsCell {
                cell.listNameLbl?.text = list.listName
                dataModel.toDoLists[(indexPath as NSIndexPath).row].listIcon = list.listIcon
                dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        switch identifier {
            case "ShowTask":
                let controller = segue.destination as! TasksViewController
                    if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                        controller.tasks = dataModel.toDoLists[(indexPath as NSIndexPath).row]
                    }
            case "AddList":
                let navigationController = segue.destination as! UINavigationController
                let controller = navigationController.topViewController as! ListDetailViewController
                controller.delegate = self
            case "EditList":
                let navigationController = segue.destination as! UINavigationController
                let controller = navigationController.topViewController as! ListDetailViewController
                controller.delegate = self
                let indexPath = IndexPath(row: ((sender as AnyObject).tag)!, section: 0)
                controller.listToEdit = dataModel.toDoLists[(indexPath as NSIndexPath).row]
            default: break
        }
    }
}

extension AllListsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete", handler: { action, indexPath in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commit: .delete,
                forRowAt: indexPath)
            
            self.dataModel.toDoLists[(indexPath as NSIndexPath).row].cancelNotificationsInList()
            self.dataModel.toDoLists.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            afterDelay(0.2) {
                tableView.reloadData()
            }
            
        })
        deleteButton.backgroundColor = UIColor(colorLiteralRed: 255.0/255.0, green: 111.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        return [deleteButton]
    }
}

extension AllListsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.toDoLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListsCell
        let list = dataModel.toDoLists[(indexPath as NSIndexPath).row]
        cell.list = list
        cell.editBtn.tag = (indexPath as NSIndexPath).row
        return cell
    }
}

extension AllListsViewController: HorizontalScrollerDelegate {
    
    func horizontalScrollerClickedViewAtIndex(_ scroller: HorizontalScroller, index: Int) {
        let navigationController = storyboard!.instantiateViewController(
                withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        
        let newlist = ToDoList(listName: dataModel.toDoListIcons[index], listIcon: dataModel.toDoListIcons[index])
        controller.listToEdit = newlist
        present(navigationController, animated: true,
                              completion: nil)
    }
    
    func numberOfViewsForHorizontalScroller(_ scroller: HorizontalScroller) -> (Int) {
        return dataModel.toDoListIcons.count
    }
    
    func horizontalScrollerViewAtIndex(_ scroller: HorizontalScroller, index: Int) -> (UIView) {
        let icon = dataModel.toDoListIcons[index]
        let iconView = IconView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), iconName: icon)
        return iconView
    }
}
