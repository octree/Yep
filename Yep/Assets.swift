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

func fileComments(title: String) -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/M/d"
    let dateString = formatter.string(from: date)
    formatter.dateFormat = "yyyy"
    let year = formatter.string(from: date)
    return """
    //
    //  \(title)
    //
    //  Auto generated via Yep(https://github.com/octree/Yep) on \(dateString).
    //  Copyright © \(year) Octree. All rights reserved.
    //
    
    import UIKit
    
    
    """
}

extension Assets {
    var colorsCode: String {
        return fileComments(title: "Colors") + colorsTree.generateCode()
    }
    
    var imagesCode: String {
        return fileComments(title: "Images") + imagesTree.generateCode()
    }
}
