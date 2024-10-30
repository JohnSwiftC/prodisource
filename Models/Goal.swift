//
//  Goal.swift
//  Prodictiv0
//
//  Created by Erin Swift on 3/22/24.
//

import Foundation

struct Goal: Identifiable, Codable {
    let id: UUID
    var name: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), _ name: String, _ isCompleted: Bool = false) {
        self.id = id
        self.name = name
        self.isCompleted = isCompleted
    }
}

extension Goal {
    static var emptyGoal: Goal {
        Goal("")
    }
}
