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

struct todoWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var wFamily

    var body: some View {
        VStack(alignment: .leading) {
            if isWidgetSizeSmallMedium(family: wFamily) {
                Spacer()
            }
            HeaderCell(title: "오늘의 식단 기록", secondary: isWidgetSizeMediumLarge(family: wFamily) ? "3.15 (화)" : "", fontFamily: "")
//          EmptyCell(svgName: "empty-record", text: "식단 기록하기")
            VStack(alignment: .leading, spacing: 15) {
                IconTextCell(
                    text: "밥 한공기, 양념 갈비, 마늘, 김치, 콩나물 국",
                    systemName: systemName(type: "diet", key: "morning"),
                    iconColor: iconColor(type: "diet"),
                    bgColor: bgColor(type: "diet"),
                    fontFamily: ""
                )
                IconTextCell(
                    text: "짬뽕 한 그릇, 단무지, 무말랭이",
                    systemName: systemName(type: "diet", key: "lunch"),
                    iconColor: iconColor(type: "diet"),
                    bgColor: bgColor(type: "diet"),
                    fontFamily: ""
                )
                IconTextCell(
                    text: "밥 한공기, 양념 갈비, 마늘, 김치, 콩나물 국",
                    systemName: systemName(type: "diet", key: "dinner"),
                    iconColor: iconColor(type: "diet"),
                    bgColor: bgColor(type: "diet"),
                    fontFamily: ""
                )
             
//                if isWidgetSizeSmallMedium(family: wFamily) {
//                    SecondaryCell(text: "+ 이외 2개의 기록", font: .caption2).padding(.leading, 3)
//                }
            }
            Spacer()
        }
        .containerBackground(for: .widget) {
            BackgroundWidget()
        }
    }
}

struct todoWidget: Widget {
    let kind: String = "todoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            todoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("식단 기록")
        .description("오늘의 식단을 빠르게 기록 할 수 있어요.")
    }
}

#Preview(as: .systemSmall) {
    todoWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}
