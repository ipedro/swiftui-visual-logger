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

import SwiftUI

/// A type that defines the closure for an action handler.
public typealias VisualLoggerActionHandler = @MainActor (_ action: VisualLoggerAction) -> Void

/// A type that defines the closure for a asynchronous action handler.
public typealias VisualLoggerActionAsyncHandler = @Sendable (_ action: VisualLoggerAction) async -> Void

/// A value that describes the purpose of an action.
public enum VisualLoggerActionRole {
    /// A role that indicates a regular action.
    case regular
    /// A role that indicates a destructive action.
    case destructive
}

// MARK: - Sync API

public extension VisualLoggerAction {
    /// Initializes a new `VisualLoggerAction` with an optional identifier, a title, a role, an optional image, and an action handler.
    ///
    /// If `id` is omitted, the title will be used as the identifier.
    ///
    /// - Parameters:
    ///   - id: An optional identifier for the action. If `nil`, the `title` is used as the identifier.
    ///   - title: A short display title for the action.
    ///   - role: The role for the action, which determines its styling. Defaults to `.regular`.
    ///   - image: An optional `Image` to display alongside the title.
    ///   - handler: A closure that defines the action to perform when this action is executed.
    ///
    /// **Example:**
    /// ```swift
    /// let action = VisualLoggerAction(title: "Refresh Logs", role: .regular, image: Image(systemName: "arrow.clockwise")) { action in
    ///     // Handle refresh action
    /// }
    /// ```
    init(
        id: String? = nil,
        title: String,
        role: VisualLoggerActionRole = .regular,
        image: Image? = nil,
        handler: @escaping VisualLoggerActionHandler
    ) {
        self.id = id ?? title
        self.title = title
        self.image = image
        self.handler = handler
        self.role = switch role {
        case .regular:
            nil
        case .destructive:
            .destructive
        }
    }

    /// Initializes a new `VisualLoggerAction` using a system image name.
    ///
    /// This initializer creates a new instance with an image generated from the provided system image name.
    /// If `id` is omitted, the `title` is used as the identifier.
    ///
    /// - Parameters:
    ///   - id: An optional identifier for the action. If `nil`, the `title` is used as the identifier.
    ///   - title: A short display title for the action.
    ///   - role: The role for the action, which determines its styling. Defaults to `.regular`.
    ///   - systemImage: A string representing the name of the system image to display.
    ///   - handler: A closure that defines the action to perform when this action is executed.
    ///
    /// **Example:**
    /// ```swift
    /// let action = VisualLoggerAction(title: "Delete", role: .destructive, systemImage: "trash") { action in
    ///     // Handle delete action
    /// }
    /// ```
    init(
        id: String? = nil,
        title: String,
        role: VisualLoggerActionRole = .regular,
        systemImage: String,
        handler: @escaping VisualLoggerActionHandler
    ) {
        self.init(
            id: id,
            title: title,
            role: role,
            image: Image(systemName: systemImage),
            handler: handler
        )
    }

    /// Initializes a new `VisualLoggerAction` using a `UIImage`.
    ///
    /// This initializer allows the creation of an action with a `UIImage`. It converts the `UIImage` into a SwiftUI `Image` internally.
    /// If `id` is omitted, the `title` is used as the identifier.
    ///
    /// - Parameters:
    ///   - id: An optional identifier for the action. If `nil`, the `title` is used as the identifier.
    ///   - title: A short display title for the action.
    ///   - role: The role for the action, which determines its styling. Defaults to `.regular`.
    ///   - image: An optional `UIImage` to display alongside the title.
    ///   - handler: A closure that defines the action to perform when this action is executed.
    ///
    /// **Example:**
    /// ```swift
    /// let uiImage = UIImage(named: "customIcon")
    /// let action = VisualLoggerAction(title: "Custom Action", role: .regular, image: uiImage) { action in
    ///     // Handle custom action
    /// }
    /// ```
    @_disfavoredOverload
    init(
        id: String? = nil,
        title: String,
        role: VisualLoggerActionRole = .regular,
        image: UIImage? = nil,
        handler: @escaping VisualLoggerActionHandler
    ) {
        self.init(
            id: id,
            title: title,
            role: role,
            image: {
                if let image {
                    Image(uiImage: image)
                } else {
                    nil
                }
            }(),
            handler: handler
        )
    }
}

// MARK: - Async API

