import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ExerciseGoalEntry {
        ExerciseGoalEntry(date: Date(), egHeaderTitle: "", egToday: "", egFontFamily: "", egEmptyTitle: "", egIsEmpty: "", egRenderCellList: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (ExerciseGoalEntry) -> ()) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        
        let egHeaderTitle = data?.string(forKey: "egHeaderTitle") ?? "오늘의 운동 목표"
        let egToday = data?.string(forKey: "egToday") ?? ""
        let egFontFamily = data?.string(forKey: "egFontFamily") ?? "cafe24Ohsquareair"
        let egIsEmpty = data?.string(forKey: "egIsEmpty") ?? "empty"
        let egEmptyTitle = data?.string(forKey: "egEmptyTitle") ?? "목표 추가하기"
        let egRenderCellList = data?.string(forKey: "egRenderCellList") ?? ""
        
        let entry = ExerciseGoalEntry(date: Date(), egHeaderTitle: egHeaderTitle, egToday: egToday, egFontFamily: egFontFamily, egEmptyTitle: egEmptyTitle, egIsEmpty: egIsEmpty, egRenderCellList: egRenderCellList)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct ExerciseGoalEntry: TimelineEntry {
    let date: Date
    let egHeaderTitle: String
    let egToday: String
    let egFontFamily: String
    let egEmptyTitle: String
    let egIsEmpty: String
    let egRenderCellList: String
}

struct exerciseGoalWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var wFamily
    @State var goalRenderList: [GoalModel]
    
    init(entry: Provider.Entry){
        self.entry = entry
        self.goalRenderList = loadJson(json: entry.egRenderCellList)
        
        initCutomFont(fontFamily: entry.egFontFamily)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HeaderCell(title: entry.egHeaderTitle, secondary: isWidgetSizeMediumLarge(family: wFamily) ? entry.egToday : "", fontFamily: entry.egFontFamily).padding(.top, 5)
            
            if entry.egIsEmpty != "empty" {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(wGoalList(family: wFamily, list: goalRenderList)) { item in
                        CheckedIntentCell(item: item, fontFamily: entry.egFontFamily, schema: "exercise")
                    }
                }
                Spacer()
            } else {
                EmptyCell(svgName: "empty-goal", text: entry.egEmptyTitle, fontFamily: entry.egFontFamily)
            }
        }
        .widgetURL(URL(string: "exercise://message?message=goal&homeWidget"))
        .containerBackground(for: .widget) {
            BackgroundCell()
        }
    }
}

struct exerciseGoalWidget: Widget {
    let kind: String = "exerciseGoalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            exerciseGoalWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("운동 목표")
        .description("오늘의 운동 목표를 한눈에 확인 할 수 있어요.")
    }
}

#Preview(as: .systemSmall) {
    exerciseGoalWidget()
} timeline: {
    ExerciseGoalEntry(date: .now, egHeaderTitle: "오늘의 운동 목표", egToday: "", egFontFamily: "", egEmptyTitle: "목표 추가하기", egIsEmpty: "empty", egRenderCellList: "")
}
