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

import Models
import SwiftUI

struct LogEntryHeaderView: View {
    let source: LogEntrySource
    let category: String
    let createdAt: Date

    @Environment(\.spacing)
    private var spacing

    var body: some View {
        let _ = Self._debugPrintChanges()
        HStack(spacing: spacing / 2) {
            Text(category)
                .foregroundStyle(.primary)

            Image(systemName: "chevron.forward")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)

            LogEntrySourceView(data: source)
                .foregroundStyle(.tint)

            Spacer()

            Text(createdAt, style: .time)
        }
        .foregroundStyle(.secondary)
        .overlay(alignment: .leading) {
            Circle()
                .fill(.tint)
                .frame(width: spacing * 0.75)
                .offset(x: -spacing * 1.25)
        }
        .font(.footnote)
    }
}

@available(iOS 17, *)
#Preview(traits: .sizeThatFitsLayout) {
    LogEntryHeaderView(
        source: "Source",
        category: "Category",
        createdAt: Date()
    )
    .padding()
}
