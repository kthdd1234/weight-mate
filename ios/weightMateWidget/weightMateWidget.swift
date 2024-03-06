import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), weight: "Placeholder weight")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        let entry = SimpleEntry(date: Date(), weight: data?.string(forKey: "weight") ?? "-")
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let weight: String
}

struct weightMateWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var wFamily

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            HeaderCell(title: "오늘의 체중", secondary: isWidgetSizeMediumLarge(family: wFamily) ? "3.15 (화)" : "")
//            EmptyCell(svgName: "empty-weight", text: "체중 기록하기")
            VStack(alignment: .leading, spacing: 15) {
                SvgTextCell(svgName: "weight", title: "체중", value: entry.weight)
                SvgTextCell(svgName: "bmi", title: "BMI", value: "24.1")
                SvgTextCell(svgName: "flag", title: "목표체중", value: "4.3kg")
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        }
        .containerBackground(for: .widget) {
            BackgroundWidget()
        }
    }
}

struct weightMateWidget: Widget {
    let kind: String = "weightMateWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
                weightMateWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("체중 기록")
        .description("오늘의 체중을 빠르게 기록 할 수 있어요.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct WeightMateWidget_Previews: PreviewProvider {
    static var previews: some View {
        weightMateWidgetEntryView(entry: SimpleEntry(date: Date(), weight: "Example Weight"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

#Preview(as: .systemSmall) {
    weightMateWidget()
} timeline: {
    SimpleEntry(date: .now, weight: "야미")
}
