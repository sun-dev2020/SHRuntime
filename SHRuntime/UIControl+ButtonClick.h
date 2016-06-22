//
//  UIControl+ButtonClick.h
//  SHRuntime
//
//  Created by mac on 15/11/2.
//  Copyright (c) 2015年 treebear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (ButtonClick)

@property(nonatomic, assign) NSTimeInterval acceptEventTime;

@property(nonatomic, assign) BOOL sh_ignoreEvent;


@end
