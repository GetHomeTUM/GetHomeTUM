import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // placeholder displayed in the widget configuration menu
    func placeholder(in context: Context) -> GetHome_WidgetEntry {
      let userDefaults = UserDefaults(suiteName: "group.flutter_test_widget")
      
        return GetHome_WidgetEntry(
            date: Date.now,
            api_check: userDefaults?.string(forKey: "api_check") ?? "null",
            storageDate: userDefaults?.string(forKey: "time") ?? "null",
            first_line_name_0 : userDefaults?.string(forKey: "first_line_name_0") ?? "null",
            first_line_color_0 : userDefaults?.string(forKey: "first_line_color_0") ?? "null",
            walking_time_minutes_0 : userDefaults?.string(forKey: "walking_time_minutes_0") ?? "null",
            changes_0 : userDefaults?.string(forKey: "changes_0") ?? "null",
            departure_time_0 : userDefaults?.string(forKey: "departure_time_0") ?? "null",
            
            first_line_name_1 : userDefaults?.string(forKey: "first_line_name_1") ?? "null",
            first_line_color_1 : userDefaults?.string(forKey: "first_line_color_1") ?? "null",
            walking_time_minutes_1 : userDefaults?.string(forKey: "walking_time_minutes_1") ?? "null",
            changes_1 : userDefaults?.string(forKey: "changes_1") ?? "null",
            departure_time_1 : userDefaults?.string(forKey: "departure_time_1") ?? "null",
            
            first_line_name_2 : userDefaults?.string(forKey: "first_line_name_2") ?? "null",
            first_line_color_2: userDefaults?.string(forKey: "first_line_color_2") ?? "null",
            walking_time_minutes_2: userDefaults?.string(forKey: "walking_time_minutes_2") ?? "null",
            changes_2: userDefaults?.string(forKey: "changes_2") ?? "null",
            departure_time_2: userDefaults?.string(forKey: "departure_time_2") ?? "null"
          )
    }

    func getSnapshot(in context: Context, completion: @escaping (GetHome_WidgetEntry) -> ()) {
        let entry: GetHome_WidgetEntry
      if context.isPreview{
        entry = placeholder(in: context)
      }
      else{
        let userDefaults = UserDefaults(suiteName: "group.flutter_test_widget")
          
          entry = GetHome_WidgetEntry(
            date: Date.now,
            api_check: userDefaults?.string(forKey: "api_check") ?? "null",
            storageDate: userDefaults?.string(forKey: "time") ?? "null",
            first_line_name_0 : userDefaults?.string(forKey: "first_line_name_0") ?? "null",
            first_line_color_0 : userDefaults?.string(forKey: "first_line_color_0") ?? "null",
            walking_time_minutes_0 : userDefaults?.string(forKey: "walking_time_minutes_0") ?? "null",
            changes_0 : userDefaults?.string(forKey: "changes_0") ?? "null",
            departure_time_0 : userDefaults?.string(forKey: "departure_time_0") ?? "null",
            
            first_line_name_1 : userDefaults?.string(forKey: "first_line_name_1") ?? "null",
            first_line_color_1 : userDefaults?.string(forKey: "first_line_color_1") ?? "null",
            walking_time_minutes_1 : userDefaults?.string(forKey: "walking_time_minutes_1") ?? "null",
            changes_1 : userDefaults?.string(forKey: "changes_1") ?? "null",
            departure_time_1 : userDefaults?.string(forKey: "departure_time_1") ?? "null",
            
            first_line_name_2 : userDefaults?.string(forKey: "first_line_name_2") ?? "null",
            first_line_color_2: userDefaults?.string(forKey: "first_line_color_2") ?? "null",
            walking_time_minutes_2: userDefaults?.string(forKey: "walking_time_minutes_2") ?? "null",
            changes_2: userDefaults?.string(forKey: "changes_2") ?? "null",
            departure_time_2: userDefaults?.string(forKey: "departure_time_2") ?? "null"
          )
      }
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        main()
        //let refreshDate = Date().addingTimeInterval(60)
      getSnapshot(in: context) { (entry) in
          let timeline = Timeline(entries: [entry], policy: .atEnd)
                  completion(timeline)
              }
    }
}

