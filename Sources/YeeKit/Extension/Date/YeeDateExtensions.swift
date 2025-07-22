/*******************************************************************************
 Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

 Author:        ╰莪呮想好好宠Nǐつ
 E-mail:        1091676312@qq.com
 GitHub:        https://github.com/yijingKing
 ********************************************************************************/

import Foundation
import UIKit

/*
 G:      公元时代，例如AD公元
 yy:     年的后2位
 yyyy:   完整年
 MM:     月，显示为1-12,带前置0
 MMM:    月，显示为英文月份简写,如 Jan
 MMMM:   月，显示为英文月份全称，如 Janualy
 dd:     日，2位数表示，如02
 d:      日，1-2位显示，如2，无前置0
 EEE:    简写星期几，如Sun
 EEEE:   全写星期几，如Sunday
 aa:     上下午，AM/PM
 H:      时，24小时制，0-23
 HH:     时，24小时制，带前置0
 h:      时，12小时制，无前置0
 hh:     时，12小时制，带前置0
 m:      分，1-2位
 mm:     分，2位，带前置0
 s:      秒，1-2位
 ss:     秒，2位，带前置0
 S:      毫秒
 Z:      GMT（时区）
 */
/// 60s
public let YEXDate_minute = 60
/// 3600s
public let YEXDate_hour = 60 * 60
/// 86400
public let YEXDate_day = 60 * 60 * 24
/// 604800
public let YEXDate_week = 60 * 60 * 24 * 7
/// 31556926
public let YEXDate_year = 60 * 60 * 24 * 365

public enum YEXDateFormatter: String {
    /// 月
    case dateModeM = "MMMM"
    /// 星期
    case dateModeE = "EEEE"
    /// 年
    case dateModeY = "yyyy"
    /// 年月
    case dateModeYM = "yyyy-MM"
    /// 年月日
    case dateModeYMD = "yyyy-MM-dd"
    /// 年月日时
    case dateModeYMDH = "yyyy-MM-dd HH"
    /// 年月日时分
    case dateModeYMDHM = "yyyy-MM-dd HH:mm"
    /// 年月日时分秒
    case dateModeYMDHMS = "yyyy-MM-dd HH:mm:ss"
    /// 年月日时分秒毫秒
    case dateModeYMDHMSSS = "yyyy-MM-dd HH:mm:ss SSS"
}

// MARK: 时间条的显示格式

public enum YEXTimeBarType {
    // 默认格式，如 9秒：09，66秒：01：06，
    case normal
    case second
    case minute
    case hour
}

/// 时间戳的类型
public enum YEXTimestampType: Int {
    /// 秒
    case second
    /// 毫秒
    case millisecond
}

public enum DateFormattersManager {
    public static let actor = DateFormattersActor()
}

public actor DateFormattersActor {
    private var storage = [String: DateFormatter]()

    public func getValue(for key: String) -> DateFormatter? {
        return storage[key]
    }

    public func setValue(for key: String, value: DateFormatter) {
        storage[key] = value
    }
}

public extension Date {

