//
//  BaseViewController.swift
//  FSSCamera
//
//  Created by Truc Pham on 14/08/2023.
//

import Foundation
import RxSwift
import RxCocoa
import Localize
class BaseViewController<VM : ViewModelType> : AppBaseViewController {
    private var fetching: Driver<Bool>?
    let viewModel: VM
    init(vm : VM) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        performBinding()
    }
    
    func performBinding() {
        viewModel.activityIndicator.asDriver()
            .drive(onNext: { [unowned self] in
                switch $0 {
                case .none:  self.showLoading(withStatus: false)
                case .loading(let message):
                    self.showLoading(withStatus: true, message: message)
                }
            })
            .disposed(by: self.disposeBag)
        viewModel.errorTracker.asDriver()
            .drive(onNext: { [unowned self] in self.handleError(error: $0) })
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(setLocalize), name: NSNotification.Name(localizeChangeNotification), object: nil)
        
    }
    @objc func setLocalize() { }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
 
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}




