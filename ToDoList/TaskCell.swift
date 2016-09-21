//
//  TaskCell.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/5/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var checkmark: UILabel!
    @IBOutlet weak var taskNameLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    var task: Task! {
        didSet {
            checkmark.text = task.checkmark
            taskNameLbl.text = task.taskName
            editBtn.setTitle("📝", for: UIControlState())
        }
    }
}
