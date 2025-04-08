//
//  LogEntryID.swift
//  AppLogger
//
//  Created by Pedro Almeida on 08.04.25.
//

import struct Foundation.Date
import struct Foundation.TimeInterval
import struct Foundation.UUID

package typealias ID = LogEntry.ID

public extension LogEntry {
    struct ID: Hashable, Comparable, Sendable {
        private let rawValue = UUID()
        package let timestamp: TimeInterval = Date().timeIntervalSince1970
        
        public static func < (lhs: ID, rhs: ID) -> Bool {
            lhs.timestamp < rhs.timestamp
        }
    }
}
