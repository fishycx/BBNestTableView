//
//  BBConst.swift
//  BBNestScrollView
//
//  Created by fishycx on 2020/8/26.
//  Copyright © 2020 fishycx. All rights reserved.
//

import UIKit

let safeBottomMargin = { () -> Int in
    if #available(iOS 11.0, *) {
        let mainWindow = UIApplication.shared.delegate?.window
        return Int(mainWindow??.safeAreaInsets.bottom ?? 0)
    }
    return 0
}()
let navigationBarHeight = safeBottomMargin > 0 ? 88 : 64
let NaviHeight = CGFloat(navigationBarHeight)
///屏幕宽度
let ScreenWidth = UIScreen.main.bounds.size.width
///屏幕高度
let ScreenHeight = UIScreen.main.bounds.size.height
///iOS的version
let systemVersion = (UIDevice.current.systemVersion as NSString).doubleValue


func BBFloat(_ floatValue: CGFloat) -> CGFloat {
    return BBFloatWithPadding(floatValue: floatValue, padding: 0.0)
}

func BBFloatWithPadding(floatValue: CGFloat, padding: CGFloat) -> CGFloat {
    let currentScreenWidth: CGFloat = ScreenWidth - padding
    let standardScreenWidth: CGFloat = 375.0 - padding
    return floor(floatValue / standardScreenWidth * currentScreenWidth)
}



