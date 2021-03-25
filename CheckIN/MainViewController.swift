//
//  MainViewController.swift
//  CheckIN
//
//  Created by Lambo.T.Zhuang on 2021/3/18.
//

import UIKit

var currentTime: String = ""

class MainViewController: UIViewController {
    
    private var timer: Timer?

    @IBOutlet weak var qrcodeImageView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var noticeTextLabel: UILabel!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var idTextLabel: UILabel!
    @IBOutlet weak var schoolTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserData.name = UserDefaults.standard.string(forKey: "name") ?? "NULL"
        UserData.id = UserDefaults.standard.string(forKey: "id") ?? "NULL"
        UserData.schoolChoice = UserDefaults.standard.integer(forKey: "schoolChoice")
        
        
        qrcodeImageView.image = createQRForString(qrString: encodeInfo(time: currentTime), qrImageName: "")
        
        let currentDate = Date(timeIntervalSinceNow: 1)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        currentTime = dateFormatter.string(from: currentDate)
        currentTimeLabel.text = currentTime
        
        // begin the loop
        time_addCycleTimer()
        qrcode_addCycleTimer()
    }
    
    
    fileprivate func time_addCycleTimer() {
        
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.time_HandleTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    @objc private func time_HandleTimer() {
        
        let currentDate = Date(timeIntervalSinceNow: 1)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        currentTime = dateFormatter.string(from: currentDate)
        currentTimeLabel.text = currentTime
        
    }
    
    
    fileprivate func qrcode_addCycleTimer() {
        
        timer = Timer(timeInterval: 10.0, target: self, selector: #selector(self.qrcode_HandleTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    @objc private func qrcode_HandleTimer() {
        
        qrcodeImageView.image = createQRForString(qrString: encodeInfo(time: currentTime), qrImageName: "")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        qrcodeImageView.image = createQRForString(qrString: encodeInfo(time: currentTime), qrImageName: "")
        
        nameTextLabel.text = UserData.name
        idTextLabel.text = UserData.id
        schoolTextLabel.text = schools[UserData.schoolChoice]
        
        if UserData.name == "NULL" {
            noticeTextLabel.textColor = .red
            noticeTextLabel.text = "暂未填写信息"
        } else {
            noticeTextLabel.textColor = .label
            noticeTextLabel.text = "请在签到时出示此码"
        }
    }
    
    
    // create QRcode image
    func createQRForString(qrString: String?, qrImageName: String?) -> UIImage?{
        
        if let sureQRString = qrString {
            
            let stringData = sureQRString.data(using: .utf8,
                                               allowLossyConversion: false)
            // create qrcode filter
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter.outputImage
             
            // create a black & white filter
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
             
            
            let codeImage = getHDImage(colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))
             
            
            return codeImage
        }
        return nil
    }
    
    fileprivate func getHDImage(_ outImage: CIImage) -> UIImage {
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let ciImage = outImage.transformed(by: transform)
        return UIImage(ciImage: ciImage)
    }
    

}
