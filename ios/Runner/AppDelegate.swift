import UIKit
import Flutter
import flutter_local_notifications
import home_widget
import workmanager
import BackgroundTasks

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let taskId = "com.kthdd.weightMate.backgroundTask"
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      // BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil) { task in
      //     // Handle the task when its run
      //     guard let task = task as? BGProcessingTask else { return }
      //     self.handleTask(task: task)
      // }
      
      // let count = UserDefaults.standard.integer(forKey: "task_run_count")
      // print("Task run \(count) times!")
    // ------------------------------------------------------------------- //

    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    WorkmanagerPlugin.registerTask(withIdentifier: "com.kthdd.weightMate.backgroundTask")

    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))
    
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 17, *) {
      HomeWidgetBackgroundWorker.setPluginRegistrantCallback { registry in
          GeneratedPluginRegistrant.register(with: registry)
        }
     }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func handleTask(task: BGProcessingTask) {
        let count = UserDefaults.standard.integer(forKey: "task_run_count")
        UserDefaults.standard.set(count + 1, forKey: "task_run_count")
        
        task.expirationHandler = {
            // Cancel network call
        }
        
        task.setTaskCompleted(success: true)
    }
}


