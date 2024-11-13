//
//  TODOItem.swift
//  TODO
//
//  Created by Meri Stakovska on 2024-11-09.
//

import Foundation
import SwiftData

@Model
class TodoItem {
    @Attribute(.unique) var id: UUID = UUID()
    var title: String
    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
}
