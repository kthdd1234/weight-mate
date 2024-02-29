//
//  weight_mate_widget.swift
//  weight_mate_widget
//
//  Created by 김동현 on 2/27/24.
//

import WidgetKit
import SwiftUI

private let widgetGroupId = "group.weight-mate-widget"

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
       
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let weight: String
}

struct weight_mate_widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(){
                Text("오늘").font(.headline).lineLimit(1)
                Spacer()
                Text("02.28 (수)").font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            VStack(alignment: .leading, spacing: 15) {
                HStack{
                    SvgIcon(name: "weight")
                    Text("체중").font(.footnote)
                    Spacer()
                    Text("67.3kg").font(.footnote)
                }
                HStack{
                    SvgIcon(name: "bmi")
                    Text("BMI").font(.footnote)
                    Spacer()
                    Text("32.1").font(.footnote)
                }
                HStack{
                    SvgIcon(name: "flag")
                    Text("목표까지").font(.footnote)
                    Spacer()
                    Text("5.8kg").font(.footnote)
                }
            }
            
        }
        .containerBackground(for: .widget) {
            Image("CloudyApple")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
        }
    }
}


struct weight_mate_widget: Widget {
    let kind: String = "weight_mate_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                weight_mate_widgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                weight_mate_widgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        
    }
}

struct SvgIcon: View {
    var name: String
    
    var body: some View {
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 10, height: 10)
                .padding(3)
                .background(.white)
                .cornerRadius(3)
    }
}

struct weight_mate_widget_Previews: PreviewProvider {
    static var previews: some View {
        weight_mate_widgetEntryView(entry: SimpleEntry(date: Date(), weight: "Example Weight")).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
