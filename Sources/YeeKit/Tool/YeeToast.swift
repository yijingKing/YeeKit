//
//  YeeToast.swift
//

import Foundation
import SwiftUI

public enum YeeHUDType {
    case loading
    case success
    case error
    case textOnly
}

public struct YeeHUDModel {
    public var type: YeeHUDType
    public var message: String?
    public var duration: Double? // nil 表示不会自动隐藏
    public var allowUserInteraction: Bool = false

    public init(type: YeeHUDType,
                message: String? = nil,
                duration: Double? = nil,
                allowUserInteraction: Bool = false) {
        self.type = type
        self.message = message
        self.duration = duration
        self.allowUserInteraction = allowUserInteraction
    }
}

@MainActor
public class YeeHUDState: ObservableObject {
    @Published public var isPresented: Bool = false
    @Published public var model: YeeHUDModel = .init(type: .loading)

    /// 默认消失时间，默认 1.2 秒
    public var defaultDuration: Double = 1.2

    public static let shared = YeeHUDState()

    private var isHUDVisible = false

    /// 消失时回调闭包
    public var onDismiss: (() -> Void)? = nil

    public init() {}

    /// 显示 HUD，保证主线程调用，支持消失回调，默认使用 defaultDuration
    public func show(
        type: YeeHUDType,
        message: String? = nil,
        duration: Double? = nil,
        allowUserInteraction: Bool = false,
        onDismiss: (() -> Void)? = nil
    ) {
        Task { @MainActor in
            guard !self.isHUDVisible else { return }
            self.isHUDVisible = true
            self.onDismiss = onDismiss

            let finalDuration = duration ?? defaultDuration

            self.model = YeeHUDModel(type: type, message: message, duration: finalDuration, allowUserInteraction: allowUserInteraction)
            self.isPresented = true

            DispatchQueue.main.asyncAfter(deadline: .now() + finalDuration) { [weak self] in
                Task { @MainActor in
                    self?.hide()
                }
            }
        }
    }

    /// 隐藏 HUD，保证主线程调用，执行消失回调
    public func hide() {
        Task { @MainActor in
            guard self.isHUDVisible else { return }
            self.isHUDVisible = false
            self.isPresented = false

            self.onDismiss?()
            self.onDismiss = nil
        }
    }
}

public struct YeeHUDView: View {
    let model: YeeHUDModel

    public var body: some View {
        ZStack {
            if !model.allowUserInteraction {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            }

            VStack(spacing: 12) {
                iconView()
                if let message = model.message {
                    Text(message)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                }
            }
            .padding(20)
            .background(Color.black.opacity(0.85))
            .cornerRadius(12)
        }
    }

    @ViewBuilder
    private func iconView() -> some View {
        switch model.type {
        case .loading:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        case .success:
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 36))
        case .error:
            Image(systemName: "xmark.octagon.fill")
                .foregroundColor(.red)
                .font(.system(size: 36))
        case .textOnly:
            EmptyView()
        }
    }
}

public struct YeeHUDModifier: ViewModifier {
    @ObservedObject var state: YeeHUDState

    public func body(content: Content) -> some View {
        ZStack {
            content
            if state.isPresented {
                YeeHUDView(model: state.model)
                    .transition(.opacity)
            }
        }
    }
}

public extension View {
    /// 绑定 HUD 状态对象。shared 为 true 时绑定全局单例，否则使用传入的 state（默认全局单例）。
    func yeeHUD(shared: Bool = false, state: YeeHUDState = YeeHUDState.shared, duration: Double? = nil) -> some View {
        if let duration = duration {
            state.defaultDuration = duration
        }
        return self.modifier(YeeHUDModifier(state: shared ? YeeHUDState.shared : state))
    }
}

// MARK: - YeeHUDState 快捷方法扩展
public extension YeeHUDState {
    func showLoading(_ message: String? = nil,
                     allowUserInteraction: Bool = false,
                     duration: Double? = nil,
                     onDismiss: (() -> Void)? = nil) {
        show(type: .loading,
             message: message,
             duration: duration,
             allowUserInteraction: allowUserInteraction,
             onDismiss: onDismiss)
    }

    func showSuccess(_ message: String?,
                     duration: Double? = nil,
                     onDismiss: (() -> Void)? = nil) {
        show(type: .success,
             message: message,
             duration: duration,
             onDismiss: onDismiss)
    }

    func showError(_ message: String?,
                   duration: Double? = nil,
                   onDismiss: (() -> Void)? = nil) {
        show(type: .error,
             message: message,
             duration: duration,
             onDismiss: onDismiss)
    }

    func showText(_ message: String?,
                  duration: Double? = nil,
                  onDismiss: (() -> Void)? = nil) {
        show(type: .textOnly,
             message: message,
             duration: duration,
             onDismiss: onDismiss)
    }
}

// MARK: - YeeHUD 静态调用类
@MainActor
public enum YeeToast {
    public static func showLoading(_ message: String? = nil,
                                   allowUserInteraction: Bool = false,
                                   duration: Double? = nil,
                                   onDismiss: (() -> Void)? = nil) {
        YeeHUDState.shared.hide()
        YeeHUDState.shared.showLoading(message,
                                      allowUserInteraction: allowUserInteraction,
                                      duration: duration,
                                      onDismiss: onDismiss)
    }

    public static func showSuccess(_ message: String?,
                                   duration: Double? = nil,
                                   onDismiss: (() -> Void)? = nil) {
        YeeHUDState.shared.hide()
        YeeHUDState.shared.showSuccess(message,
                                      duration: duration,
                                      onDismiss: onDismiss)
    }

    public static func showError(_ message: String?,
                                 duration: Double? = nil,
                                 onDismiss: (() -> Void)? = nil) {
        YeeHUDState.shared.hide()
        YeeHUDState.shared.showError(message,
                                    duration: duration,
                                    onDismiss: onDismiss)
    }

    public static func showText(_ message: String?,
                                duration: Double? = nil,
                                onDismiss: (() -> Void)? = nil) {
        YeeHUDState.shared.hide()
        YeeHUDState.shared.showText(message,
                                   duration: duration,
                                   onDismiss: onDismiss)
    }

    public static func hide() {
        YeeHUDState.shared.hide()
    }
}
