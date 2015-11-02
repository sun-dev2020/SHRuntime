//
//  HookObject.m
//  SHRuntime
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 treebear. All rights reserved.
//

#import "HookObject.h"
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation HookObject

//FROM: http://www.cnblogs.com/smileEvday/archive/2013/02/28/Hook.html

+ (void)initialize{
    // 获取UIWindow中sendEvent对于的method
    Method sendEvent = class_getInstanceMethod([UIWindow class], @selector(sendEvent:));
    
    unsigned int count = 0 ;
    Ivar *members = class_copyIvarList([UIWindow class], &count);
//    NSLog(@" window methods : %@ ",methods);
    for (int i = 0; i<count; i++) {
        Ivar var = members[i];
        const char *memberName = ivar_getName(var);
        const char *memberType = ivar_getTypeEncoding(var);
        NSLog(@" %s ---%d--- %s ",memberName,i, memberType);
    }
    
    Method sendEventMyself = class_getInstanceMethod([self class], @selector(sendEventHooked:));

    // 1.将uiwindow的sendevent方法绑定到sendEventOriginal方法上
    IMP sendEventImp = method_getImplementation(sendEvent);
    class_addMethod([UIWindow class], @selector(sendEventOriginal:), sendEventImp, method_getTypeEncoding(sendEvent));
    
    // 2.将UIWindow原生sendEvent重定向给 HookObject的自定义方法
    IMP sendEventMyselfImp = method_getImplementation(sendEventMyself);
    class_replaceMethod([UIWindow class], @selector(sendEvent:), sendEventMyselfImp, method_getTypeEncoding(sendEvent));
    //第一步和第二部 顺序固定  不然sendEventOriginal执行内容和sendEventHooked一样，造成死循环
}

- (void)sendEventHooked:(UIEvent *)event{
    NSLog(@" this is my self sendEevntMethod ");
    // 这里相当于[super sendEvent] ,因为原生的sendEvent已经指向了别的函数，我们将新增的函数替换原生的sendEvent
    //***** 如果这里将执行函数改成sendEvent 会造成循环
    //***** 在运行时self其实是代表UIWindow，所以使用HookObject的属性会crash
//    self.number = 10;
    NSLog(@" self :%@ ",self);
    [self performSelector:@selector(sendEventOriginal:) withObject:event];
}

/**
*  下面的方法并不会被调用，因为运行时self是window
*
*  @param event 
*/
- (void)sendEventOriginal:(UIEvent *)event{
    NSLog(@" this is eventoriginal ");
}

@end
