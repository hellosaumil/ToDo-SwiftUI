//
//  QuickTasksInfoWidget.swift
//  QuickTasksInfoWidget
//
//  Created by Saumil Shah on 8/16/20.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    
    typealias Entry = SimpleEntry
    typealias Intent = ListSelectorIntent
    
    func createContents(from data: [ToDoList]) -> [SimpleEntry] {
        
        return data.map { SimpleEntry(date: Date(), relevance: nil, todoList: $0) }
    }
    
    
    // MARK: Provider Functions
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), relevance: nil,
                    todoList: placeHolderList)
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
        
        print("\nInside getTimeline at \(loggingDateFormatter.string(from: currentDate)) ⏰")
        
        let interval = 4
        for index in 0 ..< entries.count {
            
            entries[index].date = Calendar.current.date(byAdding: .second,
                                                        value: index * interval,
                                                        to: currentDate)!
            
            // MARK: Update Entry's Relevance
            entries[index].relevance = TimelineEntryRelevance(score: Float(1/entries.count) )
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

struct QuickTasksInfoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        
        // MARK: Call QuickTasksView
        QuickTasksView(list: entry.todoList)
    }
}

let placeHolderList = ToDoList(name: "Placeholder \nList",
                               gradientStartColor: .pink,
                               gradientEndColor: .purple)

struct PlaceHolderView : View {
    
    var body: some View {
        
        QuickTasksInfoWidgetEntryView(entry: SimpleEntry(date: Date(), relevance: nil,
                                                    todoList: placeHolderList))
            .redacted(reason: .placeholder)
    }
}

@main
struct QuickTasksInfoWidget: Widget {
    let kind: String = "QuickTasksInfoWidget"

    var body: some WidgetConfiguration {
        
        IntentConfiguration(kind: kind, intent: ListSelectorIntent.self,
         provider: Provider()) { entry in
        
            QuickTasksInfoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quick Info of Tasks")
        .description("Quick glance about your ToDo Tasks.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct QuickTasksInfoWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            ForEach([WidgetFamily.systemSmall, WidgetFamily.systemMedium], id: \.self) { family in
                
                PlaceHolderView()
                    .previewContext(WidgetPreviewContext(family: family))
                
                QuickTasksInfoWidgetEntryView(entry: SimpleEntry(date: Date(), relevance: nil,
                                                            todoList: ToDoList(icon: "")))
                    .previewContext(WidgetPreviewContext(family: family))
            }
        }

    }
}
