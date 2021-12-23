//
//  AssetsWalker.swift
//  Yep
//
//  Created by Octree on 2019/7/4.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation

struct AssetsWalker {
    var path: String
    var namespace: String?
}

extension AssetsWalker {
    func walk() throws -> Assets {
        let namespace = namespace?.capitalizingFirstLetter ?? "Assets"
        var isDir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDir), isDir.boolValue else {
            throw AssetsError.fileNotExists
        }
        let imageNamespace = Namespace(name: namespace)
        imageNamespace.isRoot = true
        let colorNamespace = Namespace(name: namespace)
        colorNamespace.isRoot = true
        try createAssets(at: URL(fileURLWithPath: path), imageNamespace: imageNamespace, colorNamespace: colorNamespace)
        return Assets(imagesTree: imageNamespace, colorsTree: colorNamespace)
    }

    private func createAssets(at url: URL, imageNamespace: Namespace, colorNamespace: Namespace) throws {
        let foldInfo = try FolderInfo(url: url)
        let currentImagesNamespace: Namespace
        let currentColorsNamespace: Namespace
        if foldInfo.properties?.providesNamespace == true {
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
                try createAssets(at: subURL, imageNamespace: currentImagesNamespace, colorNamespace: currentColorsNamespace)
            case "imageset":
                currentImagesNamespace.assets.append(Asset(name: name, type: .image))
            case "colorset":
                currentColorsNamespace.assets.append(Asset(name: name, type: .color))
            default:
                break
            }
        }
        if foldInfo.properties?.providesNamespace == true {
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
}
