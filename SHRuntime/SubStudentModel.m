//
//  SubStudentModel.m
//  SHRuntime
//
//  Created by mac on 15/11/9.
//  Copyright (c) 2015年 treebear. All rights reserved.
//

#import "SubStudentModel.h"
#import "StudentModel.h"
@implementation SubStudentModel

- (instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@" %@ ",NSStringFromClass([self class]));
        NSLog(@" %@ ",NSStringFromClass([super class]));
        
        //此处2次输出均为SubStudentModel
        //第二个调用super class,但父类studentModel中没有对class的实现，继续向上查找到NSObject类，而NSObject对class的实现就是返回对象的类别  因此和self class的调用是一样的
        
        BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];        //判断是否是这个类或者这个类的子类的实例
        BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];      //判断是否是这个类的实例
        BOOL res3 = [(id)[StudentModel class] isKindOfClass:[NSObject class]];
        BOOL res4 = [(id)[SubStudentModel class] isMemberOfClass:[StudentModel class]];

        NSLog(@" %d  %d  %d  %d",res1,res2,res3,res4);
    }
    return self;
}

-(void)read{
    NSLog(@"substudenr read");
}

@end
