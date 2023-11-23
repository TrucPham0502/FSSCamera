//
//  TestViewController.swift
//  FSSCamera
//
//  Created by Truc Pham on 15/08/2023.
//

import Foundation
import RxSwift
import RxCocoa
import Cleanse
extension LiveViewController : Themable {
    func applyTheme(_ theme: MyTheme) {
        self.view.backgroundColor = theme.settings.color.colorBlack
    }
}

class LiveViewController : BaseViewController<LiveViewModel> {
    var channelActiveIndex = -1
    let serial : String = "cf43661212a3f1d1cxt5"
    let deviceManager = ISCCameraDeviceManager.shared()
    let publicKey : String
    init(vm: LiveViewModel, key: TaggedProvider<Tags.PublicKey>) {
        self.publicKey = key.get()
        super.init(vm: vm)
    }
    @PublishRelayProperty
    var data : CameraInfo?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var livestreamView: ISCCameraLiveStreamView = {
        let v = ISCCameraLiveStreamView()
        v.delegate = self
        v.isUserInteractionEnabled = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = R.color.onBackground()
        let image : UIImage? = R.image.avatar()
        self.view.addSubview(livestreamView)
        NSLayoutConstraint.activate([
            livestreamView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            livestreamView.heightAnchor.constraint(equalToConstant: 250),
            livestreamView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            livestreamView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        print("hello".localized)
        (UIApplication.shared.delegate as! AppDelegate).setLanguage(language: .en)
       
        ThemeManager.shared.register(self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            ThemeManager.shared.theme = .dark
        }
        
    }
    
    override func setLocalize() {
        super.setLocalize()
        print("hello".localized)
    }
    
    override func performBinding() {
        super.performBinding()
        let out = viewModel.transform(input: .init(serial: serial, viewDidLoad: self.rx.viewDidLoad.mapToVoid().asDriverOnErrorJustComplete(), data: $data))
        
        out.cameraInfo.drive(onNext: {[weak self] data in
            print(data)
            guard let self = self else { return }
           
            self.addDeviceToCamera()
        }).disposed(by: self.disposeBag)
    }
    
    func addDeviceToCamera(){
        self.deviceManager.delegate = self
        if let info = viewModel.cameraInfo, !serial.isEmpty {
            if let passwordDecrypt = CryptorManager.shared.decrypt(encryptedText: info.password, password: "bad7b7030139d508c9869bb122e50750d2d879de"){
                self.deviceManager.loginDevice(serial, deviceName: info.name, userName: info.username , password: passwordDecrypt, deviceType: 0, seq: 0)
                
            }
        }
    }
    
}
extension LiveViewController : ISCCameraLiveStreamViewDelegate {
    func getChannelActive() -> CameraInfo.Channel? {
        guard let default_channel = viewModel.cameraInfo?.channelObj?.defaultChannel, let channels = viewModel.cameraInfo?.channelObj?.channels, channels.count > 0 else {
            return nil
        }
        //nếu indexActive = -1 sẽ lấy default channel
        if channelActiveIndex == -1 {
            channelActiveIndex = default_channel
        }
        //nếu channel đang ở vị trí lớn hơn count danh sách sẽ quay về lấy vị trí 0 của danh sách list channel
        if channelActiveIndex >= channels.count{
            channelActiveIndex = 0
        }
        return channels[channelActiveIndex]
    }
    func getStreamDefault() -> Int32{
        if let channelActive = getChannelActive(), let stream = channelActive.stream {
            let stream:String = String(stream)
            let int32:Int32 = Int32.init(stream) ?? 0
            return int32
        }
        return 0
    }
    func playStream(){
        livestreamView.stop()
        livestreamView.createPlay()
        livestreamView.initDataSource(self.getStreamDefault())
        livestreamView.startRealPlay()
    }
}
extension LiveViewController : ISCCameraDeviceManagerDelegate{
    func loginDeviceResult(_ sId: String, result: Int32, seq: Int32) {
        if result > 0{
            deviceManager.cleanSelectChannel()
            if let deviceObject = self.deviceManager.getDeviceObject(bySN: sId){
                deviceManager.setSelectChannel(deviceObject.channelArray?.firstObject as! ChannelObject)
                playStream()
            }
        }
    }
}
enum FunLoginErrorResult : Int {
    case EE_DVR_PASSWORD_NOT_VALID = -11301
    case EE_DVR_LOGIN_USER_NOEXIST = -11302
    case EE_DVR_USER_LOCKED = -11303
}
extension ISCCameraDeviceManager {
    func loginDevice(_ serial: String, deviceName : String, userName: String,  password: String, deviceType : Int32, seq : Int32 = 0) {
        if password.isEmpty{
            self.delegate?.loginDeviceResult?(serial, result: Int32(FunLoginErrorResult.EE_DVR_PASSWORD_NOT_VALID.rawValue), seq: seq)
            return
        }
        self.loginResult = { [weak self] serial, result in
            if result < 0, let err = FunLoginErrorResult(rawValue: Int(result)) {
               
            }
        }
        if let _ = self.getDeviceObject(bySN: serial) {
            self.changeDevicePsw(serial, loginName: userName, password: password)
            self.getDeviceChannel(serial, seq: seq)
        }
        else {
            self.addDevice(byDeviseSerialnumber: serial, deviceName: deviceName, devType: deviceType, seq: seq)
            self.changeDevicePsw(serial, loginName: userName, password: password)
        }
    }
    
}
