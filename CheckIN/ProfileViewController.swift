//
//  ProfileViewController.swift
//  CheckIN
//
//  Created by Lambo.T.Zhuang on 2021/3/22.
//

import UIKit

class ProfileViewController: UITableViewController,  LoginViewControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    
    // Static labels for "Name:", "ID:", "School:"
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var idTitleLabel: UILabel!
    @IBOutlet weak var schoolTitleLabel: UILabel!
    
    
    var nameText = UserData.name {
        didSet {
            viewIfLoaded?.setNeedsLayout()
            UserData.name = nameText
        }
    }
    var idText = UserData.id {
        didSet {
            viewIfLoaded?.setNeedsLayout()
            UserData.id = idText
        }
    }
    var schoolChoice = UserData.schoolChoice {
        didSet {
            viewIfLoaded?.setNeedsLayout()
            UserData.schoolChoice = schoolChoice
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        nameLabel.text = nameText
        idLabel.text = idText
        schoolLabel.text = schools[schoolChoice]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {
        case "ChangeProfile":
            
            let navigationController = segue.destination as! UINavigationController
            let loginViewController = navigationController.topViewController as! LoginViewController
            navigationController.presentationController?.delegate = loginViewController
            loginViewController.delegate = self
            loginViewController.originalNameText = nameText
            loginViewController.originalIdText = idText
            loginViewController.originalSchoolChoice = schoolChoice

        default:
            break
        }
    }
    
    func loginViewControllerDidCancel(_ loginViewController: LoginViewController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func loginViewControllerDidFinish(_ loginViewController: LoginViewController) {
        
        nameText = loginViewController.editedNameText
        idText = loginViewController.editedIdText
        schoolChoice = loginViewController.editedSchoolChoice
        UserData.name = nameText
        UserData.id = idText
        UserData.schoolChoice = schoolChoice
        UserDefaults.standard.setValue(UserData.name, forKey: "name")
        UserDefaults.standard.setValue(UserData.id, forKey: "id")
        UserDefaults.standard.setValue(UserData.schoolChoice, forKey: "schoolChoice")
        print("233")
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation title
        self.navigationItem.title = L10n.Nav.profile
        
        // Set static labels
        nameTitleLabel?.text = L10n.Label.name
        idTitleLabel?.text = L10n.Label.studentId
        schoolTitleLabel?.text = L10n.Label.school
        
        nameText = UserData.name == "" ? UserData.name : L10n.Label.null
        idText = UserData.id == "" ? UserData.id : L10n.Label.null
        schoolChoice = UserData.schoolChoice
        nameLabel.text = nameText
        idLabel.text = idText
        schoolLabel.text = schools[schoolChoice]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
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
