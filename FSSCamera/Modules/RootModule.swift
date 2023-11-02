//
//  RootModule.swift
//  FSSCamera
//
//  Created by Truc Pham on 13/08/2023.
//

import Foundation
import Cleanse
struct RootModule : Cleanse.Module {
    static func configure(binder:  Binder<Singleton>) {
        binder.include(module: UIKitCommonModule.self)
        binder.bind(ApiRequestManager.self)
            .to(factory: ApiRequestManagerImpl.init)
        
        
        
        binder.include(module: SplashModule.self)
        binder.include(module: CameraModule.self)
        binder
            .bind()
            .tagged(with: UIViewController.Root.self)
            .to { $0 as SplashViewController }
    }
    
    static func configureAppDelegateInjector(binder bind: PropertyInjectionReceiptBinder<AppDelegate>) -> BindingReceipt<PropertyInjector<AppDelegate>> {
        return bind.to(injector: AppDelegate.injectProperties)
    }
}

