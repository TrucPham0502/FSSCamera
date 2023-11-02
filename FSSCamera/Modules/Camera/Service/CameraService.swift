//
//  CameraService.swift
//  FSSCamera
//
//  Created by Truc Pham on 15/08/2023.
//

import Foundation
import RxSwift
protocol CameraService {
    func getCameraInfo(_ request: CameraInfoRequest) -> Observable<CameraInfo>
}

class CameraServiceImpl : CameraService {
    let repository: CameraRepository
    init(repository: CameraRepository){
        self.repository = repository
    }
    func getCameraInfo(_ request: CameraInfoRequest) -> Observable<CameraInfo> {
        self.repository.getCameraInfo(request).map({data in
            CameraInfo(password: data.account?.password ?? "", username: data.account?.username ?? "", name: data.name ?? "",
                       channelObj: .init(channels: data.channelObj?.listChannel.map({cs in
                cs.map({ c in CameraInfo.Channel(stream: c.stream, label: c.label)})
            }) ?? [],defaultChannel: data.channelObj?.defaultChannel ?? 0))
        })
    }
}
