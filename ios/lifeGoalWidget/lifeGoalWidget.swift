import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> LifeGoalEntry {
        LifeGoalEntry(date: Date(), lgHeaderTitle: "", lgToday: "", lgFontFamily: "", lgEmptyTitle: "", lgIsEmpty: "", lgRenderCellList: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (LifeGoalEntry) -> ()) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        
        let lgHeaderTitle = data?.string(forKey: "lgHeaderTitle") ?? "오늘의 습관"
        let lgToday = data?.string(forKey: "lgToday") ?? ""
        let lgFontFamily = data?.string(forKey: "lgFontFamily") ?? "cafe24Ohsquareair"
        let lgIsEmpty = data?.string(forKey: "lgIsEmpty") ?? "empty"
        let lgEmptyTitle = data?.string(forKey: "lgEmptyTitle") ?? "목표 추가하기"
        let lgRenderCellList = data?.string(forKey: "lgRenderCellList") ?? ""
        
        let entry = LifeGoalEntry(date: Date(), lgHeaderTitle: lgHeaderTitle, lgToday: lgToday, lgFontFamily: lgFontFamily, lgEmptyTitle: lgEmptyTitle, lgIsEmpty: lgIsEmpty, lgRenderCellList: lgRenderCellList)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct LifeGoalEntry: TimelineEntry {
    let date: Date
    let lgHeaderTitle: String
    let lgToday: String
    let lgFontFamily: String
    let lgEmptyTitle: String
    let lgIsEmpty: String
    let lgRenderCellList: String
}

struct lifeGoalWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var wFamily
    @State var goalRenderList: [GoalModel]
    
    init(entry: Provider.Entry){
        self.entry = entry
        self.goalRenderList = loadJson(json: entry.lgRenderCellList)
        
        initCutomFont(fontFamily: entry.lgFontFamily)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HeaderCell(title: entry.lgHeaderTitle, secondary: isWidgetSizeMediumLarge(family: wFamily) ? entry.lgToday : "", fontFamily: entry.lgFontFamily).padding(.top, 5)
            
            if entry.lgIsEmpty != "empty" {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(wGoalList(family: wFamily, list: goalRenderList)) { item in
                        CheckedIntentCell(item: item, fontFamily: entry.lgFontFamily, schema: "life")
                    }
                }
                Spacer()
            } else {
                EmptyCell(svgName: "empty-goal", text: entry.lgEmptyTitle, fontFamily: entry.lgFontFamily)
            }
        }
        .widgetURL(URL(string: "life://message?message=goal&homeWidget"))
        .containerBackground(for: .widget) {
            BackgroundCell()
        }
    }
}

struct lifeGoalWidget: Widget {
    let kind: String = "lifeGoalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
                lifeGoalWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("오늘의 습관")
        .description("오늘의 습관을 한눈에 확인 할 수 있어요.")
    }
}

#Preview(as: .systemSmall) {
    lifeGoalWidget()
} timeline: {
    LifeGoalEntry(date: .now , lgHeaderTitle: "오늘의 습관", lgToday: "", lgFontFamily: "", lgEmptyTitle: "습관 추가하기", lgIsEmpty: "empty", lgRenderCellList: "")
}