    /// 秒级 时间戳 - 10 位
    var secondStamp: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return "\(Int(timeInterval))"
    }

    /// 毫秒级 时间戳 - 13 位
    var milliStamp: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(Darwin.round(timeInterval * 1000))
        return "\(millisecond)"
    }

    /// 时间戳(支持 10 位 和 13 位) 转 Date
    /// - Parameter timestamp: 时间戳
    /// - Returns: 返回 Date
    static func timestampToFormatterDate(timestamp: String) -> Date {
        guard timestamp.count == 10 || timestamp.count == 13 else {
            #if DEBUG
            fatalError("时间戳位数不是 10 也不是 13")
            #else
            return Date()
            #endif
        }
        guard let timestampInt = timestamp.toInt() else {
            #if DEBUG
            fatalError("时间戳位有问题")
            #else
            return Date()
            #endif
        }
        let timestampValue = timestamp.count == 10 ? timestampInt : timestampInt / 1000
        // 时间戳转为Date
        let date = Date(timeIntervalSince1970: TimeInterval(timestampValue))
        return date
    }

    /// 带格式的时间转 时间戳，支持返回 13位 和 10位的时间戳，时间字符串和时间格式必须保持一致
    /// - Parameters:
    ///   - timeString: 时间字符串，如：2020-10-26 16:52:41
    ///   - formatter: 时间格式，如：yyyy-MM-dd HH:mm:ss
    ///   - timestampType: 返回的时间戳类型，默认是秒 10 为的时间戳字符串
    /// - Returns: 返回转化后的时间戳
    static func formatterTimeStringToTimestamp(timesString: String, formatter: String, timestampType: YEXTimestampType = .second) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        guard let date = dateFormatter.date(from: timesString) else {
            #if DEBUG
            fatalError("时间有问题")
            #else
            return ""
            #endif
        }
        if timestampType == .second {
            return "\(Int(date.timeIntervalSince1970))"
        }
        return "\(Int((date.timeIntervalSince1970) * 1000))"
    }

    /// 秒转换成播放时间条的格式
    /// - Parameters:
    ///   - secounds: 秒数
    ///   - type: 格式类型
    /// - Returns: 返回时间条
    static func getFormatPlayTime(seconds: Int, type: YEXTimeBarType = .normal) -> String {
        if seconds <= 0 {
            return "00:00"
        }
        // 秒
        let second = seconds % 60
        if type == .second {
            return String(format: "%02d", seconds)
        }
        // 分钟
        var minute = Int(seconds / 60)
        if type == .minute {
            return String(format: "%02d:%02d", minute, second)
        }
        // 小时
        var hour = 0
        if minute >= 60 {
            hour = Int(minute / 60)
            minute = minute - hour * 60
        }
        if type == .hour {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        // normal 类型
        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        if minute > 0 {
            return String(format: "%02d:%02d", minute, second)
        }
        return String(format: "%02d", second)
    }

    /// 取得与当前时间的间隔差
    /// - Returns: 时间差
    var callTimeAfterNow: String {
        let timeInterval = Date().timeIntervalSince(self)
        if timeInterval < 0 {
            return "刚刚"
        }
        let interval = fabs(timeInterval)
        let i60 = interval / 60
        let i3600 = interval / 3600
        let i86400 = interval / 86400
        let i2592000 = interval / 2592000
        let i31104000 = interval / 31104000

        var time: String!
        if i3600 < 1 {
            let s = NSNumber(value: i60 as Double).intValue
            if s == 0 {
                time = "刚刚"
            } else {
                time = "\(s)分钟前"
            }
        } else if i86400 < 1 {
            let s = NSNumber(value: i3600 as Double).intValue
            time = "\(s)小时前"
        } else if i2592000 < 1 {
            let s = NSNumber(value: i86400 as Double).intValue
            time = "\(s)天前"
        } else if i31104000 < 1 {
            let s = NSNumber(value: i2592000 as Double).intValue
            time = "\(s)个月前"
        } else {
            let s = NSNumber(value: i31104000 as Double).intValue
            time = "\(s)年前"
        }
        return time
    }

    /// 获取某一年某一月的天数
    /// - Parameters:
    ///   - year: 年份
    ///   - month: 月份
    /// - Returns: 返回天数
    func daysCount(year: Int?, month: Int?) -> Int {
        guard let year, let month else { return 0 }
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            return isLeapYear ? 29 : 28
        default:
            #if DEBUG
            fatalError("非法的月份:\(month)")
            #else
            return 0
            #endif
        }
    }

    /// 获取当前月的天数
    /// - Returns: 返回天数
    var currentMonthDays: Int {
        return daysCount(year: self.year, month: self.month)
    }
}

// MARK: - -- 转换

public extension Date {
    // MARK: - -- 将日期转换为字符串

    /// 将日期转换为字符串
    func toString(format dateFormat: YEXDateFormatter = .dateModeYMDHMS, _ timeZone: TimeZone = NSTimeZone.system) async -> String {
        let formatter = await getDateFormatter(for: dateFormat)
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }

    // MARK: - -- 将日期转换为字符串

    /// 将日期转换为字符串
    func toString(format formatstr: String, _ timeZone: TimeZone = NSTimeZone.system) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = formatstr
        formatter.timeZone = timeZone
        let date = formatter.string(from: self)
        return date
    }
}

