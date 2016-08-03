//
//  ListDetailViewController.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/7/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerCancel(controller: ListDetailViewController)
    func listDetailViewController(controller : ListDetailViewController, didFinishAdding list: ToDoList)
    func listDetailViewController(controller : ListDetailViewController, didFinishEditing list: ToDoList)
}

class ListDetailViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var iconName: UILabel!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var listToEdit: ToDoList?
    
    var iconNamed: String = "No Icon" {
        didSet {
            iconName.text = iconNamed
            imageIcon.image = UIImage(named: iconNamed)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let list = listToEdit {
            title = list.listName
            textField.text = list.listName
            iconNamed = list.listIcon
            imageIcon.image = UIImage(named: iconNamed)
            iconName.text = iconNamed
            doneBtn.enabled = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        doneBtn.enabled = (newText.length > 0)
        return true
    }
    
    //MARK: - table view delegate
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    //MARK: - IBActions
    
    @IBAction func cancel(sender: AnyObject) {
        delegate?.listDetailViewControllerCancel(self)
    }
    
    @IBAction func done(sender: AnyObject) {
        guard let list = listToEdit else {
            let list = ToDoList(listName: textField.text!)
            list.listIcon = iconNamed
            delegate?.listDetailViewController(self, didFinishAdding: list)
            return
        }
        list.listName = textField.text!
        list.listIcon = iconNamed
        delegate?.listDetailViewController(self, didFinishEditing: list)
    }
    
    @IBAction func unwindWithSelectedIcon(segue:UIStoryboardSegue) {
        if let iconViewController = segue.sourceViewController as? IconViewController,
            selectedIcon = iconViewController.selectedIcon {
            iconNamed = selectedIcon
        }
    }
}
