import UIKit
import Flutter
import GoogleMaps
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // In AppDelegate.application method
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))
    WorkmanagerPlugin.registerTask(withIdentifier: "task-identifier")
    GMSServices.provideAPIKey("AIzaSyCF7hSAusM2Jak6H62GVVKxr-QP_Z3rJ_g")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
