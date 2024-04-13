import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // placeholder displayed in the widget configuration menu
    func placeholder(in context: Context) -> GetHome_WidgetEntry {
      let userDefaults = UserDefaults(suiteName: "group.flutter_test_widget")
      let title = userDefaults?.string(forKey: "time") ?? "Didn't get data"
      let filename = userDefaults?.string(forKey: "filename") ?? "No screenshot available"
      return GetHome_WidgetEntry(date: Date(), title: title, description: "Next connections.", filename: filename,  displaySize: context.displaySize)
    }

    func getSnapshot(in context: Context, completion: @escaping (GetHome_WidgetEntry) -> ()) {
        let entry: GetHome_WidgetEntry
      if context.isPreview{
        entry = placeholder(in: context)
      }
      else{
        let userDefaults = UserDefaults(suiteName: "group.flutter_test_widget")
        let title = userDefaults?.string(forKey: "time") ?? "Didn't get data"
        let currLoc = userDefaults?.string(forKey: "current_location") ?? "no current location"
        let homeLoc = userDefaults?.string(forKey: "home_location") ?? "no home location"
        let description = currLoc + "\n" + homeLoc
        // New: get fileName from key/value store
        let filename = userDefaults?.string(forKey: "filename") ?? "No screenshot available"
        print(filename)
        entry = GetHome_WidgetEntry(date: Date(), title: title, description: description, filename: filename,  displaySize: context.displaySize)
      }
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
      getSnapshot(in: context) { (entry) in
        let timeline = Timeline(entries: [entry], policy: .atEnd)
                  completion(timeline)
              }
    }
}

struct GetHome_WidgetEntry: TimelineEntry {
    let date: Date
    let title: String
    let description: String
    // New: add the filename and displaySize.
    let filename: String
    let displaySize: CGSize
}

struct GetHome_WidgetEntryView: View {
  var entry: Provider.Entry
    
    init(entry: Provider.Entry){
            self.entry = entry
            CTFontManagerRegisterFontsForURL(bundle.appending(path: "/fonts/Chewy-Regular.ttf") as CFURL, CTFontManagerScope.process, nil)
        }
    
    var bundle: URL {
            let bundle = Bundle.main
            if bundle.bundleURL.pathExtension == "appex" {
                // Peel off two directory levels - MY_APP.app/PlugIns/MY_APP_EXTENSION.appex
                var url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
                url.append(component: "Frameworks/App.framework/flutter_assets")
                return url
            }
            return bundle.bundleURL
        }
   // creating a ChartImage View that shows the rendered image from flutter
   var ChartImage: some View {
        if let uiImage = UIImage(contentsOfFile: entry.filename) {
            let image = Image(uiImage: uiImage)
                .resizable()
                .frame(width: entry.displaySize.width*0.7, height: entry.displaySize.height*0.7, alignment: .center)
            return AnyView(image)
        }
        print("The image file could not be loaded")
        return AnyView(EmptyView())
    }


// the actual body of the widget
  var body: some View {
    VStack {
        Text(entry.title).font(Font.custom("Chewy", size: 13))
        Text(entry.description).font(.system(size: 12)).padding(10)
        //ChartImage
    }
    .widgetBackground(Color.white)
  }
}

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

