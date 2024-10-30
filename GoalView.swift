//
//  GoalView.swift
//  Prodictiv0
//
//  Created by Erin Swift on 6/29/24.
//

import SwiftUI

struct GoalView: View {
    @Binding var goal: Goal
    @State private var buttonText: String = ""
    @Binding var goalListChanged: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                List{
                    Section(header: Text("Your Goal")) {
                        TextField(goal.name, text: $goal.name, axis: .vertical)
                    }
                }
            Spacer()
                Button(action: {if(goal.isCompleted) {goal.isCompleted = false; buttonText = "Mark goal complete"} else {goal.isCompleted = true; buttonText = "Mark goal incomplete"}
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(maxHeight: 70)
                            .padding()
                        Text("\(buttonText)")
                            .foregroundStyle(Color(.white))
                            .font(.title)
                    }
                }
            }
        }
        .navigationTitle("Your goal")
        .onAppear() {
            if(goal.isCompleted) {
                buttonText = "Mark goal incomplete"
            } else {
                buttonText = "Mark goal complete"
            }
            goalListChanged = true
        }
        .onDisappear() {
            goalListChanged = true
        }
    }

}

#Preview {
    GoalView(goal: .constant(Group.sampleGoals[0].goals[0]), goalListChanged: .constant(false))
}
