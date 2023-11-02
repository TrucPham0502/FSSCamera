//
//  CameraInfoResponse.swift
//  FSSCamera
//
//  Created by Truc Pham on 15/08/2023.
//

import Foundation
struct CameraInfoResponse : Codable {
    let status, permission: Int?
    let account: Account?
    let name: String?
    let channelObj: ChannelObj?
    let livestreamInfo: LivestreamInfo?
    let bannerInfo: BannerInfo?
    let imageInfo: ImageInfo?
    let serial: String?
    let featureInfo: FeatureInfo?

    enum CodingKeys: String, CodingKey {
        case status, permission, account, name
        case channelObj = "channel_obj"
        case livestreamInfo = "livestream_info"
        case bannerInfo = "banner_info"
        case imageInfo = "image_info"
        case serial
        //case activateAt = "activate_at"
        case featureInfo = "feature_info"
    }
    
    // MARK: - ImageInfo
    struct ImageInfo: Codable {
        let imageURL: String?
        let imageTime: Int?

        enum CodingKeys: String, CodingKey {
            case imageURL = "image_url"
            case imageTime = "image_time"
        }
    }
    
    // MARK: - Account
    struct Account: Codable {
        let username, password: String?
    }

    // MARK: - BannerInfo
    struct BannerInfo: Codable {
        var isBanner: Bool?
        var bannerContent, bannerButtonAction, bannerButtonLabel: String?

        enum CodingKeys: String, CodingKey {
            case isBanner = "is_banner"
            case bannerContent = "banner_content"
            case bannerButtonAction = "banner_button_action"
            case bannerButtonLabel = "banner_button_label"
        }
    }

    // MARK: - ChannelObj
    struct ChannelObj: Codable {
        let listChannel: [ListChannel]?
        let isSwitch: Bool?
        let defaultChannel: Int?

        enum CodingKeys: String, CodingKey {
            case listChannel = "list_channel"
            case isSwitch = "is_switch"
            case defaultChannel = "default_channel"
        }
    }

    // MARK: - ListChannel
    struct ListChannel: Codable {
        let stream: Int?
        let label: String?
    }

    // MARK: - LivestreamInfo
    struct LivestreamInfo: Codable {
        let isLivestream: Bool?
        let reasonCode: Int?
        let reasonTitle, reasonContent: String?

        enum CodingKeys: String, CodingKey {
            case isLivestream = "is_livestream"
            case reasonCode = "reason_code"
            case reasonTitle = "reason_title"
            case reasonContent = "reason_content"
        }
    }
    
    // MARK: - FeatureInfo
    struct FeatureInfo: Codable {
        enum FeaturePanAndTilt {
            case pan, tilt, all, none
        }
        let hasFeaturePan : Bool?
        let hasPermissionPan : Bool?
        
        let hasFeatureTilt : Bool?
        let hasPermisstionTilt : Bool?
        
        let hasFeaturePushToTalk : Bool?
        let hasPermissionPushToTalk : Bool?
        
        let hasFeatureVolumn : Bool?

        let hasPermisisonSdCard : Bool?
        let isButton24H: Bool?
        let familiarDetectionFeature:Bool?
        
        let tiltDirection: TiltDirection?
        let panDirection: PanDirection?
        enum CodingKeys: String, CodingKey {
            
            case hasFeaturePan = "has_feature_pan"
            case hasPermissionPan = "has_permission_pan"
            
            case hasFeatureTilt = "has_feature_tilt"
            case hasPermisstionTilt = "has_permission_tilt"
            
            case hasFeaturePushToTalk = "has_feature_push_to_talk"
            case hasPermissionPushToTalk = "has_permission_push_to_talk"
            
            case hasFeatureVolumn = "has_feature_volume"
            
            case hasPermisisonSdCard = "has_permisison_sd_card"
            
            case isButton24H = "is_button_24h"
            case familiarDetectionFeature = "has_feature_face_recognise"
            case tiltDirection = "tilt_direction"
            case panDirection = "pan_direction"
            
        }
        func featurePanAndTilt() -> FeaturePanAndTilt {
            let allowPan = (hasFeaturePan ?? false) && (hasPermissionPan ?? false)
            let allowTilt = (hasFeatureTilt ?? false) && (hasPermisstionTilt ?? false)
            if allowPan && allowTilt { return .all }
            else if allowPan { return .pan }
            else if allowTilt { return .tilt }
            else { return .none }
        }
        // MARK: - PanDirection
        struct PanDirection: Codable {
            let left, right: Int?
        }

        // MARK: - TiltDirection
        struct TiltDirection: Codable {
            let top, bottom: Int?
        }

    }
}
