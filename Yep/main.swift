import Foundation

struct Config: Codable {
    var assetPath: String
    var colorsDestination: String?
    var imagesDestination: String?
    var i18nStringsPath: String?
    var i18nDestination: String?
    var useSwiftUI: Bool?
    var isSPM: Bool?
}

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
        \(fileComments(title: "I18n"))
        \(tree.generateCode(namespace: "", indentation: "", useSwiftUI: false, isSPM: isSPM, separator: "."))
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
    let config = try JSONDecoder().decode(Config.self, from: data)
    let assets = try exploreAssets(atPath: config.assetPath.absolutePath)
    if let path = config.imagesDestination {
        try save(code: assets.imagesCode(useSwiftUI: config.useSwiftUI == true, isSPM: config.isSPM == true), path: path.absolutePath)
        print("🍻 \u{001b}[38;5;35m成功生成「Images」代码")
    }
    if let path = config.colorsDestination {
        try save(code: assets.colorsCode(useSwiftUI: config.useSwiftUI == true, isSPM: config.isSPM == true), path: path.absolutePath)
        print("🍻 \u{001b}[38;5;35m成功生成「Colors」代码")
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
