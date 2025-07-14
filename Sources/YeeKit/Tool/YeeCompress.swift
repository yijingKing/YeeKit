/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/

import Foundation
import CoreImage
import UniformTypeIdentifiers

public struct YeeCompress {
    private static func ensureEven(_ size: Int) -> Int {
        return size % 2 == 1 ? size + 1 : size
    }
    
    /// Calculates the compression ratio using the Luban algorithm.
    /// - Parameters:
    ///   - width: The width of the image.
    ///   - height: The height of the image.
    /// - Returns: The computed compression ratio.
    public static func calculateLubanRatio(width: Int, height: Int) -> Int {
        let longSide = max(ensureEven(width), ensureEven(height))
        let shortSide = min(ensureEven(width), ensureEven(height))
        let aspectRatio = Double(shortSide) / Double(longSide)

        switch aspectRatio {
        case 0.5625...1 where longSide < 1664:
            return 1
        case 0.5625...1 where longSide < 4990:
            return 2
        case 0.5625...1 where longSide < 10240:
            return 4
        case 0.5625...1:
            return max(longSide / 1280, 1)
        case 0.5..<0.5625:
            return longSide > 1280 ? max(longSide / 1280, 1) : 1
        default:
            return Int(ceil(Double(longSide) / 1280.0))
        }
    }
}

#if os(iOS)
import UIKit

extension YeeCompress {
    
    /// Resize Image By luban Algorithm
    /// - Parameter image: The image to be compressed
    /// - Returns: The resized `UIImage` if the operation succeeds, or the original image if resizing fails.
    public static func resizeImage(_ image: UIImage) -> UIImage {
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        
        let resizeRatio = calculateLubanRatio(width: width, height: height)
        let processor = YeeImageProcessor(image: image)
        
        return processor.resize(by: resizeRatio) ?? image
    }
    
    /// Compress the image to the specified format data
    /// It is strongly recommended to provide the data when the image source is HEIC; otherwise, the compression results will be poor.
    /// - Parameters:
    ///   - image: The image to be compressed
    ///   - quality: Compression quality (0.0 - 1.0), default is 0.6
    ///   - formatData: Data used to determine the image format, defaults to .jpeg if nil
    /// - Returns: Compressed image data, or nil if conversion fails
    public static func compressImage(
        _ image: UIImage,
        quality: CGFloat = 0.6,
        formatData: Data? = nil
    ) -> Data? {
        let processor = YeeImageProcessor(image: image)
        let format = YeeImageFormat.init(data: formatData ?? Data())
        return processor.compress(format: format, quality: quality)
    }
}
public enum YeeImageFormat {
    case jpeg
    case png
    case heif
    case unknown
    
    init(data: Data) {
        guard
            let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
            let uti = CGImageSourceGetType(imageSource),
            let type = UTType(uti as String)
        else {
            self = .unknown
            return
        }
        
        if type.conforms(to: .jpeg) {
            self = .jpeg
        } else if type.conforms(to: .png) {
            self = .png
        } else if type.conforms(to: .heif) || type.conforms(to: .heic) {
            self = .heif
        } else {
            self = .unknown
        }
    }
}

public final class YeeImageProcessor {
    private var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    /// Compresses the image based on its format.
    /// - Parameters:
    ///   - format: The image format (`WIImageFormat`).
    ///   - quality: Compression quality (`0.0 - 1.0`).
    /// - Returns: Compressed `Data?`, or `nil` if compression fails.
    public func compress(format: YeeImageFormat, quality: CGFloat) -> Data? {
        switch format {
        case .jpeg:
            return image.jpegData(compressionQuality: quality)
        case .heif:
            return heicData(quality: quality)
        case .png:
            return image.pngData()
        case .unknown:
            return image.jpegData(compressionQuality: quality)
        }
    }
    
    /// Resizes the image to a specific target size.
    /// - Parameter targetSize: The desired size (`CGSize`), including width and height.
    /// - Returns: A new resized `UIImage`, or `nil` if resizing fails.
    public func resize(to targetSize: CGSize) -> UIImage? {
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.scale = 1.0
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: rendererFormat)
        
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    /// Resizes the image by a given scale ratio.
    /// - Parameter ratio: The scale ratio (`Int`) by which to resize the image.
    /// - Returns: A new resized `UIImage`, or `nil` if resizing fails.
    public func resize(by ratio: Int) -> UIImage? {
        let targetWidth = CGFloat(max(Int(image.size.width) / ratio, 1))
        let targetHeight = CGFloat(max(Int(image.size.height) / ratio, 1))
        
        return resize(to: CGSize(width: targetWidth, height: targetHeight))
    }
    
    /// Converts the image to HEIC format.
    /// - Parameter quality: Compression quality (`0.0 - 1.0`).
    /// - Returns: HEIC formatted `Data?`, or `nil` if conversion fails.
    func heicData(quality: CGFloat) -> Data? {
        guard let cgImage = image.cgImage else { return nil }

        let mutableData = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(mutableData, UTType.heic.identifier as CFString, 1, nil) else {
            return nil
        }

        let options: [CFString: Any] = [
            kCGImageDestinationLossyCompressionQuality: quality
        ]
        CGImageDestinationAddImage(destination, cgImage, options as CFDictionary)

        guard CGImageDestinationFinalize(destination) else { return nil }

        return mutableData as Data
    }
}


#endif
