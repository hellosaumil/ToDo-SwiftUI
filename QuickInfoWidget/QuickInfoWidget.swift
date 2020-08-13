//
//  QuickInfoWidget.swift
//  QuickInfoWidget
//
//  Created by Saumil Shah on 8/11/20.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    
    typealias Entry = SimpleEntry
    typealias Intent = ListSelectorIntent
    
    
    private func readContents() -> [ToDoList] {
        
        var contents: [ToDoList] = []
        contents = loadListsData(usersListsDataFileName)
        return contents
    }
    
    private func readFavContents(onlyFav: Bool? = false, onlyLocked: Bool? = false) -> [SimpleEntry] {
        
        var contents: [Entry] = []
        
        contents = readContents()
            .filter { (onlyFav ?? false) ? $0.isMyFavorite : true  }
            .filter { (onlyLocked ?? false) ? $0.isLocked : true  }
            .map { SimpleEntry(date: Date(), todoList: $0) }
        
        return contents
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), todoList: ToDoList())
    }
    
    
    // MARK: Updated based on Intent
    
    
    func getSnapshot(for configuration: ListSelectorIntent, in context: Context, completion: @escaping (Entry) -> Void) {
        
        let entry = SimpleEntry(date: Date(), todoList: ToDoList())
        completion(entry)
    }
    
    
    func getTimeline(for configuration: ListSelectorIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        
        // MARK: Get Config Params
        let favsOnly: Bool? = configuration.showFavorites?.boolValue
        let lockedOnly: Bool? = configuration.showLocked?.boolValue
    
        var entries: [SimpleEntry] = []
        entries = readFavContents(onlyFav: favsOnly, onlyLocked: lockedOnly)
        
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
        
        IntentConfiguration(kind: kind, intent: ListSelectorIntent.self,
                            provider: Provider()) { entry in
            QuickInfoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quick Info")
        .description("Quick glance about your ToDo Lists.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct QuickInfoWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            ForEach([WidgetFamily.systemSmall, WidgetFamily.systemMedium], id: \.self) { family in
                
                PlaceHolderView()
                    .previewContext(WidgetPreviewContext(family: family))
                
                QuickInfoWidgetEntryView(entry: SimpleEntry(date: Date(), todoList: ToDoList(icon: "")))
                    .previewContext(WidgetPreviewContext(family: family))
            }
        }
        
    }
}
