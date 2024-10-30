//
//  GoalCard.swift
//  Prodictiv0
//
//  Created by Erin Swift on 3/21/24.
//

import SwiftUI

struct GroupCard: View {
    @Binding var group: Group
    
    var body: some View {
        ZStack {
            
            
            VStack(alignment: .leading) {
                HStack{
                    Text(group.name)
                        .font(.title)
                        .fontDesign(.monospaced)
                        
                    Spacer()
                    
                }
                
                Spacer()
                
    
                Label(group.goals.count == 1 ? "\(group.goals.count) goal" : "\(group.goals.count) goals", systemImage: "star.fill")
                    
                    
                    
            }
            .padding()
        }
        .foregroundColor(group.theme.accentColor)
    
        
        
        
    }
}

#Preview {
    GroupCard(group: .constant(Group.sampleGoals[0]))
}
