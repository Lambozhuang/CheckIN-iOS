# CheckIN iOS

A simple iOS check-in application for group activities and events using QR code scanning.

## Features

- 📱 **QR Code Check-in**: Generate and display personal QR codes for quick check-in
- 📷 **QR Scanner**: Scan other participants' codes to verify attendance
- 👤 **User Profile**: Manage personal information (Name, Student ID, School)
- 🌍 **Bilingual Support**: English and Simplified Chinese (zh-Hans)
- ⏰ **Real-time Display**: Shows current time for time-stamped check-ins

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Project Structure

```
CheckIN/
├── View Controllers
│   ├── MainViewController.swift      # Home screen with QR code display
│   ├── ScanViewController.swift      # QR code scanner
│   ├── ProfileViewController.swift   # User profile management
│   ├── LoginViewController.swift     # Login screen
│   └── CheckListViewController.swift # Check-in history
├── Supporting Files
│   ├── Common.swift                  # Shared utilities
│   ├── Localization.swift            # Localization helpers
│   └── AppDelegate.swift
└── Localizations
    ├── en.lproj/                     # English strings
    └── zh-Hans.lproj/                # Chinese strings
```

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Lambozhuang/CheckIN-iOS.git
   ```

2. Open the project in Xcode:
   ```bash
   cd CheckIN-iOS
   open CheckIN.xcodeproj
   ```

3. Build and run the project (⌘ + R)

## Permissions

The app requires the following permissions:
- **Camera**: For scanning QR codes
- **Photo Library**: For accessing saved images

## Usage

1. **Setup Profile**: Enter your personal information (Name, ID, School)
2. **Generate QR Code**: Your unique QR code will be displayed on the home screen
3. **Check-in**: Show your QR code to event organizers for scanning
4. **Scan Others**: Use the scan tab to verify other participants

## Author

Lambo.T.Zhuang