public extension Date {
    // MARK: - -- 计算

    /// 计算两时间差
    func calculate(_ formatter: String, startTime: String, endTime: String, timeZone: TimeZone? = nil) -> DateComponents? {
        let dateFormatter = DateFormatter()

        dateFormatter.timeZone = timeZone ?? TimeZone(secondsFromGMT: 8)
        dateFormatter.dateFormat = formatter
        if let date1 = dateFormatter.date(from: startTime), let date2 = dateFormatter.date(from: endTime) {
            let components = NSCalendar.current.dateComponents([.year, .month, .day], from: date1, to: date2)
            return components
        } else {
            return nil
        }
    }

    /// 计算两时间差多少年
    func calculateYear(_ formatter: String, startTime: String, endTime: String, timeZone: TimeZone? = nil) -> Int? {
        let dateFormatter = DateFormatter()

        dateFormatter.timeZone = timeZone ?? TimeZone(secondsFromGMT: 8)
        dateFormatter.dateFormat = formatter

        if let date1 = dateFormatter.date(from: startTime), let date2 = dateFormatter.date(from: endTime) {
            let components = NSCalendar.current.dateComponents([.year], from: date1, to: date2)
            return components.year
        }
        return nil
    }

    /// 计算两时间差多少月
    func calculateMonth(_ formatter: String, startTime: String, endTime: String, timeZone: TimeZone? = nil) -> Int? {
        let dateFormatter = DateFormatter()

        dateFormatter.timeZone = timeZone ?? TimeZone(secondsFromGMT: 8)
        dateFormatter.dateFormat = formatter

        if let date1 = dateFormatter.date(from: startTime), let date2 = dateFormatter.date(from: endTime) {
            let components = NSCalendar.current.dateComponents([.month], from: date1, to: date2)
            return components.month
        }
        return nil
    }

    /// 计算两时间差多少天
    func calculateDay(_ formatter: String, startTime: String, endTime: String, timeZone: TimeZone? = nil) -> Int? {
        let dateFormatter = DateFormatter()

        dateFormatter.timeZone = timeZone ?? TimeZone(secondsFromGMT: 8)
        dateFormatter.dateFormat = formatter

        if let date1 = dateFormatter.date(from: startTime), let date2 = dateFormatter.date(from: endTime) {
            let components = NSCalendar.current.dateComponents([.day], from: date1, to: date2)
            return components.day
        }
        return nil
    }

