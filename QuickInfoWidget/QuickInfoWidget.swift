//
//  QuickInfoWidget.swift
//  QuickInfoWidget
//
//  Created by Saumil Shah on 8/11/20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), todoList: ToDoList())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), todoList: ToDoList())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, todoList: ToDoList())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let todoList: ToDoList
}

struct QuickInfoWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        
        QuickListView(list: entry.todoList)
    }
}

@main
struct QuickInfoWidget: Widget {
    let kind: String = "QuickInfoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            QuickInfoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct QuickInfoWidget_Previews: PreviewProvider {
    static var previews: some View {
        QuickInfoWidgetEntryView(entry: SimpleEntry(date: Date(), todoList: randomLists[0]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
