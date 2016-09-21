//
//  IconViewController.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/10/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class IconViewController: UITableViewController {

    var toDoListIcons = DataModel()
    
    var selectedIcon: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoListIcons.toDoListIcons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
        let listIcon = toDoListIcons.toDoListIcons[indexPath.row]
        cell.textLabel?.text = listIcon
        cell.imageView?.image = UIImage(named: listIcon)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveSelectedIcon" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    let listIcon = toDoListIcons.toDoListIcons[index]
                    selectedIcon = listIcon
                }
            }
        }
    }

}