    ///  当前到date经过了多少天
    func daysInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff / Double(YEXDate_day))
        return diff
    }

    ///  当前到date经过了多少小时
    func hoursInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff / Double(YEXDate_hour))
        return diff
    }

    ///  当前到date经过了多少分钟
    func minutesInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff / Double(YEXDate_minute))
        return diff
    }

    ///  当前到date经过了多少秒
    func secondsInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff)
        return diff
    }

    ///  Easy creation of time passed String. Can be Years, Months, days, hours, minutes or seconds
    var timePassedString: String {
        let date = Date()
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self, to: date, options: [])

        if components.year! >= 1 {
            return "\(components.year!)年前"
        } else if components.month! >= 1 {
            return "\(components.month!)月前"
        } else if components.day! >= 1 {
            return "\(components.day!)天前"
        } else if components.hour! >= 1 {
            return "\(components.hour!)小时前"
        } else if components.minute! >= 1 {
            return "\(components.minute!)分钟前"
        } else if components.second! >= 1 {
            return "\(components.second!)秒前"
        } else {
            return "刚刚"
        }
    }

    ///  Easy creation of time passed String. Can be Years, Months, days, hours, minutes or seconds. Useful for localization
    var timePassed: YEXTimePassed {
        let date = Date()
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self, to: date, options: [])

        if components.year! >= 1 {
            return YEXTimePassed.year(components.year!)
        } else if components.month! >= 1 {
            return YEXTimePassed.month(components.month!)
        } else if components.day! >= 1 {
            return YEXTimePassed.day(components.day!)
        } else if components.hour! >= 1 {
            return YEXTimePassed.hour(components.hour!)
        } else if components.minute! >= 1 {
            return YEXTimePassed.minute(components.minute!)
        } else if components.second! >= 1 {
            return YEXTimePassed.second(components.second!)
        } else {
            return YEXTimePassed.now
        }
    }

    // MARK: - -- 检测

    // MARK: - -- 是否未来

    ///  是否未来
    var future: Bool {
        return self > Date()
    }

    // MARK: - -- 是否过去

    ///  是否过去
    var isPast: Bool {
        return self < Date()
    }

    // MARK: - -- 今天

    //  今天
    var isToday: Bool {
        get async {
            let dateFormatter = await self.getDateFormatter(for: .dateModeYMD)
            return dateFormatter.string(from: self) == dateFormatter.string(from: Date())
        }
    }

    // MARK: - -- 昨天

    ///  昨天
    var isYesterday: Bool {
        get async {
            let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            let dateFormatter = await self.getDateFormatter(for: .dateModeYMD)
            return dateFormatter.string(from: self) == dateFormatter.string(from: yesterDay!)
        }
    }

    // MARK: - -- 明天

    ///  明天
    var isTomorrow: Bool {
        get async {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            let dateFormatter = await self.getDateFormatter(for: .dateModeYMD)

            return dateFormatter.string(from: self) == dateFormatter.string(from: tomorrow!)
        }
    }

    // MARK: - -- 在本月内
    ///  在本月内
    var isThisMonth: Bool {
        let today = Date()
        return month == today.month && year == today.year
    }

    // MARK: - -- 在本周内

    ///  在本周内
    var isThisWeek: Bool {
        return minutesInBetweenDate(Date()) <= Double(Date.minutesInAWeek)
    }

    // MARK: - -- era

    ///  era
    var era: Int {
        return Calendar.current.component(.era, from: self)
    }

    // MARK: - -- 工作日

    ///  工作日
    var weekdayString: String {
        get async {
            let dateFormatter = await self.getDateFormatter(for: .dateModeE)
            return dateFormatter.string(from: self)
        }
    }

    // MARK: - -- 月

    ///  月
    var monthString: String {
        get async {
            let dateFormatter = await self.getDateFormatter(for: .dateModeM)
            return dateFormatter.string(from: self)
        }
    }

    // MARK: - -- 纳秒

    ///  纳秒
    var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self)
    }
}

public extension Date {
    static let minutesInAWeek = YEXDate_week

    // MARK: - -- 初始化

    ///  初始化
    init?(fromString string: String,
          format: String,
          timezone: TimeZone = TimeZone.autoupdatingCurrent,
          locale: Locale = Locale.current) async
    {
        // Make this initializer async to allow actor access
        var dateFormatter: DateFormatter?
        if let cached = try? await DateFormattersManager.actor.getValue(for: format) {
            dateFormatter = cached
        }
        
        if let dateFormatter = dateFormatter {
            if let date = dateFormatter.date(from: string) {
                self = date
            } else {
                return nil
            }
        } else {
            let formatter = DateFormatter()
            formatter.timeZone = timezone
            formatter.locale = locale
            formatter.dateFormat = format
            await DateFormattersManager.actor.setValue(for: format, value: formatter)
            if let date = formatter.date(from: string) {
                self = date
            } else {
                return nil
            }
        }
    }

