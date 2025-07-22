/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/

import Foundation

/// This extension provides more readable date comparisons.
public extension Date {
    
    /// Whether the date occurs after another date.
    func isAfter(_ date: Date) -> Bool {
        self > date
    }
    
    /// Whether the date occurs before another date.
    func isBefore(_ date: Date) -> Bool {
        self < date
    }
    
    /// Whether the date is the same as another date.
    func isSame(as date: Date) -> Bool {
        self == date
    }

    /// Whether the date is the same as another date, for an
    /// explicity granularity, like `.day`.
    func isSame(
        _ granularity: Calendar.Component,
        as date: Date,
        for calendar: Calendar = .current
    ) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: granularity)
    }

    /// Whether the date is the same as another date, for an
    /// explicity granularity, like `.day`.
    func isThis(
        _ granularity: Calendar.Component,
        for calendar: Calendar = .current
    ) -> Bool {
        isSame(granularity, as: Date(), for: calendar)
    }
}
