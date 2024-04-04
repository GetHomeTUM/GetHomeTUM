//
//  GetHome_WidgetBundle.swift
//  GetHome Widget
//
//  Created by Lennart Hesse on 29.03.24.
//

import WidgetKit
import SwiftUI

@main
struct GetHome_WidgetBundle: WidgetBundle {
    var body: some Widget {
        GetHome_Widget()
        GetHome_WidgetLiveActivity()
    }
}
