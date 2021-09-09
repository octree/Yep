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
        case string
        
        var title: String {
            switch self {
            case .image:
                return "Image Assets"
            case .color:
                return "Color Assets"
            case .string:
                return "I18n Assets"
            }
        }
    }
    var name: String
    var type: Type
}

extension Asset {
    func initializer(assetName: String, isSPM: Bool, useSwiftUI: Bool) -> String {
        switch type {
        case .string:
            if isSPM {
                return #"NSLocalizedString("\#(assetName)", tableName: nil, bundle: .module, comment: "")"#
            } else {
                return #"NSLocalizedString("\#(assetName)")", comment: "")"#
            }
        case .image:
            if isSPM {
                return useSwiftUI ? #"Image("\#(assetName)", bundle: nil)"# : #"UIImage(named: "\#(assetName)", in: .module, compatibleWith: nil)!"#
            } else {
                return useSwiftUI ? #"Color("\#(assetName)")"# : #"UIColor(named: "\#(assetName)")!"#
            }
        case .color:
            if isSPM {
                return useSwiftUI ? #"Color("\#(assetName)", bundle: nil)"# : #"UIColor(named: "\#(assetName)", in: .module, compatibleWith: nil)!"#
            } else {
                return useSwiftUI ? #"Image("\#(assetName)")"# : #"UIImage(named: "\#(assetName)")!"#
            }
        }
    }
}

extension Asset {
    func returnType(useSwiftUI: Bool) -> String {
        switch type {
        case .string:
           return "String"
        case .image:
            return useSwiftUI ? "Image" : "UIImage"
        case .color:
            return useSwiftUI ? "Color" : "UIColor"
        }
    }
}

extension Asset {
    private var variableName: String {
        return name.split { "_-. ".contains($0) }.map { String($0).capitalizingFirstLetter }.joined().lowercasedFirstLetter
    }
    
    func generateCode(indentation: String,
                      namespace: String,
                      useSwiftUI: Bool = false,
                      isSPM: Bool = false,
                      separator: String = "/") -> String {
        let assetName = namespace.count > 0 ? namespace + separator + name : name
        let type = returnType(useSwiftUI: useSwiftUI)
        let initializer = initializer(assetName: assetName, isSPM: isSPM, useSwiftUI: useSwiftUI)
        return """
        \(indentation)static public var \(variableName): \(type) {
        \(indentation)    return \(initializer)
        \(indentation)}
        """
    }
}


extension Asset: Comparable {
    static func < (lhs: Asset, rhs: Asset) -> Bool {
        return lhs.name < rhs.name
    }
}


extension Asset: CustomStringConvertible {
    var description: String {
        """
        \(name)
        """
    }
}
