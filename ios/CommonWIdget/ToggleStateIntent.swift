//
//  ToggleStateIntent.swift
//  Runner
//
//  Created by 김동현 on 3/4/24.
//

//import SwiftUI
//import AppIntents
//import home_widget
//
//@available(iOS 17, *)
//struct ToggleStateIntent: AppIntent  {
//    static public var title: LocalizedStringResource = "Increment Counter"
//    
//    @Parameter(title: "Method")
//    var method: String
//
//    public init() {
//      method = "increment"
//    }
//
//    public init(method: String) {
//      self.method = method
//    }
//    
//    public func perform() async throws -> some IntentResult {
//      await HomeWidgetBackgroundWorker.run(
//        url: URL(string: "homeWidgetCounter://\(method)"),
//        appGroup: "YOUR_GROUP_ID")
//
//      return .result()
//    }
//}

