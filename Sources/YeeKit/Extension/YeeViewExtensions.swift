/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/


import Foundation
import Combine
import SwiftUI

public extension View {
    /// 适配iOS 14的onChange修饰符
    @ViewBuilder
    func onChangeCompat<V: Equatable>(of value: V, perform action: @escaping (V) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: action)
        } else {
            self.onReceive(Just(value)) { newValue in
                action(newValue)
            }
        }
    }
    
    /// 隐藏键盘
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// 条件修饰符
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    /// 设置圆角、边框、背景颜色
    func styled(
        cornerRadius: CGFloat = 8,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        backgroundColor: Color = .clear
    ) -> some View {
        self
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth))
    }

    /// 在点击空白区域时收起键盘
    func onTapToDismissKeyboard() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    /// 设置视图可见性
    @ViewBuilder
    func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}


public extension View {
    func scaledTo(_ contentMode: SwiftUI.ContentMode?) -> some View {
        guard let contentMode = contentMode else {
            return AnyView(self)
        }
        switch contentMode {
        case .fill:
            return AnyView(self.scaledToFill())
        case .fit:
            return AnyView(self.scaledToFit())
        @unknown default:
            return AnyView(self.scaledToFill())
        }
    }
}
