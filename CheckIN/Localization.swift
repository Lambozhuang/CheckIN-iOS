//
//  Localization.swift
//  CheckIN
//
//  Created by GitHub Copilot on 2025/10/15.
//

import Foundation

/// Localization helper for easy access to localized strings
enum L10n {
    
    // MARK: - Tab Bar
    enum Tab {
        static let home = localized("tab.home")
        static let scan = localized("tab.scan")
        static let profile = localized("tab.profile")
    }
    
    // MARK: - Navigation
    enum Nav {
        static let checkin = localized("nav.checkin")
        static let profile = localized("nav.profile")
        static let editProfile = localized("nav.edit_profile")
        static let scan = localized("nav.scan")
    }
    
    // MARK: - Labels
    enum Label {
        static let name = localized("label.name")
        static let studentId = localized("label.student_id")
        static let school = localized("label.school")
        static let time = localized("label.time")
        static let null = localized("label.null")
    }
    
    // MARK: - Main Screen
    enum Main {
        static let qrNotice = localized("main.qr_notice")
        static let noInfoNotice = localized("main.no_info_notice")
    }
    
    // MARK: - Profile
    enum Profile {
        static let sectionInfo = localized("profile.section.info")
    }
    
    // MARK: - Edit Profile
    enum Edit {
        static let sectionFillInfo = localized("edit.section.fill_info")
        static let sectionSelectSchool = localized("edit.section.select_school")
        static let placeholderName = localized("edit.placeholder.name")
        static let placeholderStudentId = localized("edit.placeholder.student_id")
    }
    
    // MARK: - Buttons
    enum Button {
        static let save = localized("button.save")
        static let cancel = localized("button.cancel")
        static let done = localized("button.done")
        static let edit = localized("button.edit")
        static let delete = localized("button.delete")
        static let selectAll = localized("button.select_all")
        static let deselectAll = localized("button.deselect_all")
    }
    
    // MARK: - Alerts
    enum Alert {
        static let unsavedTitle = localized("alert.unsaved_title")
        static let unsavedMessage = localized("alert.unsaved_message")
        static let discard = localized("alert.discard")
        static let keepEditing = localized("alert.keep_editing")
        static let cameraNotSupportedTitle = localized("alert.camera_not_supported_title")
        static let cameraNotSupportedMessage = localized("alert.camera_not_supported_message")
        static let ok = localized("alert.ok")
        static let invalidQRTitle = localized("alert.invalid_qr_title")
        static let invalidQRMessage = localized("alert.invalid_qr_message")
        static let duplicateCheckinTitle = localized("alert.duplicate_checkin_title")
        static let duplicateCheckinMessage = localized("alert.duplicate_checkin_message")
        static let noQRCodeDetected = localized("alert.no_qrcode_detected")
        static func checkinSuccessTitle(_ name: String) -> String {
            return String(format: localized("alert.checkin_success_title"), name)
        }
        static func checkinSuccessMessage(_ time: String) -> String {
            return String(format: localized("alert.checkin_success_message"), time)
        }
        static let continue_ = localized("alert.continue")
        static let confirm = localized("alert.confirm")
    }
    
    // MARK: - Check List
    enum CheckList {
        static let empty = localized("checklist.empty")
        static func count(_ number: Int) -> String {
            return String(format: localized("checklist.count"), number)
        }
    }
    
    // MARK: - Schools
    enum School {
        static let zjut = localized("school.zjut")
        static let zju = localized("school.zju")
        static let unnc = localized("school.unnc")
        static let others = localized("school.others")
        
        /// Returns localized school name for the given index
        static func name(for index: Int) -> String {
            switch index {
            case 0: return zjut
            case 1: return zju
            case 2: return unnc
            case 3: return others
            default: return others
            }
        }
    }
    
    // MARK: - Date Format
    enum DateFormat {
        static let standard = localized("date.format")
    }
    
    // MARK: - Helper Method
    private static func localized(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}

// MARK: - Extension for backwards compatibility
extension String {
    /// Convenience method to localize strings
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Convenience method to localize strings with arguments
    func localized(with arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}
