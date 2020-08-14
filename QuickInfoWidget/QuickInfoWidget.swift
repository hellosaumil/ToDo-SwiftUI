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
        
        return loadListsData(usersListsDataFileName)
    }
    
    // MARK: filterToDoList
    private func filterToDoList(from data: inout [ToDoList],
                                on filterKey: KeyPath<ToDoList, Bool>) {
        
        data = data.filter { $0[keyPath: filterKey] }
    }
    
    private func createContents(from data: [ToDoList]) -> [SimpleEntry] {
        
        return data.map { SimpleEntry(date: Date(), relevance: nil, todoList: $0) }
    }
    
    
    // MARK: Provider Functions
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), relevance: nil,
                    todoList: ToDoList(name: "Placeholder Function List", gradientStartColor: .orange, gradientEndColor: .blue))
    }
    
    
    // MARK: Updated based on Intent
    func getSnapshot(for configuration: ListSelectorIntent, in context: Context, completion: @escaping (Entry) -> Void) {
        
        let entry = SimpleEntry(date: Date(), relevance: nil, todoList: ToDoList())
        completion(entry)
    }
    
    func getTimeline(for configuration: ListSelectorIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        
        var entries: [SimpleEntry] = []
        
        // MARK: Get Config Params
        let favsFlag: Bool? = configuration.showFavorites?.boolValue
        let lockedFlag: Bool? = configuration.showLocked?.boolValue
        
        
        // MARK: Filter Contents before displaying
        var localListContents = readContents()
        
        
        if favsFlag == true {
            filterToDoList(from: &localListContents, on: \.isMyFavorite)
        }
        
        if lockedFlag == true {
            filterToDoList(from: &localListContents, on: \.isLocked)
        }
        
        
        entries = createContents(from: localListContents)
        
        
        let currentDate = Date()
        let interval = 2
        for index in 0 ..< entries.count {
            
            entries[index].date = Calendar.current.date(byAdding: .second,
                                                        value: index * interval,
                                                        to: currentDate)!
            
            // MARK: Update Entry's Relevance
            entries[index].relevance = TimelineEntryRelevance(score: 1.0)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    var relevance: TimelineEntryRelevance?
    let todoList: ToDoList
}

struct QuickInfoWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        
        // MARK: Call QuickListView
        QuickListView(list: entry.todoList)
            .clipShape(ContainerRelativeShape())
    }
}

struct PlaceHolderView : View {
    
    var body: some View {
        
        QuickInfoWidgetEntryView(entry: SimpleEntry(date: Date(), relevance: nil,
                                                    todoList: ToDoList(name: "Placeholder List", gradientStartColor: .green)))
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
                
                QuickInfoWidgetEntryView(entry: SimpleEntry(date: Date(), relevance: nil,
                                                            todoList: ToDoList(icon: "")))
                    .previewContext(WidgetPreviewContext(family: family))
            }
        }
        
    }
}
