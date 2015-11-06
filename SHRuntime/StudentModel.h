//
//  StudentModel.h
//  SHRuntime
//
//  Created by mac on 15/11/6.
//  Copyright (c) 2015年 treebear. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
*  用runtime归档数据对象
*/

@interface StudentModel : NSObject<NSCoding>

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *age;
@property(nonatomic, copy) NSString *location;

+(NSArray *)propertyOfSelf;

@end
