/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/


import Foundation
import Combine
import SwiftUI

extension Encodable {
    func toDictionary() -> [String: Any]? {
        do {
            let encoder = JSONEncoder()
            // 设置编码策略（比如 ISO8601 时间格式等，也可以不设置）
            encoder.keyEncodingStrategy = .useDefaultKeys
            let data = try encoder.encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return jsonObject as? [String: Any]
        } catch {
            print("转字典失败：\(error)")
            return nil
        }
    }
    var toJson: String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data) else { return nil }
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
