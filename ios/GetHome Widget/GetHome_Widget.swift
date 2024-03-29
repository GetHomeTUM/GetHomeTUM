//
//  GetHome_Widget.swift
//  GetHome Widget
//
//  Created by Lennart Hesse on 29.03.24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), routeTilePath: "testWidget")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, routeTilePath: "testWidget")
        //let lineChartPath = userDefaults?.string(forKey: "testWidget") ?? "No screenshot available"
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, routeTilePath: "testWidget")
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let routeTilePath: String
}

struct GetHome_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            ChartImage
        }
    }

    var ChartImage: some View {
        if let uiImage = UIImage(contentsOfFile: entry.routeTilePath) {
            let image = Image(uiImage: uiImage)
                .resizable()
                .frame(width: 400, height: 400, alignment: .center)
            print("File loaded")
            return AnyView(image)
        }
        print("The image file could not be loaded")
        return AnyView(EmptyView())
    }
}

struct GetHome_Widget: Widget {
    let kind: String = "GetHome_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            GetHome_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    GetHome_Widget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, routeTilePath: "testWidget")
    SimpleEntry(date: .now, configuration: .starEyes, routeTilePath: "testWidget")
}
