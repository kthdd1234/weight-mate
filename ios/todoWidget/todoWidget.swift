//
//  todoWidget.swift
//  todoWidget
//
//  Created by 김동현 on 3/2/24.
//

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

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderCell(title: "식단 기록", secondary: "3.02 (토)")
            VStack(alignment: .leading, spacing: 15) {
                IconTextCell(name: "밥 한공기, 양념 갈비, 마늘, 김치, 콩나물 국")
                IconTextCell(name: "짬뽕 한 그릇, 단무지, 무말랭이")
                IconTextCell(name: "밥 한공기, 양념 갈비, 마늘, 김치, 콩나물 국")
            }.padding(.top, 5)
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    todoWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}
