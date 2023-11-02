//
//  SDKInitializeModel.m
//  MobileVideo
//
//  Created by XM on 2018/4/23.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "SDKInitializeModel.h"
#import "FunSDK/FunSDK.h"
@implementation SDKInitializeModel

+ (void)SDKInit {
    //1、初始化底层库语言和国际化语言文件
    [self initLanguage];
    //2、初始化app证书,和云服务有关
    [self initPlatform];
    //3、初始化一些必须的底层配置
    [self configParam];
}


//1、初始化底层库语言和国际化语言文件
+ (void)initLanguage {
    //获取当前系统的语言
    NSString *language = [LanguageManager currentLanguage];
    //初始化底层库语言，底层库只支持汉语和英语
    SInitParam pa;
    pa.nAppType = H264_DVR_LOGIN_TYPE_MOBILE;
    if ([language isContainsString:@"zh"]) {
        strcpy(pa.sLanguage,"zh");
    } else {
        strcpy(pa.sLanguage,"en");
    }
    strcpy(pa.nSource, "xmshop");
    
    //默认使用XMEye的服务器
    //FUN_Init(0, &pa);
    
    //定制服务器的话，需要通过下面的方法初始化   "test.com"：定制的域名或者IP， 5000：端口号
    //FUN_InitExV2(0, &pa, 0, "", "test.com", 5000);
    
    NSLog(@"phucnv=== FUN Sys Set Server IP Port");
    
    FUN_InitExV2(0, &pa, 0, "P2P_SERVER", "p2p.fcam.vn", 8765);
    FUN_SysSetServerIPPort("MI_SERVER", "rs.fcam.vn", 443);
    /*
     FUN_SysSetServerIPPort("STATUS_P2P_SERVER", "status-p2p.fcam.vn", 7703);
     FUN_SysSetServerIPPort("STATUS_DSS_SERVER", "status-dss.fcam.vn", 7701);
     FUN_SysSetServerIPPort("STATUS_TPS_SERVER", "status-tps.fcam.vn", 7702);
     FUN_SysSetServerIPPort("STATUS_RPS_SERVER", "status-rps.fcam.vn", 7705);
     FUN_SysSetServerIPPort("STATUS_IDR_SERVER", "status-wps.fcam.vn", 7706);
     FUN_SysSetServerIPPort("HLS_DSS_SERVER", "pub-dss-hls.fcam.vn", 8080);
     FUN_SysSetServerIPPort("CONFIG_SERVER", "pub-cfg.fcam.vn", 8086);
     FUN_SysSetServerIPPort("UPGRADE_SERVER", "upgrades.fcam.vn", 8083);
     FUN_SysSetServerIPPort("CAPS_SERVER", "caps.fcam.vn", 443);
     FUN_SysSetServerIPPort("ALC_ALM_SERVER", "access-alc.fcam.vn", 6603);
     FUN_SysSetServerIPPort("PMS_ALM_SERVER", "access-pms.fcam.vn", 6602);
     FUN_SysSetServerIPPort("ACCESS_CSS_SERVER", "access-css.fcam.vn", 6614);
     FUN_SysSetServerIPPort("PMS_PIC_SERVER", "pub-pms-pic.fcam.vn", 8082);
     */
    
    FUN_SysSetServerIPPort("STATUS_P2P_SERVER", "https://status-p2p.fcam.vn", 7603);
    FUN_SysSetServerIPPort("STATUS_DSS_SERVER", "https://status-dss.fcam.vn", 7601);
    FUN_SysSetServerIPPort("STATUS_TPS_SERVER", "https://status-tps.fcam.vn", 7602);
    FUN_SysSetServerIPPort("STATUS_RPS_SERVER", "https://status-rps.fcam.vn", 7605);
    FUN_SysSetServerIPPort("STATUS_IDR_SERVER", "https://status-wps.fcam.vn", 7606);
    FUN_SysSetServerIPPort("HLS_DSS_SERVER", "https://pub-dss-hls.fcam.vn", 8180);
    FUN_SysSetServerIPPort("CONFIG_SERVER", "https://pub-cfg.fcam.vn", 8186);
    FUN_SysSetServerIPPort("UPGRADE_SERVER", "upgrades.fcam.vn", 8083);
    FUN_SysSetServerIPPort("CAPS_SERVER", "caps.fcam.vn", 443);
    FUN_SysSetServerIPPort("ALC_ALM_SERVER", "https://access-alc.fcam.vn", 6503);
    FUN_SysSetServerIPPort("PMS_ALM_SERVER", "https://access-pms.fcam.vn", 6502);
    FUN_SysSetServerIPPort("ACCESS_CSS_SERVER", "https://access-css.fcam.vn", 6615);
    FUN_SysSetServerIPPort("PMS_PIC_SERVER", "https://pub-pms-pic.fcam.vn", 8182);
    
    NSLog(@"phucnv=== FUN Sys Set Server IP Port");
    
    //初始化国际化语言文件，app界面显示语言
    Fun_InitLanguage([[[NSBundle mainBundle] pathForResource:language ofType:@"txt"] UTF8String]);
    
    Fun_LogInit(FUN_RegWnd((__bridge LP_WND_OBJ)self), "", 0, "", 1);
}

//2、初始化app证书
+ (void)initPlatform {
    FUN_XMCloundPlatformInit(APPUUID, APPKEY, APPSECRET, MOVECARD);
}
//3、初始化一些必须的底层配置
+ (void)configParam {
    // 初始化相关的参数 必须设置,账号登录成功后设备信息的保存路径+文件
    FUN_SetFunStrAttr(EFUN_ATTR_SAVE_LOGIN_USER_INFO,SZSTR([NSString GetDocumentPathWith:@"UserInfo.db"]));
    
    // 本地设备密码存储文件，必须设置
    FUN_SetFunStrAttr(EFUN_ATTR_USER_PWD_DB, SZSTR([NSString GetDocumentPathWith:@"password.txt"]));
    
    //升级⽂文件存放路径(只是路径，不包含文件名)
    FUN_SetFunStrAttr(EFUN_ATTR_UPDATE_FILE_PATH,SZSTR([NSString GetDocumentPathWith:@""]));
    
    //设置是否可以自动下载设备升级文件, 0不自动下载， 1wifi下自动下载， 2 有网络即自动下载
    FUN_SetFunIntAttr(EFUN_ATTR_AUTO_DL_UPGRADE, 0);//自行选择哪一种，可以动态更改
    
    // 配置文件存放路径(只是路径，不包含文件名)
    FUN_SetFunStrAttr(EFUN_ATTR_CONFIG_PATH,SZSTR([NSString GetDocumentPathWith:@"APPConfigs"]));
    
//    1、同步更新通用最新的代码
//    2、设置云端数据下载支持HTTPS(目前只有FTP定制支持):
    FUN_SetFunIntAttr(EFUN_ATTR_SET_CLOUD_DOWNLOAD_NETPTL, E_CLOUD_DOWNLOAD_NETPTL_HTTPS);
}

+ (void)SDKUnInit{
    FUN_UnInitNetSDK();
}
@end
