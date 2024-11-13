//
//  TodoListView2.swift
//  TODO
//
//  Created by Meri Stakovska on 2024-11-09.
//

import SwiftUI
import SwiftData

struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var todoItems: [TodoItem] // Hämta alla TodoItems utan sortering
    @State private var newTodoTitle: String = ""
    
    // Sortera manuellt, så att oavklarade objekt visas först
    private var sortedTodoItems: [TodoItem] {
        todoItems.sorted { !$0.isCompleted && $1.isCompleted }
    }
    
    var body: some View {
        VStack {
            // Textfält för att lägga till ny uppgift
            HStack {
                TextField("Ny uppgift", text: $newTodoTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: addTodo) {
                    Text("Lägg till")
                }
            }
            .padding()
            
            // Visa uppgifter i en sorterad lista
            List {
                ForEach(sortedTodoItems) { item in
                    HStack {
                        Text(item.title)
                        Spacer()
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.isCompleted ? .green : .gray)
                    }
                    .contentShape(Rectangle()) // Gör hela raden klickbar
                    .onTapGesture {
                        toggleCompletion(for: item)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Att-göra lista")
    }

    
    
    private func addTodo() {
        guard !newTodoTitle.isEmpty else { return }
        let newTodo = TodoItem(title: newTodoTitle)
        
        // Lägg till i databas och återställ textfält
        do {
            modelContext.insert(newTodo)
            try modelContext.save()
            newTodoTitle = ""
        } catch {
            print("Kunde inte lägga till uppgift: \(error)")
        }
    }
    
    private func toggleCompletion(for item: TodoItem) {
        // Ändra uppgiftens status
        item.isCompleted.toggle()
        
        // Försök spara ändringen
        do {
            try modelContext.save()
        } catch {
            print("Kunde inte spara ändring: \(error)")
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        // Ta bort markerade objekt
        for index in offsets {
            let item = sortedTodoItems[index]
            modelContext.delete(item)
        }
        
        // Försök spara ändringen
        do {
            try modelContext.save()
        } catch {
            print("Kunde inte ta bort uppgift(er): \(error)")
        }
    }
}
