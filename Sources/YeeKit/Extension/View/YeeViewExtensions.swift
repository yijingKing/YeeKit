/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/


import Foundation
import Combine
import SwiftUI
import ToastUI

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

public extension View {
    func toastText(_ message: String, isPresented: Binding<Bool>, dismissAfter: Double = 1.2) -> some View {
        self.toast(isPresented: isPresented, dismissAfter: dismissAfter) {
            Text(message)
                .font(.system(size: 16))
                .padding(30)
                .background(Color.black.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .toastDimmedBackground(false)
    }
    
    func toastLoading( isPresented: Binding<Bool>, dismissAfter: Double? = nil) -> some View {
        self.toast(isPresented: isPresented, dismissAfter: dismissAfter) {
            HStack(spacing: 10) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
            .padding(30)
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
        }
        .toastDimmedBackground(false)
    }
}

#Preview {
    struct ToastPreview: View {
        @State private var isShowingTextToast = false
        @State private var isShowingLoadingToast = false

        var body: some View {
            VStack(spacing: 20) {
                Button("显示文本 Toast") {
                    isShowingTextToast = true
                }
                Button("显示加载中 Toast") {
                    isShowingLoadingToast = true
                }
                .padding(.top,100)
            }
            .toastText("这是一个提示", isPresented: $isShowingTextToast)
            .toastLoading(isPresented: $isShowingLoadingToast, dismissAfter: 99999)
            .padding()
        }
    }
    
    return ToastPreview()
}
