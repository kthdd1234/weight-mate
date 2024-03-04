import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct GoalWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HeaderCell(title: "식단", secondary: "3.02 (토)")
//          EmptyCell(svgName: "empty-goal", text: "목표 추가하기")
            VStack(alignment: .leading, spacing: 12) {
                
            }
        }
        .containerBackground(for: .widget) {
            BackgroundWidget()
        }
    }
        
}

struct GoalWidget: Widget {
    let kind: String = "GoalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GoalWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("식단 목표")
        .description("오늘 실천 할 목표를 확인할 수 있어요.")
    }
}

#Preview(as: .systemSmall) {
    GoalWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}
