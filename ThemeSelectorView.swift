//
//  ThemeSelectorView.swift
//  Prodictiv0
//
//  Created by Erin Swift on 7/1/24.
//

import SwiftUI

struct ThemeSelectorView: View {
    
    @Binding var group: Group
    @Binding var newTheme: Theme
    @Binding var themeUpdated: Bool
        
    var body: some View {
        NavigationStack {
            
                List {
                    Picker("Theme", selection: $newTheme) {
                        ForEach(Theme.allCases) { theme in
                            ThemeView(theme: theme)
                                .tag(theme)
                        }
                    }
                    
                    
                    .pickerStyle(.inline)
                }
            
            
        }
        .onAppear(perform: {themeUpdated = true})
        .onChange(of: newTheme) { newTheme in
            group.theme = newTheme
        }
        .navigationTitle("Theme")
    }
}

#Preview {
    ThemeSelectorView(group: .constant(Group.sampleGoals[0]), newTheme: .constant(.buttercup), themeUpdated: .constant(false))
}
