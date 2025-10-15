//
//  GlobalData.swift
//  CheckIN
//
//  Created by Lambo.T.Zhuang on 2021/3/18.
//

import Foundation

struct UserData {
    static var name: String = ""
    static var id: String = ""
    static var schoolChoice: Int = 0
}

// School codes for encoding (language-independent)
let schoolCodes: [String] = ["ZJUT", "ZJU", "UNNC", "OTHERS"]

// Localized school names
var schools: [String] {
    return [
        L10n.School.zjut,
        L10n.School.zju,
        L10n.School.unnc,
        L10n.School.others
    ]
}

extension String {

    func base64Encoded() -> String {
        data(using: .utf8)?.base64EncodedString() ?? ""
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

func encodeInfo(time: String) -> String {
    
    var tempStr: String = "CheckIN_QRcode".base64Encoded() + "_"
    tempStr += UserData.name.base64Encoded() + "_"
    tempStr += UserData.id.base64Encoded() + "_"
    // Use school code instead of localized name for encoding
    tempStr += schoolCodes[UserData.schoolChoice].base64Encoded() + "_"
    tempStr += time.base64Encoded()
    return tempStr
}

func decodeInfo(str: String) -> [String] {
    
    var strArray = str.components(separatedBy: "_")
    for index in 0..<strArray.count {
        strArray[index] = strArray[index].base64Decoded() ?? ""
    }
    return strArray
}
