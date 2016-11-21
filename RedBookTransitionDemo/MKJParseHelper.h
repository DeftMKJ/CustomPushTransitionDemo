//
//  MKJParseHelper.h
//  RedBookTransitionDemo
//
//  Created by MKJING on 16/11/15.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^callBack)(id obj,NSError *error);

@interface MKJParseHelper : NSObject

+ (instancetype)shareHelper;

- (void)requestData:(callBack)succeedBlock failure:(callBack)failureBlock;

@end