public extension VisualLoggerAction {
    /// Initializes a new `VisualLoggerAction` with an optional identifier, a title, a role, an optional image, and an action handler.
    ///
    /// If `id` is omitted, the title will be used as the identifier.
    ///
    /// - Parameters:
    ///   - id: An optional identifier for the action. If `nil`, the `title` is used as the identifier.
    ///   - title: A short display title for the action.
    ///   - role: The role for the action, which determines its styling. Defaults to `.regular`.
    ///   - image: An optional `Image` to display alongside the title.
    ///   - handler: A closure that defines the action to perform when this action is executed.
    ///
    /// **Example:**
    /// ```swift
    /// let action = VisualLoggerAction(title: "Refresh Logs", role: .regular, image: Image(systemName: "arrow.clockwise")) { action in
    ///     // Handle refresh action
    /// }
    /// ```
    init(
        id: String? = nil,
        title: String,
        role: VisualLoggerActionRole = .regular,
        image: Image? = nil,
        handler: @escaping VisualLoggerActionAsyncHandler
    ) {
        self.id = id ?? title
        self.title = title
        self.image = image
        self.handler = handler
        self.role = switch role {
        case .regular:
            nil
        case .destructive:
            .destructive
        }
    }

    /// Initializes a new `VisualLoggerAction` using a system image name.
    ///
    /// This initializer creates a new instance with an image generated from the provided system image name.
    /// If `id` is omitted, the `title` is used as the identifier.
    ///
    /// - Parameters:
    ///   - id: An optional identifier for the action. If `nil`, the `title` is used as the identifier.
    ///   - title: A short display title for the action.
    ///   - role: The role for the action, which determines its styling. Defaults to `.regular`.
    ///   - systemImage: A string representing the name of the system image to display.
    ///   - handler: A closure that defines the action to perform when this action is executed.
    ///
    /// **Example:**
    /// ```swift
    /// let action = VisualLoggerAction(title: "Delete", role: .destructive, systemImage: "trash") { action in
    ///     // Handle delete action
    /// }
    /// ```
    init(
        id: String? = nil,
        title: String,
        role: VisualLoggerActionRole = .regular,
        systemImage: String,
        handler: @escaping VisualLoggerActionAsyncHandler
    ) {
        self.init(
            id: id,
            title: title,
            role: role,
            image: Image(systemName: systemImage),
            handler: handler
        )
    }

    /// Initializes a new `VisualLoggerAction` using a `UIImage`.
    ///
    /// This initializer allows the creation of an action with a `UIImage`. It converts the `UIImage` into a SwiftUI `Image` internally.
    /// If `id` is omitted, the `title` is used as the identifier.
    ///
    /// - Parameters:
    ///   - id: An optional identifier for the action. If `nil`, the `title` is used as the identifier.
    ///   - title: A short display title for the action.
    ///   - role: The role for the action, which determines its styling. Defaults to `.regular`.
    ///   - image: An optional `UIImage` to display alongside the title.
    ///   - handler: A closure that defines the action to perform when this action is executed.
    ///
    /// **Example:**
    /// ```swift
    /// let uiImage = UIImage(named: "customIcon")
    /// let action = VisualLoggerAction(title: "Custom Action", role: .regular, image: uiImage) { action in
    ///     // Handle custom action
    /// }
    /// ```
    @_disfavoredOverload
    init(
        id: String? = nil,
        title: String,
        role: VisualLoggerActionRole = .regular,
        image: UIImage? = nil,
        handler: @escaping VisualLoggerActionAsyncHandler
    ) {
        self.init(
            id: id,
            title: title,
            role: role,
            image: {
                if let image {
                    Image(uiImage: image)
                } else {
                    nil
                }
            }(),
            handler: handler
        )
    }
}

/// A menu element that performs its action in a closure.
///
/// Create a `VisualLoggerAction` object when you want to customize the `VisualLogger` with a menu element that performs its action in a closure.
public struct VisualLoggerAction: Identifiable, Sendable {
    /// This action's identifier.
    public let id: String

    /// Short display title.
    public let title: String

    /// Image that can appear next to this action.
    package let image: Image?

    /// The role of the action which determines its styling.
    package let role: ButtonRole?

    /// This action's handler.
    private let handler: VisualLoggerActionAsyncHandler

    package static let internalNamespace = "__VisualLogger"

    package func callAsFunction() async {
        await handler(self)
    }
}

extension VisualLoggerAction: Equatable {
    public static func == (lhs: VisualLoggerAction, rhs: VisualLoggerAction) -> Bool {
        lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.image == rhs.image
    }
}

extension VisualLoggerAction: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension VisualLoggerAction: Comparable {
    public static func < (lhs: VisualLoggerAction, rhs: VisualLoggerAction) -> Bool {
        let prefix = VisualLoggerAction.internalNamespace
        let lhsIsInternal = lhs.id.hasPrefix(prefix)
        let rhsIsInternal = rhs.id.hasPrefix(prefix)

        // If lhs is internal and rhs is not, lhs comes first.
        if lhsIsInternal, !rhsIsInternal {
            return true
        }
        // If rhs is internal and lhs is not, rhs comes first.
        if !lhsIsInternal, rhsIsInternal {
            return false
        }
        // Otherwise, fallback to standard comparison based on title.
        return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
    }
}
