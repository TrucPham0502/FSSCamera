//
//  AppComponent.swift
//  FSSCamera
//
//  Created by Truc Pham on 13/08/2023.
//

import Foundation
import Cleanse
struct AppComponent : Cleanse.RootComponent  {
    typealias Root = PropertyInjector<AppDelegate>
    typealias Scope = Singleton
    
    static func configure(binder: Binder<Singleton>) {
        binder.include(module: RootModule.self)
        
        let endPoint = (Bundle.main.object(forInfoDictionaryKey: "APP_ENDPOINT") as! String)
        
        let appName = (Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String)
        
        let appVersion = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        
        
        let gis = (ProcessInfo.processInfo.environment["APP_GIS"]) ?? ""
        
        let mediaUrl = (Bundle.main.object(forInfoDictionaryKey: "APP_MEDIA_ENDPOINT") as! String)
        
        let package = (ProcessInfo.processInfo.environment["APP_PACKAGE"]) ?? ""
        
        let publicKey = (ProcessInfo.processInfo.environment["PUBLIC_KEY"]) ?? ""
        
        
        print("Currently use: \(endPoint)")
        
        binder
            .bind(String.self)
            .tagged(with: Tags.EndPointURL.self)
            .to(value: endPoint)
        
        binder
            .bind(String.self)
            .tagged(with: Tags.MediaUrl.self)
            .to(value: mediaUrl)
        
        binder
            .bind(String.self)
            .tagged(with: Tags.PublicKey.self)
            .to(value: publicKey)
        
        binder
            .bind(String.self)
            .tagged(with: Tags.Package.self)
            .to(value: package)
        
        binder
            .bind(String.self)
            .tagged(with: Tags.Gis.self)
            .to(value: gis)
        
        binder
            .bind(String.self)
            .tagged(with: Tags.AppName.self)
            .to(value: appName)
        
        binder
            .bind(String.self)
            .tagged(with: Tags.AppVersion.self)
            .to(value: appVersion)
        
    }
    
    static func configureRoot(binder bind: ReceiptBinder<Root>) -> BindingReceipt<Root> {
        return bind.propertyInjector(configuredWith: RootModule.configureAppDelegateInjector)
    }
    
}
