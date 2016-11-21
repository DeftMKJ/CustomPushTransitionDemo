//
//  MKJParseHelper.m
//  RedBookTransitionDemo
//
//  Created by MKJING on 16/11/15.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJParseHelper.h"
#import <MJExtension.h>
#import "RedBookModel.h"

@implementation MKJParseHelper

+ (instancetype)shareHelper
{
    static MKJParseHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        helper = [[MKJParseHelper alloc] init];
    });
    return helper;
}


- (void)requestData:(callBack)succeedBlock failure:(callBack)failureBlock
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"plist"];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSArray *lists = [RedBookDetails mj_objectArrayWithKeyValuesArray:array];
    if (succeedBlock) {
        succeedBlock(lists,nil);
    }
}




@end
