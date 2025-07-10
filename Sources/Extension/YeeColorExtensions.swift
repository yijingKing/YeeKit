/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/

import Foundation
import SwiftUI

public extension Color {
    static let themeColor = Color(hex: "#0680EF")
    static let themeBackground = Color(hex: "#F5F5F5")
    static let themeTitle = Color(hex: "#212121")
    static let themeSubtitle = Color(hex: "#898888")
    static let themeSeparator = Color(hex: "#F1F0F0")
    static let themeBorder = Color(hex: "#989797")
    static let themePrimary = Color(hex: "#0680EF")
    static let hex212121 = Color(hex: "#212121")
}

extension Color {
    /// 使用十六进制字符串初始化颜色
    /// - Parameter hex: 十六进制字符串，支持带#或不带#，6位或8位格式
    public init(hex: String) {
        var cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedHex.hasPrefix("#") {
            // 移除前缀 #
            cleanedHex = String(cleanedHex.dropFirst())
        }

        let scanner = Scanner(string: cleanedHex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double

        switch cleanedHex.count {
        case 6:
            red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
            green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
            blue = Double(rgbValue & 0x0000FF) / 255.0
            alpha = 1.0
        case 8:
            red = Double((rgbValue & 0xFF000000) >> 24) / 255.0
            green = Double((rgbValue & 0x00FF0000) >> 16) / 255.0
            blue = Double((rgbValue & 0x0000FF00) >> 8) / 255.0
            alpha = Double(rgbValue & 0x000000FF) / 255.0
        default:
            red = 0.0
            green = 0.0
            blue = 0.0
            alpha = 1.0
        }

        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}