    ///  Initializes Date from string returned from an http response, according to several RFCs / ISO
    init?(httpDateString: String) async {
        if let rfc1123 = await Date(fromString: httpDateString, format: "EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz") {
            self = rfc1123
            return
        }
        if let rfc850 = await Date(fromString: httpDateString, format: "EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z") {
            self = rfc850
            return
        }
        if let asctime = await Date(fromString: httpDateString, format: "EEE MMM d HH':'mm':'ss yyyy") {
            self = asctime
            return
        }
        if let iso8601DateOnly = await Date(fromString: httpDateString, format: "yyyy-MM-dd") {
            self = iso8601DateOnly
            return
        }
        if let iso8601DateHrMinOnly = await Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mmxxxxx") {
            self = iso8601DateHrMinOnly
            return
        }
        if let iso8601DateHrMinSecOnly = await Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mm:ssxxxxx") {
            self = iso8601DateHrMinSecOnly
            return
        }
        if let iso8601DateHrMinSecMs = await Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mm:ss.SSSxxxxx") {
            self = iso8601DateHrMinSecMs
            return
        }
        return nil
    }

    /// 时间戳初始化m
    init?(_ timeInterval: Double) {
        self = Date(timeIntervalSince1970: timeInterval)
    }

    // MARK: - -- 格式化

    ///  格式化
    fileprivate func getDateFormatter(for format: YEXDateFormatter) async -> DateFormatter {
        var dateFormatter: DateFormatter?
        if let _dateFormatter = await DateFormattersManager.actor.getValue(for: format.rawValue) {
            dateFormatter = _dateFormatter
        } else {
            dateFormatter = await createDateFormatter(for: format.rawValue)
        }
        return dateFormatter!
    }

    // MARK: - -- 格式化

    /// 格式化
    fileprivate func createDateFormatter(for format: String) async -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        await DateFormattersManager.actor.setValue(for: format, value: formatter)
        return formatter
    }
}

public enum YEXTimePassed {
    case year(Int)
    case month(Int)
    case day(Int)
    case hour(Int)
    case minute(Int)
    case second(Int)
    case now
}

extension YEXTimePassed: Equatable {
    public static func == (lhs: YEXTimePassed, rhs: YEXTimePassed) -> Bool {
        switch (lhs, rhs) {
        case (.year(let a), .year(let b)):
            return a == b

        case (.month(let a), .month(let b)):
            return a == b

        case (.day(let a), .day(let b)):
            return a == b

        case (.hour(let a), .hour(let b)):
            return a == b

        case (.minute(let a), .minute(let b)):
            return a == b

        case (.second(let a), .second(let b)):
            return a == b

        case (.now, .now):
            return true

        default:
            return false
        }
    }
}

public class SynchronizedDictionary<Key: Hashable, Value> {
    fileprivate let queue = DispatchQueue(label: "SynchronizedDictionary", attributes: .concurrent)
    fileprivate var dict = [Key: Value]()

    public func getValue(for key: Key) -> Value? {
        var value: Value?
        queue.sync {
            value = dict[key]
        }
        return value
    }

    public func setValue(for key: Key, value: Value) {
        queue.sync {
            dict[key] = value
        }
    }

    public func getSize() -> Int {
        return dict.count
    }

    public func containValue(for key: Key) -> Bool {
        guard let _ = dict.index(forKey: key) else {
            return false
        }
        return true
    }
}

// MARK: - -- 前后时间

public extension Date {
    // MARK: - -- 加几天

    /// 加几天
    func addingDay(_ days: Int) -> Date? {
        var c = DateComponents()
        c.day = days
        let calender = Calendar(identifier: .chinese)

        return calender.date(byAdding: c, to: self)
    }

    // MARK: - -- 减几天

    /// 减几天
    func subtractingDay(_ days: Int) -> Date? {
        var c = DateComponents()
        c.day = days * -1
        let calender = Calendar(identifier: .chinese)

        return calender.date(byAdding: c, to: self)
    }

    // MARK: - -- 增加几小时

    /// 增加几小时
    func addingHours(_ dHours: Int) -> Date? {
        let aTimeInterval = TimeInterval(self.timeIntervalSinceReferenceDate + Double(YEXDate_hour * dHours))
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }

    // MARK: - -- 减少几小时

    /// 减少几小时
    func subtractingHours(_ dHours: Int) -> Date {
        let aTimeInterval = TimeInterval(self.timeIntervalSinceReferenceDate - Double(YEXDate_hour * dHours))
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }

    /// 转时间戳
    func toCurrentTimeStamp(_ isMS: Bool = true) -> Int? {
        let dateFormatter = DateFormatter()
        var format = "yyyy-MM-dd HH:mm:ss.SSS"
        if isMS == false {
            format = "yyy-MM-dd HH:mm:ss"
        }
        dateFormatter.dateFormat = format
        let dataString = dateFormatter.string(from: self)

        if let date = dateFormatter.date(from: dataString) {
            let stamp = date.timeIntervalSince1970
            return isMS ? Int(stamp * 1000) : Int(stamp)
        }
        return nil
    }
}
