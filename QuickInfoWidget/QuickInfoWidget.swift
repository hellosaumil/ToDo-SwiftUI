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
    
    private func readContents() -> [SimpleEntry] {
        
        var contents: [SimpleEntry] = []
        
        contents = loadListsData(usersListsDataFileName).map { SimpleEntry(date: Date(), todoList: $0) }
        
        return contents
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [SimpleEntry] = []
        entries = readContents()

        let currentDate = Date()

        let interval = 2
        for index in 0 ..< entries.count {
            entries[index].date = Calendar.current.date(byAdding: .second,
                                                        value: index * interval,
                                                        to: currentDate)!
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    let todoList: ToDoList
}

struct QuickInfoWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        
        // MARK: Call QuickListView
        QuickListView(list: entry.todoList)
    }
}

struct PlaceHolderView : View {
    
    var body: some View {
        
        QuickInfoWidgetEntryView(entry: SimpleEntry(date: Date(), todoList: randomLists[0]))
            .redacted(reason: .placeholder)
    }
}


@main
struct QuickInfoWidget: Widget {
    let kind: String = "QuickInfoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            QuickInfoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quick Info")
        .description("Quick glance about your ToDo Lists.")
    }
}

struct QuickInfoWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            ForEach([WidgetFamily.systemSmall, WidgetFamily.systemMedium], id: \.self) { family in
                
                PlaceHolderView()
                    .previewContext(WidgetPreviewContext(family: family))
                
                QuickInfoWidgetEntryView(entry: SimpleEntry(date: Date(), todoList: randomLists[0]))
                    .previewContext(WidgetPreviewContext(family: family))
            }
        }
        
    }
}
