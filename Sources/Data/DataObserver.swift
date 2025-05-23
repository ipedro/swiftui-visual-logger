// MIT License
//
// Copyright (c) 2025 Pedro Almeida
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Combine
import Models
import SwiftUI

package final class DataObserver: @unchecked Sendable {
    /// A published array of custom actions.
    let customActions: CurrentValueSubject<[VisualLoggerAction], Never>

    /// A published array of log entry IDs from the data store.
    let allEntries: CurrentValueSubject<[LogEntryID], Never>

    /// An array holding all log entry categories present in the store.
    let allCategories: CurrentValueSubject<[LogEntryCategory], Never>

    /// An array holding all log entry sources present in the store.
    let allSources: CurrentValueSubject<[LogEntrySource], Never>

    /// A dictionary mapping log entry IDs to their corresponding source.
    let entrySources: CurrentValueSubject<[LogEntryID: LogEntrySource], Never>

    /// A dictionary mapping log entry IDs to their corresponding category.
    private(set) var entryCategories: [LogEntryID: LogEntryCategory]

    /// A dictionary mapping log entry IDs to their corresponding content.
    private(set) var entryContents: [LogEntryID: LogEntryContent]

    /// A dictionary mapping log entry IDs to their corresponding userInfo keys.
    private(set) var entryUserInfoKeys = [LogEntryID: [LogEntryUserInfoKey]]()

    /// A dictionary mapping log entry IDs to their corresponding userInfo values.
    private(set) var entryUserInfoValues = [LogEntryUserInfoKey: String]()

    /// A dictionary mapping log source IDs to their corresponding color.
    private(set) var sourceColors = [LogEntrySource.ID: DynamicColor]()

    package init(
        allCategories: [LogEntryCategory] = [],
        allEntries: [LogEntryID] = [],
        allSources: [LogEntrySource] = [],
        customActions: [VisualLoggerAction] = [],
        entryCategories: [LogEntryID: LogEntryCategory] = [:],
        entryContents: [LogEntryID: LogEntryContent] = [:],
        entrySources: [LogEntryID: LogEntrySource] = [:],
        entryUserInfos: [LogEntryID: LogEntryUserInfo?] = [:],
        sourceColors: [LogEntrySource.ID: DynamicColor] = [:]
    ) {
        self.allCategories = CurrentValueSubject(allCategories)
        self.allEntries = CurrentValueSubject(allEntries)
        self.allSources = CurrentValueSubject(allSources)
        self.customActions = CurrentValueSubject(customActions)
        self.entryCategories = entryCategories
        self.entryContents = entryContents
        self.entrySources = CurrentValueSubject(entrySources)
        self.sourceColors = sourceColors

        for (id, userInfo) in entryUserInfos {
            guard let (keys, values) = userInfo?.denormalize(id: id) else {
                continue
            }
            entryUserInfoKeys[id] = keys
            for (key, value) in values {
                entryUserInfoValues[key] = value
            }
        }
    }

    func updateValues(
        allCategories: [LogEntryCategory],
        allEntries: [LogEntryID],
        allSources: [LogEntrySource],
        customActions: [VisualLoggerAction],
        entryCategories: [LogEntryID: LogEntryCategory],
        entryContents: [LogEntryID: LogEntryContent],
        entrySources: [LogEntryID: LogEntrySource],
        entryUserInfoKeys: [LogEntryID: [LogEntryUserInfoKey]],
        entryUserInfoValues: [LogEntryUserInfoKey: String],
        sourceColors: [LogEntrySource.ID: DynamicColor]
    ) {
        defer {
            self.allSources.send(allSources)
            self.allCategories.send(allCategories)
            self.customActions.send(customActions)
            self.entrySources.send(entrySources)

            // push update to entries as last step
            self.allEntries.send(allEntries)
        }

        self.entryCategories = entryCategories
        self.entryContents = entryContents
        self.entryUserInfoKeys = entryUserInfoKeys
        self.entryUserInfoValues = entryUserInfoValues
        self.sourceColors = sourceColors
    }
}
