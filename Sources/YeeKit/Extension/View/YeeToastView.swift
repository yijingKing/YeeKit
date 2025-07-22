/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/


import Foundation
import Combine
import SwiftUI


// Toast 全局配置结构体及环境键
public struct YeeToastConfig : Sendable{
    var backgroundColor: Color = Color.black.opacity(0.9)
    var foregroundColor: Color = .white
    var maskColor: Color = Color.black.opacity(0)
    var duration: Double = 1.5
    var loadingDuration: Double = 99 // 新增
    // 全局默认配置
    public static let `default` = YeeToastConfig()
}

private struct ToastEnvironmentKey: EnvironmentKey {
    static let defaultValue: YeeToastConfig = YeeToastConfig.default
}

public extension EnvironmentValues {
    var toastConfig: YeeToastConfig {
        get { self[ToastEnvironmentKey.self] }
        set { self[ToastEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func toastConfig(_ config: YeeToastConfig) -> some View {
        environment(\.toastConfig, config)
    }
}
public extension View {
    func toast(_ message: String, isPresented: Binding<Bool>, dismissAfter: Double? = nil) -> some View {
        self.overlay(
            ToastTextView(message: message, isPresented: isPresented, dismissAfter: dismissAfter)
        )
    }
    
    func toastLoading(isPresented: Binding<Bool>, dismissAfter: Double? = nil) -> some View {
        self.overlay(
            ToastLoadingView(isPresented: isPresented, dismissAfter: dismissAfter)
        )
    }
}



private struct ToastLoadingView: View {
    @Binding var isPresented: Bool
    var dismissAfter: Double?
    @Environment(\.toastConfig) var config
    
    var body: some View {
        ZStack {
            if isPresented {
                config.maskColor
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {}
                HStack(spacing: 10) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: config.foregroundColor))
                        .scaleEffect(2)
                }
                .padding(50)
                .background(config.backgroundColor)
                .cornerRadius(10)
                .transition(.opacity)
                .onAppear {
                    let duration = dismissAfter ?? config.loadingDuration
                    if dismissAfter != nil || dismissAfter == nil {
                        // 仅当 dismissAfter 有值或使用默认配置时自动消失
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                isPresented = false
                            }
                        }
                    }
                }
            }
        }
    }
}
private struct ToastTextView: View {
    let message: String
    @Binding var isPresented: Bool
    var dismissAfter: Double?
    @Environment(\.toastConfig) var config
    
    var body: some View {
        ZStack {
            if isPresented {
                config.maskColor
                    .edgesIgnoringSafeArea(.all)
                    .contentShape(Rectangle())
                    .onTapGesture {}
                Text(message)
                    .font(.system(size: 18))
                    .padding(30)
                    .background(config.backgroundColor)
                    .foregroundColor(config.foregroundColor)
                    .cornerRadius(8)
                    .transition(.opacity)
                    .onAppear {
                        let duration = dismissAfter ?? config.duration
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                isPresented = false
                            }
                        }
                    }
            }
        }
    }
}
#Preview {
    struct ToastPreview: View {
        @State private var isShowingTextToast = false
        @State private var isShowingLoadingToast = false

        var body: some View {
            VStack(spacing: 20) {
                Button("显示文本 Toast") {
                    YeeToastManager.show(text: "这是全局 Toast")
                }
                Button("显示加载中 Toast") {
                    YeeToastManager.showLoading()
                }
                .padding(.top,100)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .yeeToastSupport()
            .environmentObject(YeeToastManager.shared)
        }
    }
    return ToastPreview()
}


public class YeeToastManager: ObservableObject {
     @MainActor static let shared = YeeToastManager()
    
    @Published var text: String?
    @Published var isLoading = false

    private init() {}
    
    @MainActor
    public static func show(text: String, duration: Double? = nil) {
        shared.text = text
        hideLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + (duration ?? YeeToastConfig.default.duration)) {
            shared.text = nil
        }
    }

    /// 显示加载中
    @MainActor
    public static func showLoading() {
        shared.text = nil
        shared.isLoading = true
    }

    @MainActor
    public static func hideLoading() {
        shared.text = nil
        shared.isLoading = false
    }
}

private struct GlobalToastTextView: View {
    @EnvironmentObject var toast: YeeToastManager
    @Environment(\.toastConfig) var config
    
    var body: some View {
        Group {
            if let text = toast.text {
                ZStack {
                    config.maskColor
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture {}
                    
                    Text(text)
                        .font(.system(size: 18))
                        .padding(30)
                        .background(config.backgroundColor)
                        .foregroundColor(config.foregroundColor)
                        .cornerRadius(8)
                        .transition(.opacity)
                }
            }
        }
    }
}

private struct GlobalToastLoadingView: View {
    @EnvironmentObject var toast: YeeToastManager
    @Environment(\.toastConfig) var config

    var body: some View {
        Group {
            if toast.isLoading {
                ZStack {
                    config.maskColor
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture {}

                    HStack(spacing: 10) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: config.foregroundColor))
                            .scaleEffect(2)
                    }
                    .padding(50)
                    .background(config.backgroundColor)
                    .cornerRadius(10)
                    .transition(.opacity)
                }
            }
        }
    }
}

public extension View {
    func yeeToastSupport() -> some View {
        self
            .overlay(GlobalToastTextView().environmentObject(YeeToastManager.shared))
            .overlay(GlobalToastLoadingView().environmentObject(YeeToastManager.shared))
    }
}
