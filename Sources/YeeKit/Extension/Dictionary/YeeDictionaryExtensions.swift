/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/


import Foundation
import Combine
import SwiftUI

public extension Dictionary where Key == String, Value == Any {
    /// 字典转JSON字符串
    func toJSONString() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("JSON序列化错误: \(error)")
            return nil
        }
    }
    
    /// 字典转Data
    func toData() -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: [])
        } catch {
            print("字典转Data错误: \(error)")
            return nil
        }
    }
}

public extension Dictionary {
    func compactMapKeys<T: Hashable>(_ transform: (Key) throws -> T?) rethrows -> [T: Value] {
        var result = [T: Value]()
        for (key, value) in self {
            if let newKey = try transform(key) {
                result[newKey] = value
            }
        }
        return result
    }
}
public extension Dictionary where Key == String {
    /// 泛型安全取值
    func value<T>(forKey key: String, as type: T.Type) -> T? {
        return self[key] as? T
    }
    /// 安全地从字典中取出字符串值
    func stringValue(forKey key: String) -> String? {
        guard let value = self[key] else { return nil }
        if let str = value as? String {
            return str
        } else if let num = value as? NSNumber {
            return num.stringValue
        } else if let any = value as? CustomStringConvertible {
            return any.description
        }
        return nil
    }
    /// 安全取出 Bool 值
    func boolValue(forKey key: String) -> Bool? {
        if let value = self[key] {
            if let b = value as? Bool {
                return b
            } else if let str = value as? String {
                return (str as NSString).boolValue
            } else if let num = value as? NSNumber {
                return num.boolValue
            }
        }
        return nil
    }

    /// 安全取出 Int 值
    func intValue(forKey key: String) -> Int? {
        if let value = self[key] {
            if let i = value as? Int {
                return i
            } else if let str = value as? String {
                return Int(str)
            } else if let num = value as? NSNumber {
                return num.intValue
            }
        }
        return nil
    }

    /// 安全取出 Double 值
    func doubleValue(forKey key: String) -> Double? {
        if let value = self[key] {
            if let d = value as? Double {
                return d
            } else if let str = value as? String {
                return Double(str)
            } else if let num = value as? NSNumber {
                return num.doubleValue
            }
        }
        return nil
    }
}
