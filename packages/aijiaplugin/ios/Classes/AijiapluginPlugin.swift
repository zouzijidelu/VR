import Flutter
import UIKit

public class AijiapluginPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "aijiaplugin", binaryMessenger: registrar.messenger())
    let instance = AijiapluginPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "getWifiName" {
    let wifiName = VRWifiName.shared.getUsedSSID()
    result(wifiName)
    }
  }
}
