import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DietRecordEntry {
        DietRecordEntry(date: Date(), drHeaderTitle: "", drToday: "", drFontFamily: "", drEmptyTitle: "", drIsEmpty: "", drRenderCellList: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (DietRecordEntry) -> ()) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        
        let drHeaderTitle = data?.string(forKey: "drHeaderTitle") ?? "오늘의 식단 기록"
        let drToday = data?.string(forKey: "drToday") ?? ""
        let drFontFamily = data?.string(forKey: "drFontFamily") ?? "cafe24Ohsquareair"
        let drIsEmpty = data?.string(forKey: "drIsEmpty") ?? "empty"
        let drEmptyTitle = data?.string(forKey: "drEmptyTitle") ?? "식단 기록하기"
        let drRenderCellList = data?.string(forKey: "drRenderCellList") ?? ""
        
        let entry = DietRecordEntry(date: Date(), drHeaderTitle: drHeaderTitle, drToday: drToday, drFontFamily: drFontFamily, drEmptyTitle: drEmptyTitle, drIsEmpty: drIsEmpty, drRenderCellList: drRenderCellList)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct DietRecordEntry: TimelineEntry {
    let date: Date
    let drHeaderTitle: String
    let drToday: String
    let drFontFamily: String
    let drEmptyTitle: String
    let drIsEmpty: String
    let drRenderCellList: String
}

struct dietRecordWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var wFamily
    @State var itemRenderList: [ItemModel]
    
    init(entry: Provider.Entry){
        self.entry = entry
        self.itemRenderList = loadJson(json: entry.drRenderCellList)
        
        initCutomFont(fontFamily: entry.drFontFamily)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderCell(title: entry.drHeaderTitle, secondary: isWidgetSizeMediumLarge(family: wFamily) ? entry.drToday : "", fontFamily: entry.drFontFamily).padding(.top, 5)
            if entry.drIsEmpty != "empty" {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(wItemList(family: wFamily, list: itemRenderList)) { item in
                        IconTextCell(
                            text: item.name,
                            systemName: systemName(type: item.type, key: item.title),
                            iconColor: iconColor(type: item.type),
                            bgColor: bgColor(type: item.type),
                            fontFamily: entry.drFontFamily
                        )
                    }
                }
                Spacer()
            } else {
                EmptyCell(svgName: "empty-record", text: entry.drEmptyTitle, fontFamily: entry.drFontFamily)
            }
        }
        .widgetURL(URL(string: "diet://message?message=record&homeWidget"))
        .containerBackground(for: .widget) {
            BackgroundCell()
        }
    }
}

struct dietRecordWidget: Widget {
    let kind: String = "dietRecordWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            dietRecordWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("식단 기록")
        .description("오늘의 식단 기록을 한눈에 확인 할 수 있어요.")
    }
}

#Preview(as: .systemSmall) {
    dietRecordWidget()
} timeline: {
    DietRecordEntry(date: .now, drHeaderTitle: "오늘의 식단 기록", drToday: "", drFontFamily: "", drEmptyTitle: "식단 기록하기", drIsEmpty: "empty", drRenderCellList: "")
}
