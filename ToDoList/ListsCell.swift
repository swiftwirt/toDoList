//
//  ListsCell.swift
//  ToDoListTaskCell
//
//  Created by Ivashin Dmitry on 7/7/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

class ListsCell: UITableViewCell {

    @IBOutlet weak var listNameLbl: UILabel!
    @IBOutlet weak var detailNameLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var listIcon: UIImageView!
    
    var list: ToDoList! {
        didSet {
            listNameLbl.text = list.listName
            detailNameLbl.text = list.listDetails
            editBtn.setTitle("📝", forState: .Normal)
            listIcon.image = UIImage(named: list.listIcon)
        }
    }
}
