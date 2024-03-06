import AppIntents
import Flutter
import Foundation
import home_widget
import WidgetKit
import SwiftUI

@available(iOS 17, *)
struct BackgroundIntentWidget: AppIntent  {
    static public var title: LocalizedStringResource = "Checked Plan"
    
    @Parameter(title: "Plan ID")
    var planId: String

    public init() {}

    public init(planId: String) {
      self.planId = planId
    }
     
    public func perform() async throws -> some IntentResult {
      await HomeWidgetBackgroundWorker.run(
        url: URL(string: "weightMateWidget://\(planId)"),
        appGroup: widgetGroupId
      )

      return .result()
    }
}

