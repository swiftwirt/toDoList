//
//  IconViewController.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/10/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class IconViewController: UITableViewController {

    var icons: DataModel!
    
    var selectedIcon: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.toDoListIcons.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath)
        cell.textLabel?.text = icons.toDoListIcons[indexPath.row]
        cell.imageView?.image = UIImage(named: icons.toDoListIcons[indexPath.row])
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveSelectedIcon" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                if let index = indexPath?.row {
                    selectedIcon = icons.toDoListIcons[index]
                }
            }
        }
    }

}
