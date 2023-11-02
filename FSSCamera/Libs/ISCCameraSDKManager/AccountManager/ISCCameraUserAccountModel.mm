//
//  ISCCameraUserAccountModel.m
//  FunSDKDemo
//
//  Created by Pham Chi Hieu on 10/25/19.
//  Copyright © 2019 Pham Chi Hieu. All rights reserved.
//

#import "ISCCameraUserAccountModel.h"
#import "UserAccountModel.h"

@interface ISCCameraUserAccountModel ()<UserAccountModelDelegate> {
    UserAccountModel *accountModel;
}
@end

@implementation ISCCameraUserAccountModel

static ISCCameraUserAccountModel *shareManager;
+ (ISCCameraUserAccountModel * )shared {
    return shareManager ? shareManager : [[ISCCameraUserAccountModel alloc]init];
}
- (id) init{
    static dispatch_once_t once;
    dispatch_once(&once ,^{
        shareManager = self;
    });
    accountModel = [[UserAccountModel alloc]init];
    accountModel.delegate = self;
    self = shareManager;
    return self;
}

- (void)loginWithTypeLocal {
    //初始化底层库Net网络相关（没有回调）
    [accountModel loginWithTypeLocal];
}

- (void)loginWithNameDelegate:(long)reslut {
    [self.delegate loginWithNameDelegate:reslut];
}

- (void)logout{
    [accountModel loginOut];
}
@end
