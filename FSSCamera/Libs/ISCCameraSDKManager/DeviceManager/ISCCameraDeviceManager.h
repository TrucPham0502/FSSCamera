//
//  ISCCameraDeviceManager.h
//  FunSDKDemo
//
//  Created by Pham Chi Hieu on 10/25/19.
//  Copyright © 2019 Pham Chi Hieu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ISCCameraDeviceManagerDelegate <NSObject>

@optional
- (void)getDeviceChannel:(NSString *)sId result:(int)result seq:(int)seq;
- (void)loginDeviceResult:(NSString *)sId result:(int)result seq:(int)seq;
- (void)getDeviceState:(NSString *)sId result:(int)result;

//lamnhs NHẬN trạng thái camera mà không cần cam có sẵn trong local db
- (void)getDeviceStateV2:(NSString *)sId result:(int)result;
- (void)quickConfiguration:(id)device result:(int)resurt;
- (void)errorQuickConfiguration:(NSString *)error;
- (void)countdown:(int)time;
- (void)deleteDevice:(NSString *)sId result:(int)result;
- (void)addDeviceResult:(NSString *)sId result:(int)result seq:(int)seq;
- (void)addDeviceResultForLoginDevice:(NSString *)sId result:(int)result seq:(int)seq;
- (void)changeDeviceResult:(int)result;
//lamnhs lắng nghe kết quả config của camera do sdk trả về
- (void)getConfigByJson: (NSString *)serial jsonResult:(NSString *)result;
//lamnhs lắng nghe kết quả cấu hình config cho camera thành công hay thất bại
- (void)setConfigByJson: (int)errorCode;
//lamnhs lắng nghe sdk trả về danh sách camera cùng mạng
- (void)searchDevice:(NSMutableArray*)searchArray result:(int)result;
@end

@interface ISCCameraDeviceManager : NSObject
+ (ISCCameraDeviceManager *) shared;
@property (nonatomic, copy, nullable) void (^cameraStatus)(NSString*,int);
@property (nonatomic, copy, nullable) void (^loginResult)(NSString*,int);
@property (nonatomic, weak) id <ISCCameraDeviceManagerDelegate> delegate;
@property (nonatomic) NSString *token;
//- (void)loginDevice:(NSString *)serial deviceName:(NSString *)deviceName userName:(NSString *)userName password:(NSString *)password deviceType:(int)deviceType seq:(int)seq;
- (void)logoutDevice:(NSString *)devMac;
- (void)deleteDeviceWithDevMac:(NSString *)devMac;
- (void)addDeviceByDeviseSerialnumber:(NSString*)serialNumber deviceName:(NSString *)deviceName devType:(int)type seq:(int)seq;//通过输入设备序列号添加
- (NSMutableArray*)currentDeviceArray;
- (void)clearDeviceArray;
- (void)changeDevicePsw:(NSString *)devMac loginName:(NSString *)name password:(NSString *)psw;
- (void)getDeviceChannel:(NSString *)devMac seq:(int)seq;
- (void)cleanSelectChannel;
- (void)setSelectChannel:(ChannelObject *)channel;
- (void)startConfigWithSSID:(NSString*)ssid password:(NSString*)password timeout:(int) timeOut;
- (void)stopConfig;
- (void)LinkAlarm:(NSString *)deviceMac DeviceName:(NSString *)devName Username:(NSString *)username Password:(NSString *)password;
- (nullable DeviceObject *)GetDeviceObjectBySN:(NSString *)devSN;
- (NSString *)devThumbnailFile:(NSString*)devId andChannle:(int)channle;
-(void)getdeviceState:(NSString*)deviceMac;
// MARK - Video Cloud
- (void)initDelegateVideoConfig;
- (NSMutableArray*)getVideoTimeArray;
- (NSMutableArray*)getVideoArray;
- (void)initServerAlam: (NSString *)token;
#pragma mark - lamnhs lấy cấu hình camera để phân tích lỗi camera đang gặp phải
- (void)getConfigByJson: (NSString *)serial strConfigName:(NSString *)name;
#pragma mark - lamnhs set cấu hình camera để phân tích lỗi camera đang gặp phải
- (void)setConfigByJson: (NSString *)serial strConfigName:(NSString *)name strJsonConfig:(NSString *) config;
#pragma mark - lamnhs tiến hành gọi sdk để lấy danh sách camera cùng mạng
- (void)searchDevice;
-(void)startConfigWifiByAPMode:(NSString*)userName userPassword:(NSString*)userPassword ssid:(NSString*)ssid password:(NSString*)password;
-(void)startConfigWifiAPModeTimer: (int) timeOut;

@end

NS_ASSUME_NONNULL_END
