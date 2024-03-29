//
//  GetHome_WidgetLiveActivity.swift
//  GetHome Widget
//
//  Created by Lennart Hesse on 29.03.24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GetHome_WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct GetHome_WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GetHome_WidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GetHome_WidgetAttributes {
    fileprivate static var preview: GetHome_WidgetAttributes {
        GetHome_WidgetAttributes(name: "World")
    }
}

extension GetHome_WidgetAttributes.ContentState {
    fileprivate static var smiley: GetHome_WidgetAttributes.ContentState {
        GetHome_WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: GetHome_WidgetAttributes.ContentState {
         GetHome_WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: GetHome_WidgetAttributes.preview) {
   GetHome_WidgetLiveActivity()
} contentStates: {
    GetHome_WidgetAttributes.ContentState.smiley
    GetHome_WidgetAttributes.ContentState.starEyes
}
