import Foundation

public extension LogEntry.Category {
    static let verbose = Self("🗯", "Verbose")
    static let debug = Self("🔹", "Debug")
    static let info = Self("ℹ️", "Info")
    static let notice = Self("✳️", "Notice")
    static let warning = Self("⚠️", "Warning")
    static let error = Self("💥", "Error")
    static let severe = Self("💣", "Severe")
    static let alert = Self("‼️", "Alert")
    static let emergency = Self("🚨", "Emergency")
}

public extension LogEntry {
    /// A structure that represents a log entry category with an optional emoji and a debug name.
    ///
    /// It provides computed properties for representing the emoji as a string and for creating a display name by combining the emoji (if available) with the debug name.
    struct Category: Hashable, Sendable {
        /// An optional emoji associated with this log entry category.
        public let emoji: Character?
        /// A string identifier used for debugging and identifying the log entry category.
        public let name: String
        
        /// Initializes a new log entry category with the given debug name.
        ///
        /// - Parameter name: A string identifier for the category.
        public init(_ name: String) {
            self.emoji = nil
            self.name = name
        }
        
        /// Initializes a new log entry category with the given emoji and debug name.
        ///
        /// - Parameters:
        ///   - emoji: An emoji representing the category.
        ///   - name: A string identifier for the category.
        public init(_ emoji: Character, _ name: String) {
            self.emoji = emoji
            self.name = name
        }
    }
}

extension LogEntry.Category: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension LogEntry.Category: Comparable {
    public static func < (lhs: LogEntry.Category, rhs: LogEntry.Category) -> Bool {
        lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
    }
}

extension LogEntry.Category: CustomStringConvertible {
    public var description: String {
        if let emoji {
            "\(emoji) \(name)"
        } else {
            name
        }
    }
}

extension LogEntry.Category: FilterConvertible {
    package static var filterKind: Filter.Kind { .category }
    package static var filterDisplayName: KeyPath<LogEntry.Category, String> { \.description }
    package static var filterQuery: KeyPath<LogEntry.Category, String> { \.name }
}
