//
//  QuickTasksInfoWidget.swift
//  QuickTasksInfoWidget
//
//  Created by Saumil Shah on 8/16/20.
//

import WidgetKit
import SwiftUI

struct QuickTasksInfoProvider: IntentTimelineProvider {
    
    typealias Entry = QuickTasksInfoEntry
    typealias Intent = DynamicListSelectorIntent
    
    
    func getListToDisplay(for configuration: Intent, from allLists: AllLists) -> ToDoList? {

        
        guard let name = configuration.selectedList?.identifier,
           let list = allLists.listFromURL(name: name) else { return nil }
        
        
        // MARK: Save the last selected character to our App Group.
        // HERE
        print("👀 👀 👀 👀 \t\(name)")
        return list
    }
    
    
    fileprivate func createContents(from data: ToDoList?) -> [Entry] {
        
        guard let validList = data else { return [] }
        return [Entry(date: Date(), relevance: nil, todoList: validList)]
    }
    
    
    // MARK: Provider Functions
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), relevance: nil,
              todoList: placeHolderList)
    }
    
    // MARK: Updated based on Intent
    func getSnapshot(for configuration: Intent, in context: Context, completion: @escaping (Entry) -> Void) {
        
        let entry = Entry(date: Date(), relevance: nil, todoList: ToDoList())
        completion(entry)
    }
    
    func getTimeline(for configuration: Intent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        
        var entries: [Entry] = []
        let localLists = AllLists()
        
        
        let localListContents = readContents()
        localLists.update(from: localListContents)
        
        
        // MARK: Filter Contents before displaying
        let displayList = getListToDisplay(for: configuration, from: localLists)
        entries = createContents(from: displayList)
        
        
        let currentDate = Date()
        print("\nInside getTimeline at \(loggingDateFormatter.string(from: currentDate)) ⏰")
        
        
        for index in 0 ..< entries.count {
            
            entries[index].date = Date()
            
            // MARK: Update Entry's Relevance
            entries[index].relevance = TimelineEntryRelevance(score: 1.0, duration: .zero)
            
        }
        
        let timeline = Timeline(entries: entries, policy: .after(
            
            Calendar.current.date(byAdding: .second,
                                  value: 1,
                                  to: currentDate)!
        ))
        completion(timeline)
    }
}

struct QuickTasksInfoEntry: TimelineEntry {
    var date: Date
    var relevance: TimelineEntryRelevance?
    let todoList: ToDoList
}

struct QuickTasksInfoWidgetEntryView : View {
    
    var entry: QuickTasksInfoProvider.Entry
    
    var body: some View {
        
        // MARK: Call QuickTasksView
        QuickTasksView(list: entry.todoList)
    }
}

struct QuickTasksInfoPlaceHolderView : View {
    
    typealias Entry = QuickTasksInfoProvider.Entry
    
    var body: some View {
        
        QuickTasksInfoWidgetEntryView(entry: Entry(date: Date(), relevance: nil,
                                                   todoList: placeHolderList))
            .redacted(reason: .placeholder)
    }
}


struct QuickTasksInfoWidget: Widget {
    
    let kind: String = "QuickTasksInfoWidget"
    
    var body: some WidgetConfiguration {
        
        IntentConfiguration(kind: kind, intent: DynamicListSelectorIntent.self,
                            provider: QuickTasksInfoProvider()) { entry in
            
            QuickTasksInfoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quick Info of Tasks")
        .description("Quick glance about your ToDo Tasks.")
        .supportedFamilies([.systemLarge, .systemMedium])
    }
}

struct QuickTasksInfoWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            ForEach([WidgetFamily.systemMedium, WidgetFamily.systemLarge], id: \.self) { family in
                
                QuickTasksInfoPlaceHolderView()
                    .previewContext(WidgetPreviewContext(family: family))
                
                QuickTasksInfoWidgetEntryView(entry: QuickTasksInfoEntry(date: Date(), relevance: nil,
                                                                         todoList: ToDoList(icon: "")))
                    .previewContext(WidgetPreviewContext(family: family))
            }
        }
        
    }
}
