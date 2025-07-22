/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/


import Foundation
import Combine
import SwiftUI

public extension Data {
    func toDictionary() -> [String: Any]? {
        do {
            // 将 Data 解析为 JSON 对象
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])
            
            // 检查解析结果是否为字典
            if let dictionary = jsonObject as? [String: Any] {
                return dictionary
            } else {
                print("JSON 格式不是字典类型")
                return nil
            }
        } catch {
            print("JSON 解析错误: \(error)")
            return nil
        }
    }

    /// Data转字符串 (UTF-8编码)
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    /// Data转JSON对象
    func toJSON() -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: [])
        } catch {
            print("JSON解析错误: \(error)")
            return nil
        }
    }

    /// Data转十六进制字符串
    func toHex() -> String {
        return map { String(format: "%02x", $0) }.joined()
    }

    /// base64字符串编码
    func toBase64() -> String {
        return self.base64EncodedString()
    }

    /// 将Data写入指定文件路径
    func writeToFile(at path: String) -> Bool {
        do {
            try self.write(to: URL(fileURLWithPath: path))
            return true
        } catch {
            print("写入文件失败: \(error)")
            return false
        }
    }

    /// 尝试解压缩 GZIP 数据（依赖 Compression 框架）
    func gunzip() -> Data? {
        guard !self.isEmpty else { return nil }
        guard let decompressed = try? (self as NSData).decompressed(using: .lzfse) else {
            print("GZIP 解压失败")
            return nil
        }
        return decompressed as Data
    }

    /// 将Data写入临时文件，返回URL
    func writeToTemporaryFile(fileName: String = UUID().uuidString) -> URL? {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try self.write(to: tempURL)
            return tempURL
        } catch {
            print("写入临时文件失败: \(error)")
            return nil
        }
    }

    /// 尝试解码为指定类型（需要Codable支持）
    func decoded<T: Decodable>(_ type: T.Type, using decoder: JSONDecoder = .init()) -> T? {
        do {
            return try decoder.decode(T.self, from: self)
        } catch {
            print("Data解码失败: \(error)")
            return nil
        }
    }
    /// 压缩
    func compressed(toMaxKB maxKB: Int) -> Data? {
        let maxBytes = maxKB * 1024
        var compression: CGFloat = 1.0
        var compressedData = self
        while compressedData.count > maxBytes && compression > 0.01 {
            compression -= 0.1
            if let newData = UIImage(data: self)?.jpegData(compressionQuality: compression) {
                compressedData = newData
            } else {
                return nil
            }
        }
        return compressedData.count <= maxBytes ? compressedData : nil
    }
}
