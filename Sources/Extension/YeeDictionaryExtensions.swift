//
//  DictionaryExtension.swift
//  LCProduct
//
//  Created by 祎 on 2025/7/9.
//


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
extension Dictionary {
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
