//
//  LoginViewController.swift
//  CheckIN
//
//  Created by Lambo.T.Zhuang on 2021/3/22.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    
    func loginViewControllerDidCancel(_ loginViewController: LoginViewController)
    func loginViewControllerDidFinish(_ loginViewController: LoginViewController)
}

class LoginViewController: UITableViewController, UITextFieldDelegate, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var schoolPickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // Static labels for "Name:" and "ID:"
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var idTitleLabel: UILabel!
    
    var originalNameText = "" {
        didSet {
            editedNameText = originalNameText
        }
    }
    var originalIdText = "" {
        didSet {
            editedIdText = originalIdText
        }
    }
    var originalSchoolChoice = 0 {
        didSet {
            editedSchoolChoice = originalSchoolChoice
        }
    }
    
    var editedNameText = "" {
        didSet {
            viewIfLoaded?.setNeedsLayout()
        }
    }
    var editedIdText = "" {
        didSet {
            viewIfLoaded?.setNeedsLayout()
        }
    }
    var editedSchoolChoice = 0 {
        didSet {
            viewIfLoaded?.setNeedsLayout()
        }
    }
    
    var hasChanges: Bool {
        return (originalNameText != editedNameText || originalIdText != editedIdText || originalSchoolChoice != editedSchoolChoice) && (nameTextField.text != "" && idTextField.text != "")
    }
    
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if originalNameText != "NULL" && originalIdText != "NULL" {
            nameTextField.text = originalNameText
            idTextField.text = originalIdText
        }
        
        schoolPickerView.selectRow(originalSchoolChoice, inComponent: 0, animated: true)
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {

        saveButton.isEnabled = hasChanges
        isModalInPresentation = hasChanges
    }
    
    @IBAction func nameTextFieldChange(_ sender: UITextField) {
        editedNameText = sender.text ?? originalNameText
        
    }
    
    @IBAction func idTextFieldChange(_ sender: UITextField) {
        editedIdText = sender.text ?? originalIdText
    }
    
    
    
    
    @IBAction func cancel(_ sender: Any) {
        if hasChanges {
            // The user tapped Cancel with unsaved changes. Confirm that it's OK to lose the changes.
            confirmCancel(showingSave: false)
        } else {
            // There are no unsaved changes; ask the delegate to dismiss immediately.
            delegate?.loginViewControllerDidCancel(self)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        delegate?.loginViewControllerDidFinish(self)
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        // The system calls this delegate method whenever the user attempts to pull
        // down to dismiss and `isModalInPresentation` is false.
        // Clarify the user's intent by asking whether they want to cancel or save.
        confirmCancel(showingSave: true)
    }
    
    func confirmCancel(showingSave: Bool) {
        // Present a UIAlertController as an action sheet to have the user confirm losing any
        // recent changes.
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Only ask if the user wants to save if they attempt to pull to dismiss, not if they tap Cancel.
        if showingSave {
            alert.addAction(UIAlertAction(title: L10n.Button.save, style: .default) { _ in
                self.delegate?.loginViewControllerDidFinish(self)
            })
        }
        
        alert.addAction(UIAlertAction(title: L10n.Alert.discard, style: .destructive) { _ in
            self.delegate?.loginViewControllerDidCancel(self)
        })
        
        alert.addAction(UIAlertAction(title: L10n.Button.cancel, style: .cancel, handler: nil))
        
        // If presenting the alert controller as a popover, point the popover at the Cancel button.
        alert.popoverPresentationController?.barButtonItem = cancelButton
        
        present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation title
        self.navigationItem.title = L10n.Nav.editProfile
        
        // Set button titles
        saveButton.title = L10n.Button.save
        cancelButton.title = L10n.Button.cancel
        
        // Set static labels
        nameTitleLabel?.text = L10n.Label.name
        idTitleLabel?.text = L10n.Label.studentId
        
        // Set text field placeholders
        nameTextField.placeholder = L10n.Edit.placeholderName
        idTextField.placeholder = L10n.Edit.placeholderStudentId
        
        schoolPickerView.delegate = self
        schoolPickerView.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return L10n.Edit.sectionFillInfo
        case 1:
            return L10n.Edit.sectionSelectSchool
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        }
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return schools.count
    }
}

extension LoginViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return schools[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        editedSchoolChoice = row
    }
}
