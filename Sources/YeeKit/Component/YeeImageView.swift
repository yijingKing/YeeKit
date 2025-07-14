//
//  File.swift
//  YeeKit
//
//  Created by 祎 on 2025/7/14.
//

import Foundation

import SwiftUI
import Kingfisher

public struct YeeImageView: View {
    private let url: URL?
    private let placeholder: Image
    private let failureImage: UIImage?
    private let size: CGSize?
    private let cornerRadius: CGFloat
    private let compressMaxKB: Int?
    
    @State private var image: Image? = nil

    /// 初始化方法
    /// - Parameters:
    ///   - url: 图片地址
    ///   - placeholder: 加载中的占位图，默认是系统 ProgressView
    ///   - failureImage: 加载失败显示的图
    ///   - size: 固定尺寸，可选
    ///   - cornerRadius: 圆角设置，默认 0
    ///   - compressMaxKB: 压缩目标大小（单位 KB），默认 nil
    public init(
        url: URL?,
        placeholder: Image = Image(systemName: "photo"),
        failureImage: UIImage? = UIImage(systemName: "xmark.octagon"),
        size: CGSize? = nil,
        cornerRadius: CGFloat = 0,
        compressMaxKB: Int? = nil
    ) {
        self.url = url
        self.placeholder = placeholder
        self.failureImage = failureImage
        self.size = size
        self.cornerRadius = cornerRadius
        self.compressMaxKB = compressMaxKB
    }

    /// 链式设置压缩目标大小（单位 KB）
    public func compression(_ maxKB: Int) -> YeeImageView {
        YeeImageView(
            url: self.url,
            placeholder: self.placeholder,
            failureImage: self.failureImage,
            size: self.size,
            cornerRadius: self.cornerRadius,
            compressMaxKB: maxKB
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
            compressMaxKB: self.compressMaxKB
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
            compressMaxKB: self.compressMaxKB
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
            compressMaxKB: self.compressMaxKB
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
            compressMaxKB: self.compressMaxKB
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
            compressMaxKB: self.compressMaxKB
        )
    }

    public var body: some View {
        if let url = url {
            KFImage(source: Source.network(url))
                .cacheMemoryOnly(false)
                .placeholder {
                    placeholder
                        .resizable()
                        .scaledToFit()
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
                .scaledToFill()
                .frame(width: size?.width, height: size?.height)
                .clipped()
                .cornerRadius(cornerRadius)
                .background(
                    VStack {
                        if let image = image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: size?.width, height: size?.height)
                                        .clipped()
                                }
                    }
                )
        } else {
            placeholder
                .resizable()
                .scaledToFit()
                .frame(width: size?.width, height: size?.height)
                .clipped()
                .cornerRadius(cornerRadius)
        }
    }
}

