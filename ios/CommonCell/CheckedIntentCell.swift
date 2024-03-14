import AppIntents
import home_widget
import Foundation
import WidgetKit
import SwiftUI

struct CheckedIntentCell: View {
    let item: GoalModel
    let fontFamily: String
    let schema: String
    
    var body: some View {
        HStack {
//            Button (intent: CheckedIntent(planId: item.id, schema: schema, newValue: !item.isChecked)) {
//            }.buttonStyle(.plain).frame(alignment: .leading)
            IconBoxCell(systemName: item.isChecked ? "checkmark" : "", iconColor: iconColor(type: item.type), bgColor: bgColor(type: item.type))
            TextCell(text: item.name,
                     font: .footnote,
                     isBold: false,
                     isLineThrough: item.isChecked ? true : nil,
                     lineThroughColor: item.isChecked ? iconColor(type: item.type) : nil,
                     fontFamily: fontFamily)
        }
    }
}

@available(iOS 16, *)
public struct CheckedIntent: AppIntent  {
    static public var title: LocalizedStringResource = "Checked Plan"

    @Parameter(title: "Plan ID")
    var planId: String
    
    @Parameter(title: "Schema")
    var schema: String
    
    @Parameter(title: "NewValue")
    var newValue: Bool

    public init() {}

    public init(planId: String, schema: String, newValue: Bool) {
      self.planId = planId
      self.schema = schema
      self.newValue = newValue
    }

    public func perform() async throws -> some IntentResult {
      await HomeWidgetBackgroundWorker.run(
        url: URL(string: "\(schema)://planId?planId=\(planId)&newValue=\(newValue)"),
        appGroup: widgetGroupId
      )

      return .result()
    }
}

@available(iOS 16, *)
@available(iOSApplicationExtension, unavailable)
extension CheckedIntent: ForegroundContinuableIntent {}
