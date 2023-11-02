//
//  ViewController.swift
//  FSSCamera
//
//  Created by Truc Pham on 12/08/2023.
//

import UIKit
import Cleanse
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
    }


}

class TestController : UIViewController {
    let liveVC : LiveViewController
    let accountDelegate = ISCCameraUserAccountModel.init()
    init(live: Provider<LiveViewController>) {
        self.liveVC = live.get()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        accountDelegate.delegate = self
        accountDelegate.loginWithTypeLocal()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
extension TestController : ISCCameraUserAccountModelDelegate {
    func login(withNameDelegate reslut: Int) {
        self.navigationController?.pushViewController(liveVC, animated: true)
    }
    
    
}
