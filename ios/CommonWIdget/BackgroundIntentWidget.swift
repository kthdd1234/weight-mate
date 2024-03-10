//import WidgetKit
//import SwiftUI
//import AppIntents
//import Foundation
//import home_widget
//import Flutter
//
//@available(iOS 16, *)
//public struct BackgroundIntentWidget: AppIntent  {
//    static public var title: LocalizedStringResource = "Checked Plan"
//    
//    @Parameter(title: "Plan ID")
//    var planId: String
//
//    public init() {}
//
//    public init(planId: String) {
//      self.planId = planId
//    }
//     
//    public func perform() async throws -> some IntentResult {
//      await HomeWidgetBackgroundWorker.run(
//        url: URL(string: "weightMateWidget://planChecked?planChecked=\(planId)"),
//        appGroup: widgetGroupId
//      )
//
//      return .result()
//    }
//}
//
//@available(iOS 16, *)
//@available(iOSApplicationExtension, unavailable)
//extension BackgroundIntentWidget: ForegroundContinuableIntent {}
