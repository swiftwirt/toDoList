//
//  tasksDetailViewController.swift
//  ToDoList
//
//  Created by Ivashin Dmitry on 7/4/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

import UIKit

protocol TasksDetailViewControllerDelegate: class {
    func tasksDetailViewControllerCancel(_ controller: TasksDetailViewController)
    func tasksDetailViewController(_ controller : TasksDetailViewController, didFinishAdding task: Task)
    func tasksDetailViewController(_ controller : TasksDetailViewController, didFinishEditing task: Task)
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

    var deadLine = Date()
    var datePickerVisible = false
    
    var isLandscape: Bool! {
        didSet {
            if oldValue != true && datePickerVisible {
                riseUpDatePickerInLandscape()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let task = taskToEdit {
            title = "Edit Task"
            textField.text = task.taskName
            doneBtn.isEnabled = true
            shouldRemindSwitch.isOn = task.shouldRemind
            deadLine = task.deadLine as Date
        }
        isLandscape = UIDevice.current.orientation.isLandscape
        updateDeadLineLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        isLandscape = UIDevice.current.orientation.isLandscape
    }
    
    //Mark: - date picker configurations
    
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = UIColor(colorLiteralRed: 255.0/255.0, green: 111.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        }
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        datePicker.setDate(deadLine, animated: false)
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker],
                    with: .fade)
            tableView.endUpdates()
        }
    }
    
    func updateDeadLineLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        deadLineLabel.text = formatter.string(from: deadLine)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text! as NSString
        let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBtn.isEnabled = (newText.length > 0)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
        
    }
    
    //MARK: - TableViewDataDELEGATE
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 && indexPath.row == 1 ? indexPath : nil
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var indexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            indexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 && indexPath.row == 2 ? 217.0 : super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1 && shouldRemindSwitch.isOn {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    //MARK: - TableViewDataSourse
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return indexPath.section == 1 && indexPath.row == 2 ? datePickerCell : super.tableView(tableView, cellForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 && datePickerVisible ? 3 : super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    //MARK: - IBActions

    @IBAction func cancel(_ sender: AnyObject) {
        delegate?.tasksDetailViewControllerCancel(self)
    }
    
    @IBAction func done(_ sender: AnyObject) {
        guard deadLine.compare(Date()) == .orderedAscending && shouldRemindSwitch.isOn else {
            guard let task = taskToEdit else {
                let task = Task()
                task.taskName = textField.text!
                task.isDone = false
                task.shouldRemind = shouldRemindSwitch.isOn
                task.deadLine = deadLine
                task.scheduleNotification()
                if shouldRemindSwitch.isOn {
                    let hudView = HeadsUpDisplayView.hudInView(navigationController!.view, animated: true)
                    hudView.textLine1 = "You'll get notification in "
                    hudView.textLine2 = "\(task.calculateIntervalToDeadline()) sec"
                }
                delegate?.tasksDetailViewController(self, didFinishAdding: task)
                return
            }
            task.taskName = textField.text!
            task.isDone = false
            task.shouldRemind = shouldRemindSwitch.isOn
            task.deadLine = deadLine
            task.scheduleNotification()
            if shouldRemindSwitch.isOn {
                let hudView = HeadsUpDisplayView.hudInView(navigationController!.view, animated: true)
                hudView.textLine1 = "You'll get notification in "
                hudView.textLine2 = "\(task.calculateIntervalToDeadline()) sec"
            }
            delegate?.tasksDetailViewController(self, didFinishEditing: task)
            return
            }
        dateInPastOrPickerRotatesAlert()
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        deadLine = datePicker.date
        updateDeadLineLabel()
        
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        if switchControl.isOn && !datePickerVisible {
            showDatePicker()
            if isLandscape == true {
                riseUpDatePickerInLandscape()
            }
            let notificationSettings = UIUserNotificationSettings(
                types: [.alert , .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        } else if !switchControl.isOn && datePickerVisible {
            hideDatePicker()
        } else {
            let notificationSettings = UIUserNotificationSettings(
                types: [.alert , .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        }
    }

    // Organize methods 
    
        func riseUpDatePickerInLandscape() {
            let yFinal = tableView.contentOffset.y + view.frame.height / 4.7
            tableView.setContentOffset(CGPoint(x: 0, y: yFinal), animated: true)
        }

    
        func dateInPastOrPickerRotatesAlert() {
            let alert = UIAlertController(title: "⚠️CAUTION⚠️", message: "Only dates in future allowed with the Date Picker's wheels stop spinning!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.view.tintColor = UIColor.black
            alert.view.backgroundColor = UIColor.red
            alert.view.layer.cornerRadius = 15
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
}
