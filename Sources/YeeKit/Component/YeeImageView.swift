//
//  File.swift
//  YeeKit
//
//  Created by 祎 on 2025/7/14.
//

import Foundation

import SwiftUI
import Kingfisher


#Preview {
    YeeImageView(url: URL(string: "https://ad.zleniao.com/app/upload/2025-07-21/1753088578201.png"), placeholder: nil, failureImage: nil, size: CGSizeMake(.infinity, 600), cornerRadius: 20, compressMaxKB: 0)
}

public struct YeeImageView: View {
    private let url: URL?
    private let placeholder: Image?
    private let failureImage: UIImage?
    private let size: CGSize?
    private let cornerRadius: CGFloat
    private let compressMaxKB: Int?
    private let contentMode: SwiftUI.ContentMode?
    @State private var isShowingToast = false
    @State private var image: Image? = nil

    /// 初始化方法
    /// - Parameters:
    ///   - url: 图片地址
    ///   - placeholder: 加载中的占位图，默认是系统 ProgressView
    ///   - failureImage: 加载失败显示的图
    ///   - size: 固定尺寸，可选
    ///   - cornerRadius: 圆角设置，默认 0
    ///   - compressMaxKB: 压缩目标大小（单位 KB），默认 nil
    ///   - contentMode: 图片内容模式，默认 .fill
    public init(
        url: URL?,
        placeholder: Image? = nil,
        failureImage: UIImage? = nil,
        size: CGSize? = nil,
        cornerRadius: CGFloat = 0,
        compressMaxKB: Int? = nil,
        contentMode: SwiftUI.ContentMode? = nil
    ) {
        self.url = url
        self.placeholder = placeholder
        self.failureImage = failureImage
        self.size = size
        self.cornerRadius = cornerRadius
        self.compressMaxKB = compressMaxKB
        self.contentMode = contentMode
    }

    /// 链式设置压缩目标大小（单位 KB）
    public func compression(_ maxKB: Int) -> YeeImageView {
        YeeImageView(
            url: self.url,
            placeholder: self.placeholder,
            failureImage: self.failureImage,
            size: self.size,
            cornerRadius: self.cornerRadius,
            compressMaxKB: maxKB,
            contentMode: self.contentMode
        )
    }

    /// 链式设置图片 URL
    public func url(_ url: URL?) -> YeeImageView {
        YeeImageView(
            url: url,
            placeholder: self.placeholder,
            failureImage: self.failureImage,
            size: self.size,
            cornerRadius: self.cornerRadius,
            compressMaxKB: self.compressMaxKB,
            contentMode: self.contentMode
        )
    }

    /// 链式设置占位图
    public func placeholder(_ placeholder: Image) -> YeeImageView {
        YeeImageView(
            url: self.url,
            placeholder: placeholder,
            failureImage: self.failureImage,
            size: self.size,
            cornerRadius: self.cornerRadius,
            compressMaxKB: self.compressMaxKB,
            contentMode: self.contentMode
        )
    }

    /// 链式设置加载失败显示的图片
    public func failureImage(_ failureImage: UIImage?) -> YeeImageView {
        YeeImageView(
            url: self.url,
            placeholder: self.placeholder,
            failureImage: failureImage,
            size: self.size,
            cornerRadius: self.cornerRadius,
            compressMaxKB: self.compressMaxKB,
            contentMode: self.contentMode
        )
    }

    /// 链式设置图片尺寸
    public func size(_ size: CGSize?) -> YeeImageView {
        YeeImageView(
            url: self.url,
            placeholder: self.placeholder,
            failureImage: self.failureImage,
            size: size,
            cornerRadius: self.cornerRadius,
            compressMaxKB: self.compressMaxKB,
            contentMode: self.contentMode
        )
    }

    /// 链式设置圆角
    public func cornerRadius(_ cornerRadius: CGFloat) -> YeeImageView {
        YeeImageView(
            url: self.url,
            placeholder: self.placeholder,
            failureImage: self.failureImage,
            size: self.size,
            cornerRadius: cornerRadius,
            compressMaxKB: self.compressMaxKB,
            contentMode: self.contentMode
        )
    }
    
    /// 链式设置图片内容模式
    public func contentMode(_ contentMode: SwiftUI.ContentMode) -> YeeImageView {
        YeeImageView(
            url: self.url,
            placeholder: self.placeholder,
            failureImage: self.failureImage,
            size: self.size,
            cornerRadius: self.cornerRadius,
            compressMaxKB: self.compressMaxKB,
            contentMode: contentMode
        )
    }
    public var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledTo(contentMode)
            } else if let url = url {
                KFImage(source: Source.network(url))
                    .cacheMemoryOnly(false)
                    .placeholder {
                        placeholder?
                            .resizable()
                            .scaledTo(contentMode)
                    }
                    .onFailureImage(failureImage ?? UIImage())
                    .resizable()
                    .onSuccess { result in
                        if let compressMaxKB = compressMaxKB,
                           let data = result.image.jpegData(compressionQuality: 1.0),
                           let compressedUIImage = UIImage(data: data) {
                            self.image = Image.yeeCompressed(from: compressedUIImage, maxFileSizeKB: compressMaxKB)
                        } else {
                            self.image = Image(uiImage: result.image)
                        }
                    }
                    .scaledTo(contentMode)
            } else {
                placeholder?
                    .resizable()
                    .scaledTo(contentMode)
            }
            VStack {
                        Button("显示 Toast") {
                            isShowingToast = true
                        }
                    }
                    
        }
        .frame(width: size?.width, height: size?.height)
        .clipped()
        .cornerRadius(cornerRadius)
    }

}
