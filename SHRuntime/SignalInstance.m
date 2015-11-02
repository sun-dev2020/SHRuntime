//
//  SignalInstance.m
//  SHRuntime
//
//  Created by mac on 15/9/30.
//  Copyright (c) 2015年 treebear. All rights reserved.
//

#import "SignalInstance.h"

@implementation SignalInstance

static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}

+ (instancetype)sharedInstanceTool{
    @synchronized(self){
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return _instance;
}

@end
