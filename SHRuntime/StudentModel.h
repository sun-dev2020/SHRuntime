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

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *age;
@property(nonatomic, strong) NSString *location;

-(Class)class;

-(instancetype)initWithName:(NSString *)name andAge:(NSString *)age;
+(NSArray *)propertyOfSelf;



@end
