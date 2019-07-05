# Yep



根据 XCAssets 内容，自动生成 Swift 代码。

- [x] 根据 `Assets` 生成 Images 代码
- [x] 根据 `Assets` 生成 Colors 代码
- [x] 根据 `.strings` 生成 i18n 代码

eg:

```swift
//
//  Images
//
//  Auto generated by Octree on 2019/36/4.
//  Copyright © 2019 Octree. All rights reserved.
//

import UIKit

// MARK: - ImageRes
struct ImageRes {
    @inline(__always) static var addFill: UIImage {
        return UIImage(named: "add-fill")!
    }

    @inline(__always) static var arrowDown: UIImage {
        return UIImage(named: "arrow-down")!
    }
}
```



## Usage

在工程目录创建 `.yep.json` 文件



```json
{
    "assetPath": "./LydiaBox/Resource/Assets.xcassets",
    "colorsDestination": "./LydiaBox/Resource/Color.swift",
    "imagesDestination": "./LydiaBox/Resource/Resource.swift",
    "i18nStringsPath": "./LydiaBox/Resource/I18n/zh-Hans.lproj/LydiaBox.strings",
    "i18nDestination": "./LydiaBox/Resource/I18n/I18n.swift"
}
```



然后在工程目录执行 shell 命令即可

```shell
# just works
yep
```

