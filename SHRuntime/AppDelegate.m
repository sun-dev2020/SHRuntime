//
//  AppDelegate.m
//  SHRuntime
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 treebear. All rights reserved.
//

#import "AppDelegate.h"
#import "HookObject.h"
#import "LCNavigationController.h"
#import "NSObject+Sark.h"
#import "JSONKit.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    // Override point for customization after application launch.
    ViewController* v = [[ViewController alloc] initWithNibName:nil bundle:nil];
    v.addProperty = @"123";
    NSLog(@" Addproperty: %@ ", v.addProperty);

    LCNavigationController* nv = [[LCNavigationController alloc] initWithRootViewController:v];
    self.window.rootViewController = nv;
    [self.window makeKeyAndVisible];

    [self testForCopy];

    [self testForArray];

    [NSObject read];

    NSString* fileString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DPIrule" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@" file %@ ", fileString);
    NSMutableArray* array = (NSMutableArray *)[fileString componentsSeparatedByString:@"\n"];
    NSMutableArray* allArr = [NSMutableArray array];
//     [array removeLastObject];
    for (NSString* url in array) {
        NSArray* urlArr = [url componentsSeparatedByString:@","];
        NSLog(@" arr %@ ",urlArr);
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:urlArr[2], @"source", urlArr[1], @"keyword", urlArr[0], @"pattern", nil];
        [allArr addObject:dic];
    }
    NSLog(@"%d", [NSJSONSerialization isValidJSONObject:allArr]);
    NSDictionary* result = [NSDictionary dictionaryWithObjectsAndKeys:allArr, @"DPIRules", nil];
    NSData* data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
    NSString* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    

    BOOL save = [[NSFileManager defaultManager] createFileAtPath:[[NSBundle mainBundle] pathForResource:@"dpi_rule" ofType:@"json"] contents:data attributes:nil];

    NSLog(@" obj %@  save %@ ", json, [result JSONString]);
    return YES;
}
- (void)testForArray
{
    //marr声明属性是weak时，使用alloc init完后会被release
    _marr = [[NSMutableArray alloc] init]; // 创建方式1：该方法会有警告，不能像数组中添加元素。
    _marr = [NSMutableArray array]; //  创建方式2：该法没有警告，可以向数组中添加元素。
    [self.marr addObject:@"asdad"];
}

- (void)applicationWillResignActive:(UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)testForCopy
{
    NSMutableString* string = [NSMutableString stringWithString:@"origin"];
    //copy
    NSString* stringCopy = [string copy];
    NSMutableString* mStringCopy = [string copy];
    NSMutableString* stringMCopy = [string mutableCopy];
    //change value
    //    [mStringCopy appendString:@"mm"]; //crash
    [string appendString:@" origion!"];
    [stringMCopy appendString:@"!!"];

    NSLog(@" %@, %@ ,%@ , %@ ", string, mStringCopy, stringCopy, stringMCopy);

    NSString* abc = @"abc";
    NSString* bbb = abc;
    abc = @"ccc";
    abc = nil;
    NSLog(@" bbb %@", bbb);
}

@end
