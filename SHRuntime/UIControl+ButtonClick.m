//
//  UIControl+ButtonClick.m
//  SHRuntime
//
//  Created by mac on 15/11/2.
//  Copyright (c) 2015年 treebear. All rights reserved.
//


#import "UIControl+ButtonClick.h"
#import <objc/runtime.h>


static const char *UIControl_ignoreEvent = "UIControl_ignoreEvent";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";
@implementation UIControl (ButtonClick)


- (NSTimeInterval)acceptEventTime{
    return [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}
-(BOOL)sh_ignoreEvent{
    return [objc_getAssociatedObject(self, UIControl_ignoreEvent) boolValue];
//    return self.sh_ignoreEvent;
}
-(void)setSh_ignoreEvent:(BOOL)sh_ignoreEvent{
    objc_setAssociatedObject(self, UIControl_ignoreEvent, @(sh_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    self.sh_ignoreEvent = sh_ignoreEvent;
}
- (void)setAcceptEventTime:(NSTimeInterval)acceptEventTime{
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**

*/
/**
*  load在类所在的文件被引用时就会执行，init是实例初始化时执行
*/
+ (void)load{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(otherSendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}

- (void)otherSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (self.sh_ignoreEvent) {
        return;
    }
    if (self.acceptEventTime > 0) {
        self.sh_ignoreEvent = YES;
        [self performSelector:@selector(setSh_ignoreEvent:) withObject:@(NO) afterDelay:self.acceptEventTime];
    }
    [self otherSendAction:action to:target forEvent:event];
}

@end
