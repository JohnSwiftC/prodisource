//
//  ContentView.swift
//  Prodictiv0
//
//  Created by Erin Swift on 3/21/24.
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct GroupView: View {
    @State private var emptyGroup: Group = Group(name: "", timeFrame: "", goals: [], theme: .buttercup)
    @State private var createNewGroup: Bool = false
    @Binding var groups: [Group]
    @Environment(\.scenePhase) private var scenePhase
    
    @Binding var blockedApps: FamilyActivitySelection
    @State private var familySelectorShowing: Bool = false
    
    @Binding var settings: ManagedSettingsStore
    
    @Binding var familyAuthorized: Bool
    
    @State private var focusEnabled: Bool = false

    let saveAction: ()->Void
    var body: some View {
        NavigationStack {
            VStack {
                
                                
                List() {
                
                    Section(header: Text("Focus")) {
                        NavigationLink(destination: FocusSessionView(groups: $groups, settings: $settings, blockedApps: $blockedApps, focusEnabled: $focusEnabled)) {
                            Label("Focus Session", systemImage: "clock")
                        }
                        .disabled(familyAuthorized ? false : true)
                        
                        Button(action: {familySelectorShowing = true}) {
                            Label("Set Blocked Apps", systemImage: "gear")
                        }
                        .disabled(focusEnabled ? true : false)
                        
                        if(!familyAuthorized) {
                            Text("Enable screen time in settings to use focus.")
                        } 
                    
                    }
                    
                    Section(header: Text("Groups")) {
                        
                        if groups.isEmpty {
                            Text("Add a group to get started!")
                        }
                        
                        ForEach($groups, editActions: .all) { $group in
                            NavigationLink(destination: GroupDetail(group: $group)) {
                                GroupCard(group: $group)
                        }
                            .listRowBackground(group.theme.mainColor)
                            
                        }
                        .frame(minWidth: 34)
                    .listRowSeparatorTint(.black)
                    }
                    
                    
                }
                .toolbar {
                    Button(action: {createNewGroup = true}) {
                        Image(systemName: "plus")
                    }
                }
                .listStyle(.insetGrouped)
            
            
                
            }
            .navigationTitle("Welcome Back")
            
        }
        .onAppear(perform: {
            if (settings.shield.applications == nil || settings.shield.applications?.count == 0){
                
                focusEnabled = false
                    
            } else {
                
                focusEnabled = true
                
            }
            
        })
    
        
        
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
        .familyActivityPicker(isPresented: $familySelectorShowing, selection: $blockedApps)

        .sheet(isPresented: $createNewGroup) {
            NavigationStack {
                List {
                    
                    Section(header: Text("Details")) {
                        TextField("Group Name", text: $emptyGroup.name)
                    }
                    
                    Section(header: Text("Theme")){
                        Picker("Theme", selection: $emptyGroup.theme) {
                            ForEach(Theme.allCases) { theme in
                                ThemeView(theme: theme)
                                    .tag(theme)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", action: {
                            groups.append(emptyGroup)
                            emptyGroup = Group(name: "", timeFrame: "", goals: [], theme: .buttercup)
                            createNewGroup = false
                        })
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: {
                            createNewGroup = false
                        })
                    }
            }
            }
        }
        
        
            
        

    }
        
}

#Preview {
    GroupView(groups: .constant(Group.sampleGoals), blockedApps: .constant(FamilyActivitySelection()), settings: .constant(ManagedSettingsStore()), familyAuthorized: .constant(true), saveAction: {})
}
