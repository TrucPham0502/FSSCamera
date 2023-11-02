//
//  tags.swift
//  FSSCamera
//
//  Created by Truc Pham on 13/08/2023.
//

import Foundation
import Cleanse
import Alamofire
struct Tags {
    struct EndPointURL: Tag {
        typealias Element = String
    }

    struct MediaUrl: Tag {
        typealias Element = String
    }


    struct Package: Tag {
        typealias Element = String
    }


    struct Gis: Tag {
        typealias Element = String
    }
    
    struct PublicKey: Tag {
        typealias Element = String
    }


    struct AppName : Tag {
        typealias Element = String
    }


    struct AppVersion : Tag {
        typealias Element = String
    }


    struct AppVersionCode : Tag {
        typealias Element = String
    }


    struct EndPointCredentialURL: Tag {
        typealias Element = String
    }
    //client key

    struct AppClientKey: Tag {
        typealias Element = String
    }
    //secret key

    struct AppSecretKey: Tag {
        typealias Element = String
    }
}


