/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/

import Foundation

///string and int
public struct YEXStrInt: Codable {
    public var int: Int?
    public var string: String?
    
    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        if let stringValue = try? singleValueContainer.decode(String.self) {
            string = stringValue
            int = Int(stringValue)
        } else if let intValue = try? singleValueContainer.decode(Int.self) {
            int = intValue
            string = String(intValue)
        } else {
            int = nil
            string = nil
        }
    }
}

///bool int string
public struct YEXBool: Codable {
    public var int: Int?
    public var bool: Bool?
    public var string: String?
    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        if let boolValue = try? singleValueContainer.decode(Bool.self) {
            bool = boolValue
            int = boolValue ? 1 : 0
            string = boolValue ? "1" : "0"
        } else if let intValue = try? singleValueContainer.decode(Int.self) {
            int = intValue
            bool = intValue == 1 ? true : false
            string = String(intValue)
        } else if let stringValue = try? singleValueContainer.decode(String.self) {
            int = Int(stringValue)
            bool = stringValue == "1" ? true : false
            string = stringValue
        } else {
            int = nil
            bool = nil
            string = nil
        }
    }
    
}

///string  double decimal
public struct YEXDouble: Codable {
    public var double: Double?
    public var decimal: Decimal?
    public var string: String?
    
    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        
        if let stringValue = try? singleValueContainer.decode(String.self) {
            string = stringValue
            double = Double(stringValue)
            decimal = Decimal(Double(stringValue) ?? 0)
        } else if let doubleValue = try? singleValueContainer.decode(Double.self) {
            double = doubleValue
            string = String(doubleValue)
            decimal = Decimal(Double(doubleValue) )
        } else if let decimalValue = try? singleValueContainer.decode(Decimal.self) {
            double = Double(truncating: decimalValue as NSNumber)
            string = String(Double(truncating: decimalValue as NSNumber))
            decimal = decimalValue
        } else {
            decimal = nil
            double = nil
            string = nil
        }
    }
}
