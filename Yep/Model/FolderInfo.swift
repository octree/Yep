//
//  FolderInfo.swift
//  Yep
//
//  Created by Octree on 2021/12/22.
//  Copyright © 2021 Octree. All rights reserved.
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
    public init(url: URL) throws {
        let jsonURL = url.appendingPathComponent("Contents.json")
        let data = try Data(contentsOf: jsonURL)
        self = try JSONDecoder().decode(FolderInfo.self, from: data)
    }
}
