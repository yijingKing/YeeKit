//
//  File.swift
//  YeeKit
//
//  Created by 祎 on 2025/7/14.
//

import Foundation
import SwiftUI

public extension UIImage {
    /// 快速压缩图片，自动推断格式，尺寸与质量基于 Luban 算法
    /// - Parameters:
    ///   - maxFileSizeKB: 压缩目标最大大小，单位为 KB，默认 300KB
    /// - Returns: 压缩后的 Data 数据
    func yeeSmartCompress(maxFileSizeKB: Int = 300) -> Data? {
        let resized = YeeCompress.resizeImage(self)
        let formatData = self.jpegData(compressionQuality: 1.0)
        let qualitySteps: [CGFloat] = [0.8, 0.65, 0.5, 0.35, 0.2]

        for quality in qualitySteps {
            if let compressed = YeeCompress.compressImage(resized, quality: quality, formatData: formatData),
               compressed.count < maxFileSizeKB * 1024 {
                return compressed
            }
        }
        return YeeCompress.compressImage(resized, quality: 0.15, formatData: formatData)
    }

    /// 返回压缩后的 UIImage，便于在 SwiftUI 中使用
    /// - Parameters:
    ///   - maxFileSizeKB: 压缩目标最大大小，单位为 KB，默认 300KB
    /// - Returns: 新的 UIImage 实例
    func yeeCompressedImage(maxFileSizeKB: Int = 300) -> UIImage? {
        guard let data = yeeSmartCompress(maxFileSizeKB: maxFileSizeKB), let image = UIImage(data: data) else { return nil }
        return image
    }
}

public extension Image {
    /// 从 UIImage 创建 SwiftUI 的 Image（压缩版）
    /// - Parameter uiImage: 源图
    ///   - maxFileSizeKB: 压缩目标最大大小，单位为 KB，默认 300KB
    /// - Returns: Image
    static func yeeCompressed(from uiImage: UIImage,maxFileSizeKB: Int = 300) -> Image {
        if let compressed = uiImage.yeeCompressedImage(maxFileSizeKB: maxFileSizeKB) {
            return Image(uiImage: compressed)
        }
        return Image(uiImage: uiImage)
    }
}
