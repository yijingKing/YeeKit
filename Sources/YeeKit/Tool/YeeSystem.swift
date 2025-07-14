/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/


import Foundation
import UIKit
import Photos

/// 系统方法
open class YeeSystem: NSObject {
    ///是否编辑,默认false
    public var allowsEditing: Bool?
    
    public var photoBlock: ((UIImage)->())?
    
    //MARK: --- 拨打电话
    ///拨打电话
    @MainActor public class func openPhone(_ phone: String,
                            _ completion: ((Bool) -> Void)? = nil) {
        if let url = URL(string: "tel://" + phone),UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        }
    }
    
    //MARK: --- 打开设置
    ///打开设置
    @MainActor public class func openSettings(_ completion: ((Bool) -> Void)? = nil) {
        if let openURL = URL(string: UIApplication.openSettingsURLString) {
            if  UIApplication.shared.canOpenURL(openURL) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(openURL, options: [:],completionHandler: {(success) in})
                } else {
                    UIApplication.shared.openURL(openURL)
                }
            }
        }
    }
    // MARK: - 跳转系统设置界面
    ///跳转系统设置界面
    @MainActor public func openPermissionsSetting() {
        let alertController = UIAlertController(title: "访问受限",
                                                message: "点击“设置”，允许访问权限",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
        let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
            (action) -> Void in
            if let openURL = URL(string: UIApplication.openSettingsURLString) {
                if  UIApplication.shared.canOpenURL(openURL) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(openURL, options: [:],completionHandler: {(success) in})
                    } else {
                        UIApplication.shared.openURL(openURL)
                    }
                }
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    // MARK: - 检测是否开启相册
    /// 检测是否开启相册
    public func isOpenAlbumService(_ action :@escaping ((Bool)->())) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if #available(iOS 14, *) {
                    if status == .limited {
                        action(true)
                    }
                }
                
                if status == .authorized {
                    action(true)
                } else if status == .denied || status == .restricted {
                    action(false)
                } else {
                    action(false)
                }
            })
        } else if authStatus == PHAuthorizationStatus.restricted || authStatus == PHAuthorizationStatus.denied {
            action(false)
        } else {
            action(true)
        }
    }
    /// 打开相机相册
    @MainActor public func openAlbumService(_ completion: ((UIImage)->())? = nil) {
        let alertController = UIAlertController(title: "",
                                                message: "",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"相机", style: .default) { action in
            self.openSystemPhoto(completion)
        }
        let settingsAction = UIAlertAction(title:"相册", style: .default, handler: {
            (action) -> Void in
            self.openSystemCamera(completion)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    ///打开相册
    @MainActor public func openSystemPhoto(_ completion: ((UIImage)->())? = nil) -> Void {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        if let isEdi = self.allowsEditing {
            imagePickerController.allowsEditing = isEdi
        }
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePickerController, animated: true, completion: nil)
        self.photoBlock = completion
    }
    ///打开相机
    @MainActor public func openSystemCamera(_ completion: ((UIImage)->())? = nil) -> Void {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.cameraCaptureMode = .photo
        imagePickerController.mediaTypes = ["public.image"]
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePickerController, animated: true, completion: nil)
        self.photoBlock = completion
    }
}

//MARK: ------- 打开相机相册
extension YeeSystem: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    //MARK: -------UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        ///原图
        guard let orignalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        ///编辑后的图片
        let editedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(orignalImg, self, nil, nil)
        }
        picker.dismiss(animated: true) {
            if let block = self.photoBlock {
                if let img = editedImg {
                    block(img)
                } else {
                    block(orignalImg)
                }
            }
        }
    }
}
