//
//  Goal.swift
//  Prodictiv0
//
//  Created by Erin Swift on 3/21/24.
//

import SwiftUI

struct Group: Identifiable, Codable {
    let id: UUID
    var name: String
    let timeFrame: String
    var goals: [Goal];
    var theme: Theme
    
    
    init(id: UUID = UUID(), name: String, timeFrame: String, goals: [Goal], theme: Theme = .buttercup) {
        self.id = id
        self.name = name
        self.timeFrame = timeFrame
        self.goals = goals
        self.theme = theme
    }
    
}

extension Group {
    static var emptyGoal: Group {
        Group(name: "", timeFrame: "", goals: [])
    }
}

extension Group {
    static var sampleGoals: [Group] {
        [
            Group(name: "Test Group", timeFrame: "Within 6 days", goals: [Goal("Kill People"), Goal("Have fun")], theme: .buttercup),
            Group(name: "Ballz", timeFrame: "Within 6 days", goals: [], theme: .oxblood),
            Group(name: "Get females", timeFrame: "Within 6 days", goals: []),
            Group(name: "Example", timeFrame: "Within 6 days", goals: []),
            Group(name: "Remove myself from incarceration", timeFrame: "Within 6 days", goals: []),
            Group(name: "Get into college", timeFrame: "Within 6 days", goals: []),
            Group(name: "Stack bread", timeFrame: "Within 6 days", goals: [])
        ]
    }
}
