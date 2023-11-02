//
//  AppDelegate.swift
//  FSSCamera
//
//  Created by Truc Pham on 12/08/2023.
//

import UIKit
import Cleanse
import IQKeyboardManagerSwift
import Localize

typealias ReleaseAppComponent = AppComponent

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        resetApplication()
        
        initLanguage()
        
        ISCCameraSDK.shared().initSDK()
        return true
    }

}

extension AppDelegate {
    func resetApplication() {
        let propertyInjector: PropertyInjector<AppDelegate>
        
        propertyInjector = try! ComponentFactory.of(ReleaseAppComponent.self, validate: false).build(())
        propertyInjector.injectProperties(into: self)

        // window should now be defined
        precondition(window != nil)

        window!.makeKeyAndVisible()
    }
    
    func injectProperties(_ window: UIWindow) {
        self.window = window
    }
   

}

extension AppDelegate {
    func setLanguage(language: Language) {
        Localize.shared.update(language: language.rawValue)
    }
    private func initLanguage(){
        Localize.shared.update(provider: .json)
        Localize.shared.update(fileName: "lang")
        Localize.update(defaultLanguage: "vi")
    }
    
    func getCurrentLanguage() -> Language {
        let la : String =  Localize.shared.currentLanguage
        return Language(rawValue: la) ?? .vi
    }
}

enum Language : String{
    case vi = "vi"
    case en = "en"
}

