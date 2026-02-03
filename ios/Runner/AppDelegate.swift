import UIKit
import Firebase
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyDpnvIaxDVkU5Es1U26X4BkqhBszXGWvNI")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
