//
//  Asset.swift
//  Yep
//
//  Created by Octree on 2019/7/4.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation

struct Asset {
    enum `Type` {
        case image
        case color
        
        var title: String {
            switch self {
            case .image:
                return "Images"
            case .color:
                return "Colors"
            }
        }
    }
    var name: String
    var type: Type
}

extension Asset {
    private var variableName: String {
        return name.split { "_-. ".contains($0) }.map { String($0).capitalizingFirstLetter() }.joined().lowercaseFirstLetter()
    }
    
    func generateCode(indentation: String, namespace: String, useSwiftUI: Bool = false) -> String {
        let assetName = namespace.count > 0 ? namespace + "/" + name : name
        switch type {
        case .color:
            let type = useSwiftUI ? "Color" : "UIColor"
            let initializer = useSwiftUI ? #"Color("\#(assetName)")"# : #"UIColor(named: "\#(assetName)")!"#
            return """
            \(indentation)@inline(__always) static var \(variableName): \(type) {
            \(indentation)    return \(initializer)
            \(indentation)}
            """
        case .image:
            let type = useSwiftUI ? "Image" : "UIImage"
            let initializer = useSwiftUI ? #"Image("\#(assetName)")"# : #"UIImage(named: "\#(assetName)")!"#
            return """
            \(indentation)@inline(__always) static var \(variableName): \(type) {
            \(indentation)    return \(initializer)
            \(indentation)}
            """
        }
    }
}


extension Asset: Comparable {
    static func < (lhs: Asset, rhs: Asset) -> Bool {
        return lhs.name < rhs.name
    }
}
