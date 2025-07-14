/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/yijingKing
********************************************************************************/

import Foundation
import CoreLocation

public class LocationTool: NSObject {
    @MainActor public static let shared = LocationTool()
    
    private let locationManager = CLLocationManager()
    private var completion: ((CLLocationCoordinate2D?, Error?) -> Void)?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// 获取当前定位坐标
    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        self.completion = completion
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            completion(nil, NSError(domain: "LocationTool", code: 1, userInfo: [NSLocalizedDescriptionKey: "定位权限未开启"]))
        }
    }
}

public extension LocationTool {
    /// 计算当前位置与指定经纬度之间的距离，返回格式化字符串（单位：m 或 km）
    func formattedDistanceFromCurrentLocation(to coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        getCurrentLocation { current, error in
            guard let current = current else {
                completion(nil)
                return
            }
            let currentLocation = CLLocation(latitude: current.latitude, longitude: current.longitude)
            let targetLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let distance = currentLocation.distance(from: targetLocation)

            if distance < 1000 {
                completion(String(format: "%.0f m", distance))
            } else {
                completion(String(format: "%.2f km", distance / 1000.0))
            }
        }
    }
}

extension LocationTool: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("经纬度：\(location.coordinate.latitude), \(location.coordinate.longitude)")
            completion?(location.coordinate, nil)
            completion = nil
            manager.stopUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil, error)
        completion = nil
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        } else if status == .denied || status == .restricted {
            completion?(nil, NSError(domain: "LocationTool", code: 2, userInfo: [NSLocalizedDescriptionKey: "用户拒绝定位权限"]))
            completion = nil
        }
    }
}
