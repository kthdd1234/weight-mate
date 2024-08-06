import UIKit
import Flutter
import flutter_local_notifications
import home_widget

@UIApplicationMain
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

    // WorkmanagerPlugin.registerTask(withIdentifier: "com.kthdd.weightMate.backgroundTask")

    // UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))
    
    // WorkmanagerPlugin.setPluginRegistrantCallback { registry in
    //   GeneratedPluginRegistrant.register(with: registry)
    // }

      if #available(iOS 17, *) {
        HomeWidgetBackgroundWorker.setPluginRegistrantCallback { registry in
            GeneratedPluginRegistrant.register(with: registry)
          }
        }

        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}


