import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DietGoalEntry {
        DietGoalEntry(date: Date(), dgHeaderTitle: "", dgToday: "", dgFontFamily: "", dgEmptyTitle: "", dgIsEmpty: "", dgRenderCellList: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (DietGoalEntry) -> ()) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        
        let dgHeaderTitle = data?.string(forKey: "dgHeaderTitle") ?? "오늘의 식단 목표"
        let dgToday = data?.string(forKey: "dgToday") ?? ""
        let dgFontFamily = data?.string(forKey: "dgFontFamily") ?? "cafe24Ohsquareair"
        let dgIsEmpty = data?.string(forKey: "dgIsEmpty") ?? "empty"
        let dgEmptyTitle = data?.string(forKey: "dgEmptyTitle") ?? "목표 추가하기"
        let dgRenderCellList = data?.string(forKey: "dgRenderCellList") ?? ""
        
        let entry = DietGoalEntry(date: Date(), dgHeaderTitle: dgHeaderTitle, dgToday: dgToday, dgFontFamily: dgFontFamily, dgEmptyTitle: dgEmptyTitle, dgIsEmpty: dgIsEmpty, dgRenderCellList: dgRenderCellList)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct DietGoalEntry: TimelineEntry {
    let date: Date
    let dgHeaderTitle: String
    let dgToday: String
    let dgFontFamily: String
    let dgEmptyTitle: String
    let dgIsEmpty: String
    let dgRenderCellList: String
}

struct dietGoalWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var wFamily
    @State var goalRenderList: [GoalModel]
    
    init(entry: Provider.Entry){
        self.entry = entry
        self.goalRenderList = loadJson(json: entry.dgRenderCellList)
        
        initCutomFont(fontFamily: entry.dgFontFamily)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HeaderCell(title: entry.dgHeaderTitle, secondary: isWidgetSizeMediumLarge(family: wFamily) ? entry.dgToday : "", fontFamily: entry.dgFontFamily).padding(.top, 5)
            
            if entry.dgIsEmpty != "empty" {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(wGoalList(family: wFamily, list: goalRenderList)) { item in
                        CheckedIntentCell(item: item, fontFamily: entry.dgFontFamily, schema: "diet")
                    }
                }
                Spacer()
            } else {
                EmptyCell(svgName: "empty-goal", text: entry.dgEmptyTitle, fontFamily: entry.dgFontFamily)
            }
        }
        .widgetURL(URL(string: "diet://message?message=goal&homeWidget"))
        .containerBackground(for: .widget) {
            BackgroundCell()
        }
    }
}

struct dietGoalWidget: Widget {
    let kind: String = "dietGoalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
                dietGoalWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("식단 목표")
        .description("오늘의 식단 목표를 한눈에 확인할 수 있어요.")
    }
}

#Preview(as: .systemSmall) {
    dietGoalWidget()
} timeline: {
    DietGoalEntry(date: .now, dgHeaderTitle: "오늘의 식단 목표", dgToday: "", dgFontFamily: "", dgEmptyTitle: "목표 추가하기", dgIsEmpty: "empty", dgRenderCellList: "")
}
