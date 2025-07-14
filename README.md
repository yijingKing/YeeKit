# YeeKit

YeeKit 是一个功能丰富的 Swift 工具库，提供了系统操作、数据处理、日期转换、自定义类型、视图扩展等多个方面的实用功能，旨在帮助开发者更高效地进行 iOS 应用开发。

## 功能特性
1. **系统操作**：提供拨打电话、打开设置、相册权限检测和打开相册相机等系统操作功能。
2. **数据处理**：支持数据与字典、字符串、JSON 对象之间的相互转换，以及数据的压缩、解压缩和写入文件等操作。
3. **日期转换**：实现了日期与时间戳之间的相互转换，以及秒数转换为播放时间条格式和计算与当前时间的间隔差等功能。
4. **自定义类型**：提供自定义数据类型的初始化方法，支持多种数据类型的解码。
5. **视图扩展**：为视图提供了适配 iOS 14 的 `onChange` 修饰符、隐藏键盘、条件修饰符、样式设置等扩展功能。
6. **运算符重载**：对多种数据类型（如 `NSAttributedString`、`Dictionary`、`CGPoint` 等）进行了运算符重载，方便进行数学运算。
7. **其他工具**：包含版本判断、随机数生成、距离计算等实用工具函数。

## 安装

### CocoaPods
在 `Podfile` 中添加以下内容：pod 'YeeKit'然后运行 `pod install`。

### Swift Package Manager
在 Xcode 中，选择 `File` -> `Swift Packages` -> `Add Package Dependency`，输入 YeeKit 的仓库地址，然后按照提示完成安装。

## 使用示例

### 系统操作// 拨打电话
YEXSystem.openPhone("1234567890") { success in
    if success {
        print("电话拨打成功")
    } else {
        print("电话拨打失败")
    }
}

// 打开设置
YEXSystem.openSettings { success in
    if success {
        print("设置打开成功")
    } else {
        print("设置打开失败")
    }
}

// 检测相册权限并打开相册
let system = YEXSystem()
system.isOpenAlbumService { isOpen in
    if isOpen {
        system.openSystemPhoto { image in
            // 处理选择的图片
        }
    } else {
        system.openPermissionsSetting()
    }
}
### 数据处理// Data 转字典
let data = "{\"key\": \"value\"}".data(using: .utf8)!
let dictionary = data.toDictionary()
print(dictionary)

// 字典转 JSON 字符串
let dict: [String: Any] = ["key": "value"]
let jsonString = dict.toJSONString()
print(jsonString)
### 日期转换// 时间戳转日期
let timestamp = "1635235200"
let date = Date.timestampToFormatterDate(timestamp: timestamp)
print(date)

// 日期转时间戳
let timeString = "2020-10-26 16:52:41"
let formatter = "yyyy-MM-dd HH:mm:ss"
let timestampString = Date.formatterTimeStringToTimestamp(timesString: timeString, formatter: formatter)
print(timestampString)
### 视图扩展struct ContentView: View {
    @State private var text = ""

    var body: some View {
        VStack {
            TextField("Enter text", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChangeCompat(of: text) { newValue in
                    print("Text changed: \(newValue)")
                }
                .hideKeyboard()
                .styled(cornerRadius: 10, borderColor: .blue, borderWidth: 1, backgroundColor: .gray.opacity(0.2))
                .onTapToDismissKeyboard()
        }
    }
}
### 运算符重载// NSAttributedString 相加
let attributedString1 = NSAttributedString(string: "Hello ")
let attributedString2 = NSAttributedString(string: "World!")
let combinedString = attributedString1 + attributedString2
print(combinedString)

// CGPoint 相加
let point1 = CGPoint(x: 10, y: 20)
let point2 = CGPoint(x: 30, y: 40)
let newPoint = point1 + point2
print(newPoint)
### 其他工具// 版本判断
let nowVersion = "1.0.0"
let newVersion = "1.0.1"
let isNewVersion = YeeTool.compareVersion(nowVersion: nowVersion, newVersion: newVersion)
print(isNewVersion)

// 随机数生成
let randomNumber = Int.random(within: 0..<10)
print(randomNumber)
## 文档
每个功能的详细文档可以在代码注释中找到，你可以在代码文件中查看具体的实现和使用说明。

## 贡献
如果你发现了 bug 或者有新的功能建议，欢迎提交 issue 或者 pull request。

## 许可证
YeeKit 采用 [MIT 许可证](LICENSE)。

## 作者
- **Author**: ╰莪呮想好好宠Nǐつ
- **E-mail**: 1091676312@qq.com
- **GitHub**: [https://github.com/yijingKing](https://github.com/yijingKing)
    
