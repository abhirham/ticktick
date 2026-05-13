import Flutter
import UIKit
import UserNotifications
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "flowtask/widget_bridge",
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { call, result in
        guard call.method == "publishTodaySnapshot" else {
          result(FlutterMethodNotImplemented)
          return
        }
        guard let payload = call.arguments as? [String: Any],
              let data = try? JSONSerialization.data(withJSONObject: payload),
              let json = String(data: data, encoding: .utf8) else {
          result(FlutterError(code: "invalid_payload", message: "Widget payload was invalid", details: nil))
          return
        }
        let defaults = UserDefaults(suiteName: "group.com.flowtask.flowtask") ?? UserDefaults.standard
        defaults.set(json, forKey: "today_snapshot")
        defaults.synchronize()
        if #available(iOS 14.0, *) {
          WidgetCenter.shared.reloadAllTimelines()
        }
        result(nil)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
