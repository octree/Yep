//
//  Namespace.swift
//  Yep
//
//  Created by Octree on 2019/7/4.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation

class Namespace {
    var name: String
    var sub: [Namespace]
    var assets: [Asset]
    var isRoot: Bool = false

    var isEmpty: Bool {
        guard assets.isEmpty else {
            return false
        }
        return sub.allSatisfy { $0.isEmpty }
    }

    init(name: String, assets: [Asset] = [], sub: [Namespace] = []) {
        self.name = name
        self.assets = assets
        self.sub = sub
    }
}

extension Namespace {
    func generateCode(namespace: String = "",
                      indentation: String = "",
                      target: Target,
                      isSPM: Bool = false,
                      separator: String = "/",
                      keyOnly: Bool = false) -> String
    {
        let fullNamespace = isRoot ? "" : (!namespace.isEmpty ? namespace + separator + name : name)

        var codes = [String]()
        if !assets.isEmpty {
            codes.append(assets.map { $0.generateCode(indentation: indentation + "    ",
                                                      namespace: fullNamespace,
                                                      target: target,
                                                      isSPM: isSPM,
                                                      separator: separator,
                                                      keyOnly: keyOnly) }.joined(separator: "\n\n"))
        }

        if !sub.isEmpty {
            codes.append(sub.map { $0.generateCode(namespace: fullNamespace, indentation: indentation + "    ", target: target, isSPM: isSPM, separator: separator, keyOnly: keyOnly) }.joined(separator: "\n\n"))
        }

        return """
        \(indentation)// MARK: - \(name)

        \(indentation)public enum \(name) {
        \(codes.joined(separator: "\n\n"))
        \(indentation)}
        """
    }
}

extension Namespace: Comparable {
    static func == (lhs: Namespace, rhs: Namespace) -> Bool {
        return lhs.name == rhs.name
    }

    static func < (lhs: Namespace, rhs: Namespace) -> Bool {
        return lhs.name < rhs.name
    }
}

extension Namespace {
    func findOrCreateNamespace<S: RandomAccessCollection>(for pathComponents: S) -> Namespace where S.Element == String {
        guard let first = pathComponents.first else {
            return self
        }
        let namespace: Namespace
        if let node = sub.first(where: { $0.name == first }) {
            namespace = node
        } else {
            namespace = .init(name: first)
            sub.append(namespace)
        }
        return namespace.findOrCreateNamespace(for: pathComponents.dropFirst())
    }
}

extension Namespace: CustomStringConvertible {
    var description: String {
        """
        \(name)
            \(assets)
            \(sub)
        """
    }
}
