//
//  UIKitCommonModule.swift
//  FSSCamera
//
//  Created by Truc Pham on 14/08/2023.
//

import Foundation
import UIKit
import Cleanse

/// Define common UIKit bindings.
struct UIKitCommonModule : Module {
    static func configure(binder: UnscopedBinder) {
        binder.include(module: UIScreen.Module.self)
        binder.include(module: UIWindow.Module.self)
        binder.include(module: AppDelegate.Module.self)
    }
}

extension UIScreen {
    /// This is a simple module that binds UIScreen.mainScreen() to UIScreen
    struct Module : Cleanse.Module {
        public static func configure(binder: UnscopedBinder) {
            binder
                .bind(UIScreen.self)
                .to(value: UIScreen.main)
        }
    }
}

extension AppDelegate {
    struct Module : Cleanse.Module {
        public static func configure(binder: UnscopedBinder) {
            binder
                .bind(AppDelegate.self)
                .to(value: UIApplication.shared.delegate as! AppDelegate)
        }
    }
}

extension UIWindow {
    /// This is the module that configures how we build our main window. It ias assumed when one requests
    /// injection of an un-tagged UIWindow, we will be giving them the "main" or "key" window.
    struct Module : Cleanse.Module {
        static func configure(binder: UnscopedBinder) {
            binder
                .bind(UIWindow.self)
                // .sharedInScope() FIXME what does this break?
                .to { (rootViewController: TaggedProvider<UIViewController.Root>, mainScreen: UIScreen) in
                    let window = UIWindow(frame: mainScreen.bounds)
                    window.rootViewController = rootViewController.get()
                    return window
            }
        }
    }
}

extension UIViewController {
    /// This will represent the rootViewController that is assigned to our main window
    struct Root : Tag {
        typealias Element = UIViewController
    }
}

