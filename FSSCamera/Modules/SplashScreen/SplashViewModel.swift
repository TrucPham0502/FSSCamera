//
//  SplashViewModel.swift
//  FSSCamera
//
//  Created by Truc Pham on 15/08/2023.
//

import Foundation
class SplashViewModel : BaseViewModel<SplashViewModel.Input, SplashViewModel.Output> {
    struct Input { }
    struct Output { }
    
    override func transform(input: Input) -> Output {
        print("transform")
        return .init()
    }
    
}
