//
//  LocalizationExamples.swift
//  CheckIN
//
//  Created by GitHub Copilot on 2025/10/15.
//  This file contains examples of how to use localization in your app.
//  You can delete this file - it's just for reference!
//

import UIKit

// MARK: - Example 1: Basic Localization

class ExampleViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation title
        self.navigationItem.title = L10n.Nav.profile
        
        // Set label text
        titleLabel.text = L10n.Label.name
        
        // Set button title
        saveButton.setTitle(L10n.Button.save, for: .normal)
    }
}

// MARK: - Example 2: Alerts with Localization

extension ExampleViewController {
    
    func showSimpleAlert() {
        let alert = UIAlertController(
            title: L10n.Alert.cameraNotSupportedTitle,
            message: L10n.Alert.cameraNotSupportedMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: L10n.Alert.ok, style: .default))
        present(alert, animated: true)
    }
    
    func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: L10n.Button.save, style: .default) { _ in
            // Handle save
        })
        
        alert.addAction(UIAlertAction(title: L10n.Alert.discard, style: .destructive) { _ in
            // Handle discard
        })
        
        alert.addAction(UIAlertAction(title: L10n.Button.cancel, style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - Example 3: Strings with Parameters

extension ExampleViewController {
    
    func showCheckinSuccessAlert(for studentName: String, at time: String) {
        let alert = UIAlertController(
            title: L10n.Alert.checkinSuccessTitle(studentName),
            message: L10n.Alert.checkinSuccessMessage(time),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: L10n.Alert.continue_, style: .default) { _ in
            // Continue scanning
        })
        
        alert.addAction(UIAlertAction(title: L10n.Button.cancel, style: .cancel))
        
        present(alert, animated: true)
    }
    
    func updateCountLabel(_ count: Int) {
        titleLabel.text = L10n.CheckList.count(count)
        // English: "42 students checked in"
        // Chinese: "已签到 42 人"
    }
}

// MARK: - Example 4: Date Formatting with Localization

extension ExampleViewController {
    
    func formatCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = L10n.DateFormat.standard
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
        // English: "Oct 15, 2025 14:30:00"
        // Chinese: "2025年10月15日 14:30:00"
    }
}

// MARK: - Example 5: School Names

extension ExampleViewController {
    
    func displaySchoolName(for index: Int) {
        // Using the L10n helper
        titleLabel.text = L10n.School.name(for: index)
        // English: "ZJUT", "ZJU", "UNNC", "Others"
        // Chinese: "浙江工业大学", "浙江大学", "宁波诺丁汉大学", "其他"
        
        // Or using the schools array
        titleLabel.text = schools[index]
    }
}

// MARK: - Example 6: TableView with Localization

class ExampleTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = L10n.Nav.profile
        
        // Add edit button
        let editButton = UIBarButtonItem(
            title: L10n.Button.edit,
            style: .plain,
            target: self,
            action: #selector(editTapped)
        )
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func editTapped() {
        if tableView.isEditing {
            navigationItem.rightBarButtonItem?.title = L10n.Button.edit
            tableView.setEditing(false, animated: true)
        } else {
            navigationItem.rightBarButtonItem?.title = L10n.Button.done
            tableView.setEditing(true, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return L10n.Profile.sectionInfo
    }
}

// MARK: - Example 7: Alternative Localization Method

extension ExampleViewController {
    
    func alternativeLocalizationMethod() {
        // Using the String extension (less recommended but works)
        titleLabel.text = "label.name".localized
        saveButton.setTitle("button.save".localized, for: .normal)
        
        // With parameters
        let message = "checklist.count".localized(with: 42)
    }
}

// MARK: - Example 8: Custom Localization Function

func customLocalizedString(_ key: String, defaultValue: String = "") -> String {
    let localized = NSLocalizedString(key, comment: "")
    return localized == key ? defaultValue : localized
}

// Usage:
// let text = customLocalizedString("button.save", defaultValue: "Save")

// MARK: - Example 9: Testing Different Languages

extension ExampleViewController {
    
    func getCurrentLanguage() -> String {
        return Locale.current.languageCode ?? "en"
        // Returns "en" for English, "zh" for Chinese
    }
    
    func isChineseLanguage() -> Bool {
        return getCurrentLanguage().hasPrefix("zh")
    }
    
    func adjustUIForLanguage() {
        if isChineseLanguage() {
            // Chinese text tends to be more compact
            // Might need different font sizes or layouts
        } else {
            // English text might need more space
        }
    }
}

// MARK: - Quick Reference

/*
 QUICK REFERENCE - Common Localizations:
 
 Navigation Titles:
 - L10n.Nav.checkin
 - L10n.Nav.profile
 - L10n.Nav.editProfile
 - L10n.Nav.scan
 
 Labels:
 - L10n.Label.name
 - L10n.Label.studentId
 - L10n.Label.school
 - L10n.Label.time
 
 Buttons:
 - L10n.Button.save
 - L10n.Button.cancel
 - L10n.Button.done
 - L10n.Button.edit
 - L10n.Button.delete
 - L10n.Button.selectAll
 - L10n.Button.deselectAll
 
 Alerts:
 - L10n.Alert.ok
 - L10n.Alert.cancel (use L10n.Button.cancel)
 - L10n.Alert.discard
 - L10n.Alert.continue_
 - L10n.Alert.confirm
 
 Schools:
 - L10n.School.zjut
 - L10n.School.zju
 - L10n.School.unnc
 - L10n.School.others
 - L10n.School.name(for: index)
 
 Date:
 - L10n.DateFormat.standard
 
 Tab Bar:
 - L10n.Tab.home
 - L10n.Tab.scan
 - L10n.Tab.profile
 
 Main Screen:
 - L10n.Main.qrNotice
 - L10n.Main.noInfoNotice
 
 Check List:
 - L10n.CheckList.empty
 - L10n.CheckList.count(number)
 */
