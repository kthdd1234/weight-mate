// import UIKit
// import BackgroundTasks

// class ViewController: UIViewController {
//     let taskId = "com.kthdd.weightMate.backgroundTask"
    
//     override func viewDidLoad() {
//         super.viewDidLoad()
        
//         DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
//             self.schedule()
//         })
        
//         schedule()
//     }
    
//     private func schedule() {
//         // Manual Test: e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.kthdd.weightMate.backgroundTask"]
//         BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskId)
//         BGTaskScheduler.shared.getPendingTaskRequests { requests in
//             print("\(requests.count) BGTasks pending...")
            
//             guard requests.isEmpty else {
//                 return
//             }
            
//             // Submit a task to be scheduled
//             do {
//                 let newTask = BGProcessingTaskRequest(identifier: self.taskId)
//                 newTask.earliestBeginDate = Date().addingTimeInterval(86400 * 3)
//                 try BGTaskScheduler.shared.submit(newTask)
//                 print("Task scheduled")
//             } catch  {
//                 // ignore
//                 print("Failed to schedule; \(error)")
//             }
//         }
//     }
// }
