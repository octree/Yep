//
//  Configuration.swift
//  Yep
//
//  Created by Octree on 2021/12/22.
//  Copyright © 2021 Octree. All rights reserved.
//

import Foundation

struct Configuration: Codable {
    var assetPath: String
    var uiColorDestination: String?
    var uiImageDestination: String?
    var swiftUIColorDestination: String?
    var swiftUIImageDestination: String?
    var i18nStringsPath: String?
    var i18nDestination: String?
    var assetNamespace: String?
    var isSPM: Bool?
}
