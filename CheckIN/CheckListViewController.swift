//
//  CheckListViewController.swift
//  CheckIN
//
//  Created by Lambo.T.Zhuang on 2021/3/23.
//

import UIKit

struct CheckedUserData: Codable {
    var name: String
    var id: String
    var school: String
    var time: String
}

var checkedList: [CheckedUserData] = []

class CheckListViewController: UITableViewController, ScanViewControllerDelegate {
    
    var tempStr = ""
    var allIsSelected = false
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var selectAllButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "ScanCode":
            
            let navigationController = segue.destination as! UINavigationController
            let scanViewController = navigationController.topViewController as! ScanViewController
            navigationController.presentationController?.delegate = scanViewController
            scanViewController.delegate = self
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation title
        self.navigationItem.title = L10n.Nav.scan
        
        // Set button titles
        editButton.title = L10n.Button.edit
        selectAllButton.title = L10n.Button.selectAll
        deleteButton.title = L10n.Button.delete
        
        if let data = UserDefaults.standard.value(forKey:"checkedList") as? Data {
            checkedList = try! PropertyListDecoder().decode(Array<CheckedUserData>.self, from: data)
        }
        
        self.navigationController?.toolbar.isHidden = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckedCell", for: indexPath)
        
        cell.textLabel?.text = checkedList[indexPath.row].name + "   " + checkedList[indexPath.row].id + "   " + checkedList[indexPath.row].school
        cell.detailTextLabel?.text = checkedList[indexPath.row].time
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            checkedList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(checkedList), forKey:"checkedList")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return checkedList.count
    }
    
    // MARK: - Edit control
    
    @IBAction func edit(_ sender: Any) {
        
        if checkedList.count > 0 {
            tableView.allowsMultipleSelectionDuringEditing = !tableView.isEditing
            tableView.setEditing(!tableView.isEditing, animated: true)
            if tableView.isEditing {
                editButton.title = L10n.Button.done
                editButton.style = .done
                self.navigationController?.toolbar.isHidden = false
            } else {
                editButton.title = L10n.Button.edit
                editButton.style = .plain
                self.navigationController?.toolbar.isHidden = true
                allIsSelected = false
                selectAllButton.title = L10n.Button.selectAll
            }
        } else {
            let alertController = UIAlertController(
                title: L10n.CheckList.empty,
                message: "",
                preferredStyle: .alert
            )
            present(alertController, animated: true, completion: nil)
            alertController.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func selectAllItems(_ sender: Any) {
        
        if allIsSelected == false {
            allIsSelected = true
            selectAllButton.title = L10n.Button.deselectAll
            for index in 0..<checkedList.count {
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            }
        } else if allIsSelected == true {
            allIsSelected = false
            selectAllButton.title = L10n.Button.selectAll
            for index in 0..<checkedList.count {
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
    }
    
    @IBAction func deleteSelected(_ sender: Any) {
        
        if let indexPaths = self.tableView.indexPathsForSelectedRows {
            for indexPath in indexPaths.reversed() {
                checkedList.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: indexPaths, with: .fade)
            tableView.reloadData()
            
            if checkedList.count > 0 {
                allIsSelected = false
                selectAllButton.title = L10n.Button.selectAll
            } else if checkedList.count == 0 {
                allIsSelected = false
                selectAllButton.title = L10n.Button.selectAll
                tableView.isEditing = false
                editButton.title = L10n.Button.edit
                editButton.style = .plain
                self.navigationController?.toolbar.isHidden = true
            }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(checkedList), forKey:"checkedList")
        }
        
    }
    
    
    
    
    // MARK: - Scan control
    
    func ScanDidFinish(_ scanViewController: ScanViewController) {
        
        if scanViewController.scanString == "NO-QRCODE" {
            scanViewController.showErrorAlert(message: L10n.Alert.noQRCodeDetected)
        } else {
            tempStr = scanViewController.scanString
            let strArray = decodeInfo(str: tempStr)
            if strArray[0] == "CheckIN_QRcode" && strArray.count == 5 {
                
                if checkExist(name: strArray[1]) == false {
                    checkedList.append(CheckedUserData(name: strArray[1], id: strArray[2], school: strArray[3], time: strArray[4]))
                    scanViewController.showContinueNotice(strArray: strArray)
                    self.tableView.reloadData()
                    
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(checkedList), forKey:"checkedList")
                    
                } else {
                    scanViewController.showErrorAlert(message: L10n.Alert.duplicateCheckinMessage)
                }
            } else {
                scanViewController.showErrorAlert(message: L10n.Alert.invalidQRMessage)
            }
        }
        
        
        
    }
    
    func checkExist(name: String) -> Bool {
        for item in checkedList {
            if name == item.name {
                return true
            }
        }
        return false
    }
    
}
