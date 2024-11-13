//
//  TodoApp.swift
//  Todo
//
//  Created by Meri Stakovska on 2024-11-09.
//

import SwiftUI
import SwiftData

@main
struct TODOApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TodoItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TodoListView()
                .modelContainer(for: TodoItem.self) // Använd SwiftData container för TodoItem
    
        }
        .modelContainer(sharedModelContainer)
    }
}
