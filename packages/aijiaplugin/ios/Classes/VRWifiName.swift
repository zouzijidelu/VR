//
//  VRWifiName.swift
//  VRCapture_iOS
//
//  Created by wzb on 2023/6/1.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import CoreLocation

class VRWifiName:NSObject, CLLocationManagerDelegate {
    static let shared = VRWifiName()
    var locationManager:CLLocationManager?//定义一个地理管理器
    func openLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 1000.0
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    //获取wifi名称
    func getUsedSSID() -> String {
        var currentSSID = ""
        if let interfaces:CFArray = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as! Dictionary<String, Any>
                    currentSSID = interfaceData["SSID"] as! String
                }
                else{
                    print("data nil")
                }
            }
        }
        print(currentSSID)
        return currentSSID
    }
}
