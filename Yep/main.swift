//
//  main.swift
//  SwiftCMD
//
//  Created by Octree on 2019/6/6.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation

//struct Arg {
//    var path: String
//}

//let parser = ArgumentParser(into: Arg(path: ""))
//parser.addArgument("--path", \Arg.path, defaultValue: nil, help: "Path of XCAssets") {
//    return $0
//}
//
//let arg = parser.parse()

//guard CommandLine.arguments.count == 2 else {
//    print("fuck off");
//    exit(1);
//}

struct Config: Codable {
    var assetPath: String
    var colorsDestination: String?
    var imagesDestination: String?
    var i18nStringsPath: String?
    var i18nDestination: String?
    var useSwiftUI: Bool?
}

let configPath = FileManager.default.currentDirectoryPath.appendingPathComponent(path: ".yep.json")

func save(code: String, path: String) throws {
    try code.write(to: URL(fileURLWithPath: path),
                   atomically: true,
                   encoding: .utf8)
}

func stringsCode(pair:(String, String)) -> String {
    let varibaleName = pair.0.split { "_-. ".contains($0) }.map { String($0).capitalizingFirstLetter() }.joined().lowercaseFirstLetter()
    let comment = pair.1.count > 30 ? pair.1[...30] + "..." : pair.1
    return """
        // \(comment)
        @inline(__always) static var \(varibaleName): String {
            return NSLocalizedString("\(pair.0)", comment: "")
        }
    """
}

func generateStringsCode(path: String, destination: String) {
    do {
        let source = try String(contentsOf: URL(fileURLWithPath: path))
        let keys = try Parser(input: source).parse()
        let code = """
        \(fileComments(title: "I18n"))
        struct I18n {
        \(keys.map(stringsCode).joined(separator: "\n\n"))
        }
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
        try save(code: assets.imagesCode(useSwiftUI: config.useSwiftUI == true), path: path.absolutePath)
        print("🍻 \u{001b}[38;5;35m成功生成「Images」代码")
    }
    if let path = config.colorsDestination {
        try save(code: assets.colorsCode(useSwiftUI: config.useSwiftUI == true), path: path.absolutePath)
        print("🍻 \u{001b}[38;5;35m成功生成「Colors」代码")
    }

    if let path = config.i18nStringsPath, let destination = config.i18nDestination {
        generateStringsCode(path: path.absolutePath, destination: destination.absolutePath)
    }
    print("🍻 \u{001b}[38;5;35mDone!")
} catch {
    print("\u{001b}[38;5;197m\(error.localizedDescription)")
    exit(1);
}
