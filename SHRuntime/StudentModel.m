//
//  StudentModel.m
//  SHRuntime
//
//  Created by mac on 15/11/6.
//  Copyright (c) 2015年 treebear. All rights reserved.
//

#import "StudentModel.h"
#import <objc/runtime.h>

@implementation StudentModel



-(instancetype)initWithName:(NSString *)name andAge:(NSString *)age{
    self = [super init];
    if (self) {
        _age = age;
        _name = name;
        _location = @"HZ";
    }
    return self;
}

/**
*  返回所有对象名称
*
*  @return
*/
+(NSArray *)propertyOfSelf{
    unsigned int count;

    //获取类中成员变量列表
    Ivar *ivarList = class_copyIvarList(self, &count);
    NSMutableArray *properNames = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        //遍历变量，获取变量name
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key = [name substringFromIndex:1];
        [properNames addObject:key];
    }
    return [properNames copy];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSArray *properNames = [[self class] propertyOfSelf];
    for (NSString *name in properNames) {
        SEL getSel = NSSelectorFromString(name);
        [aCoder encodeObject:[self performSelector:getSel] forKey:name];
    }
//    [aCoder encodeObject:_name forKey:@"name"];
//    [aCoder encodeObject:_age forKey:@"age"];
//    [aCoder encodeObject:_location forKey:@"location"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        NSArray *properNames = [[self class] propertyOfSelf];
        for (NSString *propertyName in properNames) {
            NSString *firstCharater = [propertyName substringToIndex:1].uppercaseString;
            NSString *setPropertyName = [NSString stringWithFormat:@"set%@%@:",firstCharater,[propertyName substringFromIndex:1]];
            SEL setSel = NSSelectorFromString(setPropertyName);
            [self performSelector:setSel withObject:[aDecoder decodeObjectForKey:propertyName]];
        }
        
//        _name = [aDecoder decodeObjectForKey:@"name"];
//        _age = [aDecoder decodeObjectForKey:@"age"];
//        _location = [aDecoder decodeObjectForKey:@"location"];
        
    }
    return self;
}

- (NSString *)description{
    NSMutableString *descriptionString = [NSMutableString stringWithFormat:@"\n"];
    NSArray *properNames = [[self class] propertyOfSelf];
    for (NSString *propertyName in properNames) {
        SEL getSel = NSSelectorFromString(propertyName);
        NSString *propertyNameString = [NSString stringWithFormat:@"%@ - %@",propertyName,[self performSelector:getSel]];
        [descriptionString appendString:propertyNameString];
    }
    return [descriptionString copy];
}
@end