struct GetHome_WidgetEntry: TimelineEntry {
    var date: Date
    var api_check: String
    var storageDate: String
    
    let first_line_name_0 : String
    let first_line_color_0 : String
    let walking_time_minutes_0 : String
    let changes_0 : String
    let departure_time_0: String
    
    let first_line_name_1 : String
    let first_line_color_1 : String
    let walking_time_minutes_1 : String
    let changes_1 : String
    let departure_time_1: String
    
    let first_line_name_2 : String
    let first_line_color_2 : String
    let walking_time_minutes_2 : String
    let changes_2 : String
    let departure_time_2: String
}

struct GetHome_WidgetEntryView: View {
  var entry: Provider.Entry
    
    init(entry: Provider.Entry){
            self.entry = entry
        }

// the actual body of the widget
  var body: some View {
      VStack {
          Text("\(extractTime(from: entry.date))")
              .font(.system(size: 8))
          Text("\(entry.api_check)")
              .font(.system(size: 7))
          Text("userDefaults: \(entry.storageDate)")
              .font(.system(size: 8))
        HStack {
            ColoredRectangle(color: entry.first_line_color_0, text: entry.first_line_name_0, changes: entry.changes_0, departureTime: entry.departure_time_0, walkingTime: entry.walking_time_minutes_0)
            Spacer()
        }
        HStack {
            ColoredRectangle(color: entry.first_line_color_1, text: entry.first_line_name_1, changes: entry.changes_1, departureTime: entry.departure_time_1, walkingTime: entry.walking_time_minutes_1)
            Spacer()
        }
        HStack {
            ColoredRectangle(color: entry.first_line_color_2, text: entry.first_line_name_2, changes: entry.changes_2, departureTime: entry.departure_time_2, walkingTime: entry.walking_time_minutes_2)
            Spacer()
        }
    }
    .widgetBackground(Color.white)
  }
}

struct ColoredRectangle: View {
    var color: String
    var text: String
    var changes: String
    var departureTime: String
    var walkingTime: String
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(Color(intString: color))
                    .frame(width: 28, height: 20)
                    .cornerRadius(5) // Abgerundete Ecken
                    .overlay(
                        Text(text)
                            .foregroundColor(.white) // Textfarbe
                            .font(text.count > 3 ? .system(size: 10) : .system(size: 15))
                    )
                Text(changes.count > 1 ? "++" : "+\(changes)")
                    .font(.system(size: 9))
                    .padding(.trailing, 3)
                Text(departureTime)
                    .font(.system(size: 14))
            }
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            VStack {
                Image(systemName: "figure.walk")
                    .foregroundColor(.blue) // Farbe des Icons
                    .font(.system(size: 15)) // Schriftgröße des Symbols
                Text(walkingTime.count <= 2 ? "\(walkingTime) min" : walkingTime)
                    .font(walkingTime.count == 2 ? .system(size: 8.5) : .system(size: 11)) // Schriftgröße der walking time
            }
        }
    }
}


extension Color {
    init(intString: String) {
        guard let intValue = Int(intString) else {
            fatalError("Invalid integer string")
        }
        
        let red = Double((intValue & 0xFF0000) >> 16) / 255.0
        let green = Double((intValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(intValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

// iOS 17 bug fix
extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}

struct GetHome_Widget: Widget {
    let kind: String = "NewsWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GetHome_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("GetHome")
        .supportedFamilies([.systemSmall])
        .description("Check your next connections at a glance.")
        
    }
}



struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GetHome_WidgetEntryView(entry:GetHome_WidgetEntry(
                date: Date.now,
                api_check: "success",
                storageDate: "15:15",
                first_line_name_0 : "U1",
                first_line_color_0 : "235733",
                walking_time_minutes_0 : "1",
                changes_0 : "9",
                departure_time_0 : "22:22",
                
                first_line_name_1 : "U1",
                first_line_color_1 : "235733",
                walking_time_minutes_1 : "9",
                changes_1 : "1",
                departure_time_1 : "15:10",
                
                first_line_name_2 : "U1",
                first_line_color_2 : "235733",
                walking_time_minutes_2 : "5",
                changes_2 : "1",
                departure_time_2 : "15:10"
              ))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
