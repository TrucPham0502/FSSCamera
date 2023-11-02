//
//  TestModule.swift
//  FSSCamera
//
//  Created by Truc Pham on 15/08/2023.
//

import Foundation
import Cleanse
struct CameraModule : Cleanse.Module {
    static func configure(binder: Cleanse.Binder<Cleanse.Unscoped>) {
        
        binder.bind(CameraRemoteSource.self)
            .to(factory: CameraRemoteSourceImpl.init)
        
        binder.bind(CameraRepository.self)
            .to(factory: CameraRepositoryImpl.init)
        
        binder.bind(CameraService.self)
            .to(factory: CameraServiceImpl.init)
        
        
        
        binder.bind(LiveViewController.self)
            .to(factory: LiveViewController.init)
        binder.bind(LiveViewModel.self)
            .to(factory: LiveViewModel.init)
    }
    
    
}
