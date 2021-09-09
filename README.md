# Yep



根据 XCAssets 内容，自动生成 Swift 代码。

- [x] 根据 `Assets` 生成 Images 代码
- [x] 根据 `Assets` 生成 Colors 代码
- [x] 根据 `.strings` 生成 i18n 代码

## 自动生成的代码示例

```swift
//
//  I18n
//
//  ⚠️ DO NOT EDIT.
//  Code generated by Yep(https://github.com/octree/Yep) on 2019/7/5.
//  Copyright © 2019 Octree. All rights reserved.
//

import UIKit


struct I18n {
    /// "删除"
    @inline(__always) static var delete: String {
        return NSLocalizedString("delete", comment: "")
    }

    /// "置顶"
    @inline(__always) static var pin: String {
        return NSLocalizedString("pin", comment: "")
    }
}

```

### Assets 支持 Namespace

```swift
//
//  Images
//
//  ⚠️ DO NOT EDIT.
//  Code generated by Yep(https://github.com/octree/Yep) on 2019/7/5.
//  Copyright © 2019 Octree. All rights reserved.
//

import UIKit

// MARK: - ImageRes
struct ImageRes {
    @inline(__always) static var addFill: UIImage {
        return UIImage(named: "add-fill")!
    }
    
    // MARK: - GroupA
    struct GroupA {
        @inline(__always) static var addFill: UIImage {
            return UIImage(named: "GroupA/add-fill")!
        }
    }
}
```


## Usage

在工程目录创建 `.yep.json` 文件



```json
{
    "assetPath": "./Sources/Assets/Resources/Media.xcassets",
    "colorsDestination": "./Sources/Assets/Generated/ColorAssets.swift",
    "imagesDestination": "./Sources/Assets/Generated/ImageAssets.swift",
    "i18nStringsPath": "./Sources/Assets/Resources/en.lproj/Localizable.strings",
    "i18nDestination": "./Sources/Assets/Generated/I18n.swift",
    "useSwiftUI": false,
    "isSPM": true
}
```



然后在工程目录执行命令即可

```shell
# just works
yep
```

