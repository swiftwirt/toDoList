//
//  tasksDetailViewController.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/4/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

protocol TasksDetailViewControllerDelegate: class {
    func tasksDetailViewControllerCancel(controller: TasksDetailViewController)
    func tasksDetailViewController(controller : TasksDetailViewController, didFinishAdding task: Task)
    func tasksDetailViewController(controller : TasksDetailViewController, didFinishEditing task: Task)
}

class TasksDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var deadLineLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: TasksDetailViewControllerDelegate?
    
    var taskToEdit: Task?
    
    var deadLine = NSDate()
    var datePickerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let task = taskToEdit {
            title = "Edit Task"
            textField.text = task.taskName
            doneBtn.enabled = true
            shouldRemindSwitch.on = task.shouldRemind
            deadLine = task.deadLine
        }
        updateDeadLineLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    //Mark: - date picker configurations
    
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
        let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = UIColor.magentaColor()
        }
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
        tableView.endUpdates()
        datePicker.setDate(deadLine, animated: false)
    }
    
    func hideDatePicker() {
        
        if datePickerVisible {
            datePickerVisible = false
            let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
            let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
            if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathDatePicker],
                    withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    func updateDeadLineLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        deadLineLabel.text = formatter.stringFromDate(deadLine)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        doneBtn.enabled = (newText.length > 0)
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hideDatePicker()
        
    }
    
    //MARK: - TableViewDataDELEGATE
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == 1 && indexPath.row == 2 {
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        textField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    //MARK: - TableViewDataSourse
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    //MARK: - IBActions

    @IBAction func cancel(sender: AnyObject) {
        delegate?.tasksDetailViewControllerCancel(self)
    }
    
    @IBAction func done(sender: AnyObject) {
        guard let task = taskToEdit else {
            let task = Task()
            task.taskName = textField.text!
            task.isDone = false
            task.shouldRemind = shouldRemindSwitch.on
            task.deadLine = deadLine
            task.scheduleNotification()
            delegate?.tasksDetailViewController(self, didFinishAdding: task)
            return
        }
            task.taskName = textField.text!
            task.isDone = false
            task.shouldRemind = shouldRemindSwitch.on
            task.deadLine = deadLine
            task.scheduleNotification()
            delegate?.tasksDetailViewController(self, didFinishEditing: task)
        }
    
    @IBAction func dateChanged(datePicker: UIDatePicker) {
        deadLine = datePicker.date
        updateDeadLineLabel()
        
    }
    
    @IBAction func shouldRemindToggled(switchControl: UISwitch) {
        textField.resignFirstResponder()
        if switchControl.on && !datePickerVisible {
            showDatePicker()
            let notificationSettings = UIUserNotificationSettings(
                forTypes: [.Alert , .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        } else if !switchControl.on && datePickerVisible {
            hideDatePicker()
        } else {
            let notificationSettings = UIUserNotificationSettings(
                forTypes: [.Alert , .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
    }
}


