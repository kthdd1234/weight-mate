import UIKit
import Flutter
import flutter_local_notifications
import home_widget
import FBAudienceNetwork

@main
@objc class AppDelegate: FlutterAppDelegate {
  let taskId = "com.kthdd.weightMate.backgroundTask"
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    FBAdSettings.setAdvertiserTrackingEnabled(true)

    if #available(iOS 17, *) {
        HomeWidgetBackgroundWorker.setPluginRegistrantCallback { registry in
            GeneratedPluginRegistrant.register(with: registry)
          }
    }

     GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}


