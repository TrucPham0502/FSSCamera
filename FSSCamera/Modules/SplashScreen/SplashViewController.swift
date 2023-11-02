//
//  SplashViewController.swift
//  FSSCamera
//
//  Created by Truc Pham on 14/08/2023.
//

import Foundation
import Cleanse
class SplashViewController : BaseViewController<SplashViewModel> {
    let liveVC : LiveViewController
    let app : AppDelegate
    let vc : TestController
    init(vm : SplashViewModel, liveVC : Provider<LiveViewController>, app: AppDelegate, vc : Provider<TestController>){
        self.liveVC = liveVC.get()
        self.app = app
        self.vc = vc.get()
        super.init(vm: vm)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            let vc = UINavigationController(rootViewController: self.vc)
            self.app.window?.rootViewController = vc
        }
    }
    
    
    
}

