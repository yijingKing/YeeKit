/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/

import UIKit

public extension Decimal {
    var double: Double {
        return  Double(truncating: self as NSNumber)
    }
    var string: String {
        return double.string
    }
}
