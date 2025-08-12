//
//  ProspectsView.swift
//  HotProspects
//
//  Created by D F on 8/12/25.
//

import SwiftUI
import SwiftData
import CodeScanner
import UserNotifications

enum FilterType {
    case none, contacted, uncontacted
}
enum SortOption:  String, CaseIterable, Identifiable {
    case name = "Name"
    case emailAddress = "Email Address"
    case contacted = "Contacted"
    
    var id: String { rawValue }
}

enum SortDirection {
    case ascending, descending
    
    mutating func toggle() {
        self = (self == .ascending) ? .descending : .ascending
    }
}


struct ProspectsView: View {
    @Query var allProspects: [ProspectModel]
    @Environment(\.modelContext) var modelContext
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<ProspectModel>()
    @State private var sortOption: SortOption = .name
    @State private var sortDirection: SortDirection = .ascending
    
    
    
    let filter: FilterType
    var title: String {
        switch filter {
        case .none:
            "All Prospects"
        case .contacted:
            "Contacted Prospects"
        case .uncontacted:
            "Uncontacted Prospects"
        }
    }
    
    var prospects: [ProspectModel] {
        let filtered = allProspects.filter { prospect in
            switch filter {
            case .none: return true
            case .contacted: return prospect.isContacted
            case .uncontacted: return !prospect.isContacted
            }
        }
        let sorted: [ProspectModel]
        
        switch sortOption {
        case .name:
            sorted = filtered.sorted {
                sortDirection == .ascending ? $0.name < $1.name : $0.name > $1.name
            }
        case .emailAddress:
            sorted = filtered.sorted {
                sortDirection == .ascending ? $0.emailAddress < $1.emailAddress : $0.emailAddress > $1.emailAddress
            }
            
        case .contacted:
            sorted = filtered.sorted {
                if $0.isContacted == $1.isContacted {
                    return false
                }
                // Always put contacted first regardless of direction
                return $0.isContacted && !$1.isContacted
            }
            
        }
        return sorted
    }
    
    var body: some View {
        NavigationStack {
            List(prospects, selection: $selectedProspects) { prospect in
                NavigationLink(destination:EditProspectView(prospect: prospect)) {
                    HStack {
                        VStack(alignment: .leading){
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: prospect.isContacted ? "checkmark.circle" : "questionmark.diamond")
                            .foregroundColor(prospect.isContacted ? .green : .red)
                        
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                                prospect.isContacted.toggle()
                            }
                            .tint(.blue)
                        } else {
                            Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                                prospect.isContacted.toggle()
                            }
                            .tint(.green)
                            
                            Button("Remind Me", systemImage: "bell") {
                                addNotification(for: prospect)
                            }
                            .tint(.orange)
                        }
                    }
                    .tag(prospect)
                }
            }
            .navigationTitle(title)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                    
                }
                
                ToolbarItem(placement: .automatic) {
                    Menu {
                        Picker("Sort by", selection: $sortOption) {
                            ForEach(SortOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                    }
                }
                
                if sortOption != .contacted {
                    ToolbarItem(placement: .automatic) {
                        Button {
                            sortDirection.toggle()
                        } label: {
                            Label("Sort Direction", systemImage: sortDirection == .ascending ? "arrow.up" : "arrow.down")
                        }
                    }
                }
                
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                if selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete Selected", action: delete)
                    }
                }
                
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Dee F\nDeeF@BayAreaApps.com", completion: handleScan)
            }
        }
        
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = ProspectModel(name: details[0], emailAddress: details[1], isContacted: false)
            
            modelContext.insert(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
        
    }
    
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
    
    func addNotification(for prospect: ProspectModel) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            //            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
    }
    
}

#Preview {
    ProspectsView(filter:.contacted)
        .modelContainer(for: ProspectModel.self)
}
