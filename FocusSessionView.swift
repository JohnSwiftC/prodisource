//
//  FocusSessionView.swift
//  Prodictiv0
//
//  Created by Erin Swift on 4/14/24.
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct FocusSessionView: View {
    
    @Binding var groups: [Group]
    @Binding var settings: ManagedSettingsStore
    @Binding var blockedApps: FamilyActivitySelection
    
    @State private var focusSessionText: String = ""
    @State private var buttonText: String = ""
    @Binding var focusEnabled: Bool
    @State private var boxHeight: Double = 0
    
    
    var body: some View {
        
        
        VStack {
            
            Spacer()
            Text("\(focusSessionText)")
                .font(.title)
                .frame(alignment: .center)
                .padding(.horizontal, 60)
                .multilineTextAlignment(.center)
            
            
            
            if(groups.count > 0 && (focusEnabled || boxHeight > 0)) {
                
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            
        
                            
                            .foregroundStyle(Color(groups[0].theme.rawValue))
                            
                        GroupCard(group: $groups[0])
                            
                        
                    }
                    .frame(maxHeight: boxHeight)
                    
                    .padding()
            
            }
            
                
                
            Spacer()
            Button(action: {
                if settings.shield.applications == nil {
                    settings.shield.applications = blockedApps.applicationTokens
                    settings.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(blockedApps.categoryTokens)
                    if(groups.count > 0) {
                        focusSessionText = "Focus is enabled! Try working on"
                        
                        focusEnabled = true
                        
                        
                    } else {
                        focusSessionText = "Focus is enabled."
                        
                        focusEnabled = true
                    }
                    withAnimation {
                        boxHeight += 200
                    }
                    buttonText = "Stop Focus Session"
                } else {
                    settings.shield.applications = nil
                    settings.shield.applicationCategories = nil
                    focusSessionText = "Focus is disabled."
                    buttonText = "Start Focus Session"
                    focusEnabled = false
                    
                    withAnimation {
                        boxHeight -= 200
                    }
                }
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
            .disabled(blockedApps.applicationTokens.isEmpty && blockedApps.categories.isEmpty)
            
        }
        .onAppear(perform: {
            if(!blockedApps.applicationTokens.isEmpty || !blockedApps.categories.isEmpty) {
                if ((settings.shield.applications == nil || settings.shield.applications?.count == 0) && (settings.shield.applicationCategories == nil)){
                    
                    focusSessionText = "Focus is disabled."
                    
                    buttonText = "Start Focus Session"
                    focusEnabled = false
                    
                    boxHeight = 0
                    
                } else {
                    if(groups.count > 0) {
                        focusSessionText = "Focus is enabled, try working on"
                        focusEnabled = true
                    } else {
                        focusSessionText = "Focus is enabled."
                        focusEnabled = true
                    }
                    
                    boxHeight = 200
                    buttonText = "Stop Focus Session"
                }
            } else {
                focusSessionText = "Set blocked apps before you enable focus!"
            }
        })
        
    }
    
}

#Preview {
    FocusSessionView(groups: .constant(Group.sampleGoals), settings: .constant(ManagedSettingsStore()), blockedApps: .constant(FamilyActivitySelection()), focusEnabled: .constant(true))
}
