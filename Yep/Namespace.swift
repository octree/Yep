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
        return assets.count == 0 && sub.count == 0
    }
    
    init(name: String, assets: [Asset] = [], sub: [Namespace] = []) {
        self.name = name
        self.assets = assets
        self.sub = sub
    }
}

extension Namespace {
    
    func generateCode(namespace: String = "", indentation: String = "") -> String {
        let fullNamespace = isRoot ? "" : (namespace.count > 0 ? namespace + "/" + name : name)
        
        var codes = [String]()
        if assets.count > 0 {
            codes.append(assets.map { $0.generateCode(indentation: indentation + "    ", namespace: fullNamespace) }.joined(separator: "\n\n"))
        }
        
        if sub.count > 0 {
            codes.append(sub.map { $0.generateCode(namespace: fullNamespace, indentation: indentation + "    ") }.joined(separator: "\n\n"))
        }
        
        return """
        \(indentation)// MARK: - \(name)
        \(indentation)struct \(name) {
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
