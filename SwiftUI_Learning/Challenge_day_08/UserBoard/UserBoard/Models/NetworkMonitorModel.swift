//
//  NetworkMonitorModel.swift
//  UserBoard
//
//  Created by D F on 7/13/25.
//

import Foundation
import Network
import Observation

@Observable
class NetworkMonitorModel{
    var isConnected: Bool = true
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorModel")
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}

