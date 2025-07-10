/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/


import Foundation
import Combine
import SwiftUI

public extension String {
    /// 字符串转Int
    func toInt() -> Int? {
        return Int(self)
    }
    
    /// 字符串转Double
    func toDouble() -> Double? {
        return Double(self)
    }
    
    /// 字符串转Bool
    func toBool() -> Bool? {
        let lowercased = self.lowercased()
        switch lowercased {
            case "true", "yes", "1":
                return true
            case "false", "no", "0":
                return false
            default:
                return nil
        }
    }
    
    /// 字符串转Date
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    /// 字符串转URL
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    /// 字符串转Data (UTF-8编码)
    func toData() -> Data? {
        return data(using: .utf8)
    }
    
    func toDateString(fromFormat: String = "yyyy-MM-dd HH:mm:ss", toFormat: String) -> String? {
            let formatter = DateFormatter()
            formatter.dateFormat = fromFormat
            if let date = formatter.date(from: self) {
                formatter.dateFormat = toFormat
                return formatter.string(from: date)
            }
            return nil
        }
}

public extension String {
    /// 验证是否为有效的电子邮件地址
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    /// 验证是否为有效的URL
    func isValidURL() -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        let urlPred = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlPred.evaluate(with: self)
    }
}
