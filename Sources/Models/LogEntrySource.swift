//  Copyright (c) 2022 Pedro Almeida
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import struct SwiftUICore.Color

package typealias Source = LogEntry.Source

public extension LogEntry {
    struct Source: Hashable, Identifiable, Sendable {
        public var id: String { name }
        public let emoji: Character?
        public let name: String
        public let info: SourceInfo?
        
        public init(
            _ name: String,
            _ info: SourceInfo? = .none
        ) {
            self.emoji = nil
            self.info = info
            self.name = Self.cleanName(name)
        }
        
        public init(
            _ emoji: Character,
            _ name: String,
            _ info: SourceInfo? = .none
        ) {
            self.emoji = emoji
            self.info = info
            self.name = Self.cleanName(name)
        }
        
        package init(_ source: some LogEntrySource) {
            emoji = source.logEntryEmoji
            info = source.logEntryInfo
            name = Self.cleanName(source.logEntryName)
        }
        
        private static func cleanName(_ name: String) -> String {
            if name.hasSuffix(".swift") {
                name.replacingOccurrences(of: ".swift", with: "")
            } else {
                name
            }
        }
    }
}

extension LogEntry.Source: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension LogEntry.Source: Comparable {
    public static func < (lhs: LogEntry.Source, rhs: LogEntry.Source) -> Bool {
        lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
    }
}

extension LogEntry.Source: CustomStringConvertible {
    public var description: String {
        if let emoji {
            "\(emoji) \(name)"
        } else {
            name
        }
    }
}

extension LogEntry.Source: FilterConvertible {
    package static var filterKind: Filter.Kind { .source }
    package static var filterDisplayName: KeyPath<LogEntry.Source, String> { \.description }
    package static var filterQuery: KeyPath<LogEntry.Source, String> { \.name }
}
