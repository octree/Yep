//
//  XCAssetsExplorer.swift
//  Yep
//
//  Created by Octree on 2019/7/4.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation

struct FolderInfo: Codable {
    struct Properties: Codable {
        var providesNamespace: Bool
        enum CodingKeys: String, CodingKey {
            case providesNamespace = "provides-namespace"
        }
    }
    var properties: Properties?
}

extension FolderInfo {
    static func info(at url: URL) -> FolderInfo? {
        let jsonURL = url.appendingPathComponent("Contents.json")
        do {
            let data = try Data(contentsOf: jsonURL)
            return try JSONDecoder().decode(FolderInfo.self, from: data)
        } catch {
            return nil
        }
    }
}

func exploreAssets(at url: URL, imageNamespace: Namespace, colorNamespace: Namespace) {
    let foldInfo = FolderInfo.info(at: url)
    let currentImagesNamespace: Namespace
    let currentColorsNamespace: Namespace
    if foldInfo?.properties?.providesNamespace == true {
        currentColorsNamespace = Namespace(name: url.lastPathComponent)
        currentImagesNamespace = Namespace(name: url.lastPathComponent)
    } else {
        currentImagesNamespace = imageNamespace
        currentColorsNamespace = colorNamespace
    }
    let subDirectories = url.subDirectories
    for subURL in subDirectories {
        let pathExtension = subURL.pathExtension
        let name = subURL.pathComponents.last!.deletingPathExtension
        switch pathExtension {
        case "":
            exploreAssets(at: subURL, imageNamespace: currentImagesNamespace, colorNamespace: currentColorsNamespace)
        case "imageset":
            currentImagesNamespace.assets.append(Asset(name: name, type: .image))
        case "colorset":
            currentColorsNamespace.assets.append(Asset(name: name, type: .color))
        default:
            break
        }
    }
    if foldInfo?.properties?.providesNamespace == true {
        if !currentColorsNamespace.isEmpty {
            colorNamespace.sub.append(currentColorsNamespace)
        }
        if !currentImagesNamespace.isEmpty {
            imageNamespace.sub.append(currentImagesNamespace)
        }
    }
    currentColorsNamespace.assets.sort()
    currentColorsNamespace.sub.sort()
    currentImagesNamespace.assets.sort()
    currentImagesNamespace.sub.sort()
}

enum YepError: Error {
    case fileNotExists
}

extension YepError {
    var localizedDescription: String {
        return "XCAssets 目录不存在，请检查配置文件"
    }
}

func exploreAssets(atPath path: String) throws -> Assets {
    var isDir: ObjCBool = false
    guard FileManager.default.fileExists(atPath: path, isDirectory: &isDir), isDir.boolValue else {
        throw YepError.fileNotExists
    }
    let imageNamespace = Namespace(name: "ImageRes")
    imageNamespace.isRoot = true
    let colorNamespace = Namespace(name: "ColorRes")
    colorNamespace.isRoot = true
    exploreAssets(at: URL(fileURLWithPath: path), imageNamespace: imageNamespace, colorNamespace: colorNamespace)
    return Assets(imagesTree: imageNamespace, colorsTree: colorNamespace)
}
