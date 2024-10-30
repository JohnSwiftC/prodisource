//
//  Prodictiv0App.swift
//  Prodictiv0
//
//  Created by Erin Swift on 3/21/24.
//

import SwiftUI
import FamilyControls
import ManagedSettings

@main
struct Prodictiv0App: App {
    @StateObject private var store = GroupSaveVault()
        
    @State private var settings: ManagedSettingsStore = ManagedSettingsStore()
    
    @State private var familyAuthorized: Bool = true
    
    let center = AuthorizationCenter.shared
    
    
    
    var body: some Scene {
        
        
        
        
        WindowGroup {
            GroupView(groups: $store.groups, blockedApps: $store.blockedApps, settings: $settings, familyAuthorized: $familyAuthorized) {
                Task {
                    do {
                        try await store.save(groups: store.groups, blockedApps: store.blockedApps)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
            .onAppear() {
                Task {
                    do {
                        try await center.requestAuthorization(for: FamilyControlsMember.individual)
                        familyAuthorized = true
                    } catch {
                        familyAuthorized = false
                    }
                }
            }
                .task {
                    do {
                        try await store.load()
                    } catch {
                        print("No data.")
                    }
                }
        }
    }
}
