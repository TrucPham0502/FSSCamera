//
//  TalkBackControlDelegate.h
//  ISCCamera
//
//  Created by TrucPham on 10/08/2022.
//  Copyright © 2022 fun.sdk.ftel.vn.su4. All rights reserved.
//

@protocol TalkBackControlDelegate <NSObject>
@optional
- (void) talkBackControlStart;
- (void) talkBackControlStop;
- (void) talkBackControlError:(int)param1;
@end
