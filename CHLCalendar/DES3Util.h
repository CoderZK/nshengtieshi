//
//  DES3Util.h
//  jiajiami
//
//  Created by kunzhang on 2019/8/3.
//  Copyright © 2019年 kunzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DES3Util : NSObject
+ (NSString*)encrypt:(NSString*)plainText;
// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;
@end






NS_ASSUME_NONNULL_END
