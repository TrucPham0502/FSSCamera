//
//  MyTheme.swift
//  FSSCamera
//
//  Created by TrucPham on 23/11/2023.
//  Copyright © 2023 FSS Camera. All rights reserved.
//

import Foundation
enum MyTheme : ThemeProtocol {
    case light
    case dark
    var settings : MyThemeSettings {
        switch self {
        case .light: return .init(color: LightTheme())
        case .dark: return .init(color: DarkTheme())
        }
    }
}
protocol Colorable {
    var colorWhite : UIColor { get }
    var colorBlack : UIColor { get }
}
struct MyThemeSettings : ThemeModelProtocol {
    var color : Colorable
}


class LightTheme : Colorable {
    var colorWhite: UIColor = .white
    
    var colorBlack: UIColor = .black
}
class DarkTheme : Colorable {
    var colorWhite: UIColor = .black
    
    var colorBlack: UIColor = .white
}
