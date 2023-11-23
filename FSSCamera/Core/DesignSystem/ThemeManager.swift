//
//  MyTheme.swift
//  FSSCamera
//
//  Created by TrucPham on 23/11/2023.
//  Copyright © 2023 FSS Camera. All rights reserved.
//

import Foundation
protocol ThemeModelProtocol {}
protocol ThemeProtocol : Equatable {
    associatedtype Model : ThemeModelProtocol
    var settings : Model { get }
}

protocol Themable : AnyObject {
    func applyTheme(_ theme: MyTheme)
}

class ThemeManager {
    private var themables = NSHashTable<AnyObject>.weakObjects()
    var theme : MyTheme {
        didSet{
            guard theme != oldValue else { return }
            apply()
        }
    }
    static let shared : ThemeManager = .init(defaultTheme: .light)
    private init(defaultTheme: MyTheme){
        self.theme = defaultTheme
    }
    
    func register(_ themable : Themable) {
        themables.add(themable)
        themable.applyTheme(theme)
    }
    
    func apply(){
        themables.allObjects.forEach({($0 as? Themable)?.applyTheme(theme)})
    }
}



