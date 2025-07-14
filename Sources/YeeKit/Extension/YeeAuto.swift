/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/

import Foundation
import UIKit

actor YEXAutoStorage {
    private var conversionClosure: (Double) async -> Double = { $0 }

    func set(_ closure: @escaping @Sendable (Double) async -> Double) {
        conversionClosure = closure
    }

    func convert(_ value: Double) async -> Double {
        return await conversionClosure(value)
    }
}

public struct YEXAuto {
    
    // 在AppDelegate
    // YEXAuto.set { (value) -> Double in
    // .... calculation ..
    // return value
    // }
    /// 设置转换闭包
    /// - Parameter conversion: 转换闭包
    static let storage = YEXAutoStorage()
    
    static func set(conversion: @escaping @Sendable (Double) async -> Double) {
        Task {
            await storage.set(conversion)
        }
    }
    
    static func setDefaultConversion() {
        Task { @MainActor in
            let base = 375.0
            let screenWidth = Double(UIScreen.main.bounds.width)
            let screenHeight = Double(UIScreen.main.bounds.height)
            let width = min(screenWidth, screenHeight)
            let scale = Double(UIScreen.main.scale)
            
            let closure: @Sendable (Double) async -> Double = { origin in
                let result = origin * (width / base)
                return (result * scale).rounded(.up) / scale
            }
            await storage.set(closure)
        }
    }
}

extension YEXAuto {
    
    public static func conversion(_ value: Double) -> Double {
        var result = value
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            result = await storage.convert(value)
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
}

extension Double {

    public var auto: Double {
        return YEXAuto.conversion(self)
    }
}

extension CGFloat {
    public var auto: Double {
        let temp = Double("\(self)") ?? 0
        return temp.auto
    }
}

extension Float {
    public var auto: Double {
        let temp = Double("\(self)") ?? 0
        return temp.auto
    }
}
extension Int {
    public var auto: Double {
        let temp = Double("\(self)") ?? 0
        return temp.auto
    }
}

extension BinaryInteger {
    public var auto: Double {
        let temp = Double("\(self)") ?? 0
        return temp.auto
    }
}

extension BinaryFloatingPoint {
    public var auto: Double {
        let temp = Double("\(self)") ?? 0
        return temp.auto
    }
}

extension CGPoint {
    public var auto: CGPoint {
        return CGPoint(x: x.auto, y: y.auto)
    }
}

extension CGSize {
    public var auto:CGSize {
        return CGSize(width: width.auto, height: height.auto)
    }
}

extension CGRect {
    public var auto: CGRect {
        return CGRect(origin: origin.auto, size: size.auto)
    }
}

extension CGVector {
    public var auto: CGVector {
        return CGVector(dx: dx.auto, dy: dy.auto)
    }
}

extension UIOffset {
    public var auto: UIOffset {
        return UIOffset(horizontal: horizontal.auto, vertical: vertical.auto)
    }
}

extension UIEdgeInsets {
    public var auto: UIEdgeInsets {
        return UIEdgeInsets(
            top: top.auto,
            left: left.auto,
            bottom: bottom.auto,
            right: right.auto
        )
    }
}
