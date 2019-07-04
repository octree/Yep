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
    var colorsDestination: String
    var imagesDestination: String
}

let configPath = FileManager.default.currentDirectoryPath.appendingPathComponent(path: ".yep.json")

func save(code: String, path: String) throws {
    try code.write(to: URL(fileURLWithPath: path),
                   atomically: true,
                   encoding: .utf8)
}

do {
    let data = try Data(contentsOf: URL(fileURLWithPath: configPath))
    let config = try JSONDecoder().decode(Config.self, from: data)
    let assets = try exploreAssets(atPath: config.assetPath.absolutePath)
    try save(code: assets.colorsCode, path: config.colorsDestination.absolutePath)
    try save(code: assets.imagesCode, path: config.imagesDestination.absolutePath)
    print("🍻 \u{001b}[38;5;35m成功生成代码")
} catch {
    print("\u{001b}[38;5;197m\(error.localizedDescription)")
    exit(1);
}
