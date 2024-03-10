import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WeightEntry {
        WeightEntry(date: Date(), headerTitle: "", today: "", weightTitle: "", weight: "", bmiTitle: "", bmi: "", goalWeightTitle: "", goalWeight: "", emptyWeightTitle: "", fontFamily: "", isEmpty: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (WeightEntry) -> ()) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        
        let headerTitle = data?.string(forKey: "headerTitle") ?? "오늘의 체중"
        let today = data?.string(forKey: "today") ?? ""
        let weightTitle = data?.string(forKey: "weightTitle") ?? "체중"
        let weight = data?.string(forKey: "weight") ?? "-"
        let bmiTitle = data?.string(forKey: "bmiTitle") ?? "BMI"
        let bmi = data?.string(forKey: "bmi") ?? "0.0"
        let goalWeightTitle = data?.string(forKey: "goalWeightTitle") ?? "목표 체중"
        let goalWeight = data?.string(forKey: "goalWeight") ?? "-"
        let emptyWeightTitle = data?.string(forKey: "emptyWeightTitle") ?? ""
        let fontFamily = data?.string(forKey: "fontFamily") ?? "cafe24Ohsquareair"
        let isEmpty = data?.string(forKey: "isEmpty") ?? "empty"
        
        let entry = WeightEntry(date: Date(), headerTitle: headerTitle, today: today, weightTitle: weightTitle, weight: weight, bmiTitle: bmiTitle, bmi: bmi, goalWeightTitle: goalWeightTitle, goalWeight: goalWeight, emptyWeightTitle: emptyWeightTitle, fontFamily: fontFamily, isEmpty: isEmpty)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct WeightEntry: TimelineEntry {
    let date: Date
    let headerTitle: String
    let today: String
    let weightTitle: String
    let weight: String
    let bmiTitle: String
    let bmi: String
    let goalWeightTitle: String
    let goalWeight: String
    let emptyWeightTitle: String
    let fontFamily: String
    let isEmpty: String
}

struct weightMateWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var wFamily
    
    init(entry: Provider.Entry){
        self.entry = entry
        initCutomFont(fontFamily: entry.fontFamily)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            HeaderCell(title: entry.headerTitle, secondary: isWidgetSizeMediumLarge(family: wFamily) ? entry.today : "", fontFamily: entry.fontFamily)
          
            if entry.isEmpty == "show" {
                VStack(alignment: .leading, spacing: 15) {
                    SvgTextCell(svgName: "weight", title: entry.weightTitle, value: entry.weight, fontFamily: entry.fontFamily)
                    SvgTextCell(svgName: "bmi", title: entry.bmiTitle, value: entry.bmi, fontFamily: entry.fontFamily)
                    SvgTextCell(svgName: "flag", title: entry.goalWeightTitle, value: entry.goalWeight, fontFamily: entry.fontFamily)
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            } else {
                EmptyCell(svgName: "empty-weight", text: entry.emptyWeightTitle, fontFamily: entry.fontFamily)
            }
        }
        .widgetURL(URL(string: "weight://message?message=null&homeWidget"))
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
        .configurationDisplayName("위젯 기능 준비 중입니다.") // 체중 기록
        .description("위젯 기능 준비 중이라 제대로 작동하지 않아요.") // 오늘의 체중을 빠르게 기록 할 수 있어요.
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct WeightMateWidget_Previews: PreviewProvider {
    static var previews: some View {
        weightMateWidgetEntryView(entry: WeightEntry(date: Date(), headerTitle: "오늘의 체중", today: "", weightTitle: "체중", weight: "-", bmiTitle: "BMI", bmi: "0.0", goalWeightTitle: "목표 체중", goalWeight: "-", emptyWeightTitle: "체중 기록하기", fontFamily: "", isEmpty: "empty"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

#Preview(as: .systemSmall) {
    weightMateWidget()
} timeline: {
    WeightEntry(date: .now, headerTitle: "", today: "", weightTitle: "", weight: "", bmiTitle: "", bmi: "",  goalWeightTitle: "", goalWeight: "", emptyWeightTitle: "", fontFamily: "", isEmpty: "")
}
