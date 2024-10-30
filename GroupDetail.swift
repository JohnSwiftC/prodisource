//
//  GroupDetail.swift
//  Prodictiv0
//
//  Created by Erin Swift on 3/22/24.
//

import SwiftUI

struct GroupDetail: View {
    @Binding var group: Group
    @State private var emptyGoalList: [Goal] = []
    @State private var goalListChanged: Bool = false
    @State private var addNewGoalIsShowing: Bool = false
    @State private var newGoalText: String = ""
    @State private var editGoalNameShowing: Bool = false
    @State private var newGroupNameBuf: String = ""
    
    @State private var groupNameChanged: Bool = false
    
    @State private var newTheme: Theme = .bubblegum
    @State private var themeChanged: Bool = false
    

    
    func delete(at offsets: IndexSet) {
        emptyGoalList.remove(atOffsets: offsets)
        group.goals = emptyGoalList
    }
    
    var body: some View {
        
        NavigationStack {
            
            
            VStack {
                
                List {
                    
                    Section(header: Text("Goals")) {
                        if group.goals.isEmpty {
                            Text("Add a goal to your group!")
                        }
                        ForEach($emptyGoalList, editActions: .all) { $goal in
                            
                            HStack {
                                Button(action: {
                                    goal.isCompleted.toggle()
                                }) {
                                    if(goal.isCompleted) {
                                        Image(systemName: "checkmark.circle.fill")
                                    } else {
                                        Image(systemName: "circle")
                                    }
                                }
                                
                                Text(goal.name)
                            }
                        
                        }
                        .onDelete(perform: delete)
                    }
                    
                    
                    Section(header: Text("Theme")) {
                        
                        NavigationLink(destination: ThemeSelectorView(group: $group, newTheme: $newTheme, themeUpdated: $themeChanged)) {
                            ThemeView(theme: group.theme)
                        }

                    }
                    
                }
                .id(UUID())
                .toolbar {
                    
                    Button(action: {editGoalNameShowing = true}) {
                        Image(systemName: "pencil")
                    }
                    
                    Button(action: {addNewGoalIsShowing = true}) {
                        Image(systemName: "plus")
                    }
                    
                    
                
            }
            .navigationTitle(group.name)
                
            }
        
        }
        .onDisappear() {
            group.goals = emptyGoalList
            
        }
        .onAppear() {
            
            newGroupNameBuf = group.name
        
            
            if goalListChanged == true {
                group.goals = emptyGoalList
                goalListChanged = false
            } else {
                emptyGoalList = group.goals
            }
            
            if(themeChanged) {
                group.theme = newTheme
                themeChanged = false
            }
            
            newTheme = group.theme
        }
        .sheet(isPresented: $addNewGoalIsShowing) {
            NavigationStack {
                List {
                    TextField("Goal", text: $newGoalText, axis: .vertical)
                        

                }
                .toolbar {
                    ToolbarItem(placement:.confirmationAction) {
                        Button("Add Goal") {
                            addNewGoalIsShowing = false
                            group.goals.append(Goal(newGoalText))
                            emptyGoalList = group.goals
                            newGoalText = ""
                            
                        }
                        .disabled(newGoalText.isEmpty)
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            newGoalText = ""
                        
                            addNewGoalIsShowing = false
                        }
                    }
                }
            }
            
            
        }
        .sheet(isPresented: $editGoalNameShowing) {
            NavigationStack {
                List {
                    TextField("Group Title", text: $newGroupNameBuf, axis: .vertical)
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Finish") {
                            group.name = newGroupNameBuf;
                            editGoalNameShowing = false;
                        }
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            editGoalNameShowing = false;
                            newGroupNameBuf = group.name;
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    GroupDetail(group: .constant(Group.sampleGoals[0]))
}
