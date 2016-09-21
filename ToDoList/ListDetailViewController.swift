//
//  ListDetailViewController.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/7/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller : ListDetailViewController, didFinishAdding list: ToDoList)
    func listDetailViewController(_ controller : ListDetailViewController, didFinishEditing list: ToDoList)
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
            doneBtn.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text! as NSString
        let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBtn.isEnabled = (newText.length > 0)
        return true
    }
    
    //MARK: - table view delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    //MARK: - IBActions
    
    @IBAction func cancel(_ sender: AnyObject) {
        delegate?.listDetailViewControllerCancel(self)
    }
    
    @IBAction func done(_ sender: AnyObject) {
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
    
    @IBAction func unwindWithSelectedIcon(_ segue:UIStoryboardSegue) {
        if let iconViewController = segue.source as? IconViewController,
            let selectedIcon = iconViewController.selectedIcon {
            iconNamed = selectedIcon
        }
    }
}
