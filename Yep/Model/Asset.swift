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
    func initializer(assetName: String, isSPM: Bool, target: Target) -> String {
        switch (type, isSPM, target) {
        case (.string, true, _):
            return #"NSLocalizedString("\#(assetName)", tableName: nil, bundle: .module, comment: "")"#
        case (.string, false, _):
            return #"NSLocalizedString("\#(assetName)")", comment: "")"#

        case (.image, true, .appKit):
            return #"Bundle.module.image(forResource: "\#(assetName)")!"#
        case (.image, false, .appKit):
            return #"NSImage(named: "\#(assetName)")!"#

        case (.image, true, .uiKit):
            return #"UIImage(named: "\#(assetName)", in: .module, compatibleWith: nil)!"#
        case (.image, false, .uiKit):
            return #"UIImage("\#(assetName)")"#

        case (.image, true, .swiftUI):
            return #"Image("\#(assetName)", bundle: .module)"#
        case (.image, false, .swiftUI):
            return #"Image("\#(assetName)")"#

        case (.color, true, .appKit):
            return #"NSColor(named: "\#(assetName)", bundle: .module)!"#
        case (.color, false, .appKit):
            return #"NSImage(named: "\#(assetName)")!"#

        case (.color, true, .uiKit):
            return #"UIColor(named: "\#(assetName)", in: .module, compatibleWith: nil)!"#
        case (.color, false, .uiKit):
            return #"UIColor("\#(assetName)")"#

        case (.color, true, .swiftUI):
            return #"Color("\#(assetName)", bundle: .module)"#
        case (.color, false, .swiftUI):
            return #"Color("\#(assetName)")"#
        }
    }
}

extension Asset {
    static func returnType(type: `Type`, target: Target) -> String {
        switch type {
        case .string:
            return "String"
        case .image:
            switch target {
            case .appKit:
                return "NSImage"
            case .uiKit:
                return "UIImage"
            case .swiftUI:
                return "Image"
            }
        case .color:
            switch target {
            case .appKit:
                return "NSColor"
            case .uiKit:
                return "UIColor"
            case .swiftUI:
                return "Color"
            }
        }
    }

    func returnType(target: Target) -> String {
        Self.returnType(type: type, target: target)
    }
}

extension Asset {
    private var variableName: String {
        return name.split { "_-. ".contains($0) }.map { String($0).capitalizingFirstLetter }.joined().lowercasedFirstLetter
    }

    func generateCode(indentation: String,
                      namespace: String,
                      target: Target,
                      isSPM: Bool = false,
                      separator: String = "/") -> String
    {
        let assetName = namespace.count > 0 ? namespace + separator + name : name
        let type = returnType(target: target)
        let initializer = initializer(assetName: assetName, isSPM: isSPM, target: target)
        return """
        \(indentation)public static var \(variableName): \(type) {
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
