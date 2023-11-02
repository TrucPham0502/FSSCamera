//
//  SplashModule.swift
//  FSSCamera
//
//  Created by Truc Pham on 14/08/2023.
//

import Foundation
import Cleanse
struct SplashModule : Cleanse.Module {
    static func configure(binder: Cleanse.Binder<Cleanse.Unscoped>) {
        binder
            .bind(SplashViewController.self)
            .to(factory: SplashViewController.init)
        
        
        binder
            .bind(TestController.self)
            .to(factory: TestController.init)
        
        binder
            .bind(SplashViewModel.self)
            .to(factory: SplashViewModel.init)
        
    }
}
