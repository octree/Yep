//
//  Assets.swift
//  Yep
//
//  Created by Octree on 2019/7/4.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation

struct Assets {
    var imagesTree: Namespace
    var colorsTree: Namespace
}

func fileComments(type: Asset.`Type`) -> String {
    var title = ""
    switch type {
    case .image:
        title = "Images"
    case .color:
        title = "Colors"
    }
    
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/m/d"
    let dateString = formatter.string(from: date)
    formatter.dateFormat = "yyyy"
    let year = formatter.string(from: date)
    return """
    //
    //  \(title)
    //
    //  Auto generated by Octree on \(dateString).
    //  Copyright © \(year) Octree. All rights reserved.
    //
    
    import UIKit
    
    
    """
}

extension Assets {
    var colorsCode: String {
        return fileComments(type: .color) + colorsTree.generateCode()
    }
    
    var imagesCode: String {
        return fileComments(type: .image) + imagesTree.generateCode()
    }
}
