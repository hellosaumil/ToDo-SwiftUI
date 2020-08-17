//
//  QuickListsInfoWidget.swift
//  QuickListsInfoWidget
//
//  Created by Saumil Shah on 8/11/20.
//

import WidgetKit
import SwiftUI

struct QuickListsInfoProvider: IntentTimelineProvider {
    
    typealias Entry = QuickListsInfoEntry
    typealias Intent = ListSelectorIntent
    
    func createContents(from data: [ToDoList]) -> [Entry] {
        
        return data.map { Entry(date: Date(), relevance: nil, todoList: $0) }
    }
    
    
    // MARK: Provider Functions
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), relevance: nil,
                    todoList: placeHolderList)
    }
    
    
    // MARK: Updated based on Intent
    func getSnapshot(for configuration: ListSelectorIntent, in context: Context, completion: @escaping (Entry) -> Void) {
        
        let entry = Entry(date: Date(), relevance: nil, todoList: ToDoList())
        completion(entry)
    }
    
    func getTimeline(for configuration: ListSelectorIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        
        var entries: [Entry] = []
        
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

struct QuickListsInfoEntry: TimelineEntry {
    var date: Date
    var relevance: TimelineEntryRelevance?
    let todoList: ToDoList
}

struct QuickListsInfoWidgetEntryView : View {
    
    var entry: QuickListsInfoProvider.Entry
    
    var body: some View {
        
        // MARK: Call QuickListView
        QuickListView(list: entry.todoList)
    }
}

struct QuickListsInfoPlaceHolderView : View {
    
    typealias Entry = QuickListsInfoProvider.Entry
    
    var body: some View {
        
        QuickListsInfoWidgetEntryView(entry: Entry(date: Date(), relevance: nil,
                                                    todoList: placeHolderList))
            .redacted(reason: .placeholder)
    }
}


struct QuickListsInfoWidget: Widget {
    
    let kind: String = "QuickListsInfoWidget"
    
    var body: some WidgetConfiguration {
        
        IntentConfiguration(kind: kind, intent: ListSelectorIntent.self,
                            provider: QuickListsInfoProvider()) { entry in
            QuickListsInfoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quick Info of Lists")
        .description("Quick glance about your ToDo Lists.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct QuickListsInfoWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            ForEach([WidgetFamily.systemSmall, WidgetFamily.systemMedium], id: \.self) { family in
                
                QuickListsInfoPlaceHolderView()
                    .previewContext(WidgetPreviewContext(family: family))
                
                QuickListsInfoWidgetEntryView(entry: QuickListsInfoEntry(date: Date(), relevance: nil,
                                                            todoList: ToDoList(icon: "")))
                    .previewContext(WidgetPreviewContext(family: family))
            }
        }
        
    }
}


let placeHolderList = ToDoList(name: "Placeholder \nList",
                               gradientStartColor: .pink,
                               gradientEndColor: .purple)

