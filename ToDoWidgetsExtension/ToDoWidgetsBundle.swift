//
//  ToDoWidgetsBundle.swift
//  ToDo-SwiftUI
//
//  Created by Saumil Shah on 8/17/20.
//

import SwiftUI
import WidgetKit

@main
struct ToDoWidgetsBundle: WidgetBundle {

    // MARK: Bundle Defintion - ToDoWidgetsBundle
    @WidgetBundleBuilder
    var body: some Widget {
        
        QuickListsInfoWidget()
        QuickTasksInfoWidget()
    }
}

