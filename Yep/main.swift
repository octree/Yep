import Foundation

let configPath = FileManager.default.currentDirectoryPath.appendingPathComponent(path: ".yep.json")

func save(code: String, path: String) throws {
    try code.write(to: URL(fileURLWithPath: path),
                   atomically: true,
                   encoding: .utf8)
}

func generateI18nCode(path: String, destination: String, isSPM: Bool) {
    do {
        let source = try String(contentsOf: URL(fileURLWithPath: path))
        let tree = try Parser(input: source).parseToTree()
        let code = """
        \(fileComments(title: "I18n", target: nil))
        \(tree.generateCode(namespace: "", indentation: "", target: .swiftUI, isSPM: isSPM, separator: "."))
        """
        try save(code: code, path: destination)
        print("🍻 \u{001b}[38;5;35m成功生成「I18n」代码")
    } catch ParseError.notMatch {
        print("\u{001b}[38;5;197m.strings 文件格式错误")
        exit(1)
    } catch {
        print("\u{001b}[38;5;197m\(error.localizedDescription)")
        exit(1)
    }
}

do {
    let data = try Data(contentsOf: URL(fileURLWithPath: configPath))
    let config = try JSONDecoder().decode(Configuration.self, from: data)
    let walker = AssetsWalker(path: config.assetPath.absolutePath, namespace: config.assetNamespace)
    let assets = try walker.walk()
    if let path = config.nsImageDestination {
        try save(code: assets.imagesCode(target: .appKit, isSPM: config.isSPM == true), path: path.absolutePath)
        print("🍻 \u{001b}[38;5;35m成功生成「Assets for NSImage」代码")
    }

    if let path = config.uiImageDestination {
        try save(code: assets.imagesCode(target: .uiKit, isSPM: config.isSPM == true), path: path.absolutePath)
        print("🍻 \u{001b}[38;5;35m成功生成「Assets for UIImage」代码")
    }
    
    if let path = config.swiftUIImageDestination {
        try save(code: assets.imagesCode(target: .swiftUI, isSPM: config.isSPM == true), path: path.absolutePath)
        print("🍻 \u{001b}[38;5;35m成功生成「Assets for SwiftUI.Image」代码")
    }

    if let path = config.nsColorDestination {
        try save(code: assets.colorsCode(target: .appKit, isSPM: config.isSPM == true), path: path.absolutePath)
        print("🍻 \u{001b}[38;5;35m成功生成「Assets for NSColor」代码")
    }
    
    if let path = config.uiColorDestination {
        try save(code: assets.colorsCode(target: .uiKit, isSPM: config.isSPM == true), path: path.absolutePath)
        print("🍻 \u{001b}[38;5;35m成功生成「Assets for UIColor」代码")
    }
    
    if let path = config.swiftUIColorDestination {
        try save(code: assets.colorsCode(target: .swiftUI, isSPM: config.isSPM == true), path: path.absolutePath)
        print("🍻 \u{001b}[38;5;35m成功生成「Assets for SwiftUI.Color」代码")
    }

    if let path = config.i18nStringsPath, let destination = config.i18nDestination {
        generateI18nCode(path: path.absolutePath,
                         destination: destination.absolutePath,
                         isSPM: config.isSPM == true)
    }
    print("🍻 \u{001b}[38;5;35mDone!")
} catch {
    print("\u{001b}[38;5;197m\(error.localizedDescription)")
    exit(1);
}
