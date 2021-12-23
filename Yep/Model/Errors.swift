//
//  Errors.swift
//  Yep
//
//  Created by Octree on 2021/12/22.
//  Copyright © 2021 Octree. All rights reserved.
//

import Foundation

enum AssetsError: Error {
    case fileNotExists
}

extension AssetsError {
    var localizedDescription: String {
        return "XCAssets 目录不存在，请检查配置文件"
    }
}

enum ParseError: Error {
    case notMatch
}
