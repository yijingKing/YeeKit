/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/

import Foundation

///工具类
public struct YeeTool {
    /// 版本判断
    static func compareVersion(nowVersion:String, newVersion:String) -> Bool {
        let nowArray = nowVersion.split(separator: ".")
        
        let newArray = newVersion.split(separator: ".")
        
        let big = nowArray.count > newArray.count ? newArray.count : nowArray.count
        
        for index in 0...big - 1 {
            
            let first = nowArray[index]
            let second = newArray[index]
            if Int(first)! < Int(second)!  {
                return true
            }
        }
        return false
    }
}
