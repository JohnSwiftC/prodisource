import SwiftUI
import FamilyControls


class GroupSaveVault: ObservableObject {
    
    @Published var groups: [Group] = []
    @Published var blockedApps: FamilyActivitySelection = FamilyActivitySelection(includeEntireCategory: true)


    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("groups.data")
    }
    
    private static func fileURLBlocker() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("blockedapps.data")
    }


    func load() async throws {
        let task = Task<[Group], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let dailyScrums = try JSONDecoder().decode([Group].self, from: data)
            return dailyScrums
        }
        let groups = try await task.value
        await MainActor.run {
            self.groups = groups
        }
        
        let blockedAppTask = Task<FamilyActivitySelection, Error> {
            let fileURL = try Self.fileURLBlocker()
            guard let data = try? Data(contentsOf: fileURL) else {
                return FamilyActivitySelection()
            }
            let blockedAppTemp = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
            return blockedAppTemp
        }
        
        let blockedAppTemp1 = try await blockedAppTask.value
        await MainActor.run {
            self.blockedApps = blockedAppTemp1
        }
    }


    func save(groups: [Group], blockedApps: FamilyActivitySelection) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(groups)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
            
            let blockData = try JSONEncoder().encode(blockedApps)
            let blockOutfile = try Self.fileURLBlocker()
            try blockData.write(to: blockOutfile)
        }
        _ = try await task.value
    }
}
