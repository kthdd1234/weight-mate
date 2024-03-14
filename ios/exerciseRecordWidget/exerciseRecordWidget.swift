import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ExerciseRecordEntry {
        ExerciseRecordEntry(date: .now, erHeaderTitle: "", erToday: "", erFontFamily: "", erEmptyTitle: "", erIsEmpty: "", erRenderCellList: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (ExerciseRecordEntry) -> ()) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        
        let erHeaderTitle = data?.string(forKey: "erHeaderTitle") ?? "오늘의 운동 기록"
        let erToday = data?.string(forKey: "erToday") ?? ""
        let erFontFamily = data?.string(forKey: "erFontFamily") ?? "cafe24Ohsquareair"
        let erIsEmpty = data?.string(forKey: "erIsEmpty") ?? "empty"
        let erEmptyTitle = data?.string(forKey: "erEmptyTitle") ?? "운동 기록하기"
        let erRenderCellList = data?.string(forKey: "erRenderCellList") ?? ""
        
        let entry = ExerciseRecordEntry(date: Date(), erHeaderTitle: erHeaderTitle, erToday: erToday, erFontFamily: erFontFamily, erEmptyTitle: erEmptyTitle, erIsEmpty: erIsEmpty, erRenderCellList: erRenderCellList)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct ExerciseRecordEntry: TimelineEntry {
    let date: Date
    let erHeaderTitle: String
    let erToday: String
    let erFontFamily: String
    let erEmptyTitle: String
    let erIsEmpty: String
    let erRenderCellList: String
}

struct exerciseRecordWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var wFamily
    @State var itemRenderList: [ItemModel]
    
    init(entry: Provider.Entry){
        self.entry = entry
        self.itemRenderList = loadJson(json: entry.erRenderCellList)
        
        initCutomFont(fontFamily: entry.erFontFamily)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HeaderCell(title: entry.erHeaderTitle, secondary: isWidgetSizeMediumLarge(family: wFamily) ? entry.erToday : "", fontFamily: entry.erFontFamily).padding(.top, 5)
            if entry.erIsEmpty != "empty" {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(wItemList(family: wFamily, list: itemRenderList)) { item in
                        IconTextCell(
                            text: item.name,
                            systemName: systemName(type: item.type, key: item.title),
                            iconColor: iconColor(type: item.type),
                            bgColor: bgColor(type: item.type),
                            fontFamily: entry.erFontFamily
                        )
                    }
                }
                Spacer()
            } else {
                EmptyCell(svgName: "empty-record", text: entry.erEmptyTitle, fontFamily: entry.erFontFamily)
            }
        }
        .widgetURL(URL(string: "exercise://message?message=record&homeWidget"))
        .containerBackground(for: .widget) {
            BackgroundCell()
        }
    }
}

struct exerciseRecordWidget: Widget {
    let kind: String = "exerciseRecordWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
                exerciseRecordWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("운동 기록")
        .description("오늘의 운동 기록을 한눈에 확인 할 수 있어요.")
    }
}

#Preview(as: .systemSmall) {
    exerciseRecordWidget()
} timeline: {
    ExerciseRecordEntry(date: .now, erHeaderTitle: "오늘의 식단 기록", erToday: "", erFontFamily: "", erEmptyTitle: "식단 기록하기", erIsEmpty: "empty", erRenderCellList: "")
}
