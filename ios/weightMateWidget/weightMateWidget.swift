import WidgetKit
import SwiftUI


public var widgetGroupId = "group.weight-mate-widget"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), weight: "Placeholder weight")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        let entry = SimpleEntry(date: Date(), weight: data?.string(forKey: "weight") ?? "No Weight Set")
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeline = Timeline(entries: [SimpleEntry(date: Date(), weight: "")], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let weight: String
}

struct weightMateWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderCell(title: "오늘", secondary: "2.28 (수)")
//            EmptyCell(svgName: "empty-weight", text: "체중 기록하기")
            VStack(alignment: .leading, spacing: 15) {
                SvgTextCell(svgName: "weight", title: "체중", value: "67.3kg")
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
        .description("오늘의 체중을 빠르게 기록할 수 있어요.")
        .supportedFamilies([.systemSmall])
    }
}

struct WeightMateWidget_Previews: PreviewProvider {
    static var previews: some View {
        weightMateWidgetEntryView(entry: SimpleEntry(date: Date(), weight: "Example Weight")).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

#Preview(as: .systemSmall) {
    weightMateWidget()
} timeline: {
    SimpleEntry(date: .now, weight: "")
}
