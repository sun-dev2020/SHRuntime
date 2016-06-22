//
//  ViewController.m
//  SHRuntime
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 treebear. All rights reserved.
//

#import "ViewController.h"
#import "HookObject.h"
#import <SHFramework/SHFramework.h>
#import <dlfcn.h>
#import "UIControl+ButtonClick.h"
#import "SubStudentModel.h"
#import "SecViewController.h"
#import "SHLibrary.h"
#import "LCNavigationController.h"
@interface ViewController ()
- (void)addMethod;
//@property(nonatomic, copy)NSString *addProperty;
@end

static void *libHandle = NULL;
@implementation ViewController

- (void)btnclicked{
    NSLog(@" btn clicked ");
    [DymicLog sayHelloToSomeone:@"hello"];
    DymicLog *obj = [[DymicLog alloc] init];
    [obj running];
}
- (void)addMethod{
    
}
- (void)testForFramework{
    NSString *documentsPath = [NSString stringWithFormat:@"%@/Documents/SHFramework.framework/SHFramework",NSHomeDirectory()];
    
    
    NSString *documentsPath2 ;
    documentsPath2 = [[NSBundle mainBundle] pathForResource:@"SHFramework" ofType:@"framework"];
    
    [self dlopenLoadDylibWithPath:documentsPath2];
    [self boundleLoadFrameworkWithPath:documentsPath2];
    
}

- (void)dlopenLoadDylibWithPath:(NSString *)path{
    libHandle = dlopen([path cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
    if (libHandle == NULL) {
        char *error = dlerror();
        NSLog(@" dlopen error: %s",error);
    }else{
        NSLog(@" dlopen load success ");
        [self testDymicClass];
    }
}

- (void)boundleLoadFrameworkWithPath:(NSString *)path{
    NSError *error = nil;
    
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    if ([bundle loadAndReturnError:&error]) {
        NSLog(@" load framework success ");
        [self testDymicClass];
    }else{
        NSLog(@" load framework error: %@",error);

    }
}

- (void)testDymicClass{
    Class rootClass = NSClassFromString(@"DymicLog");
    if (rootClass) {
        id object = [[rootClass alloc] init];
        [(DymicLog *)object running];
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    HookObject *hookObj = [[HookObject alloc] init];
    NSLog(@" HookObj: %@ ",hookObj);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnclicked) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(100, 230, 100, 100);
    btn2.backgroundColor = [UIColor redColor];
    [btn2 addTarget:self action:@selector(btnclicked2) forControlEvents:UIControlEventTouchUpInside];
    btn2.acceptEventTime = 3;
    [self.view addSubview:btn];
    [self.view addSubview:btn2];
    [self testForFramework];
    
    NSString *a = [[NSString alloc]initWithFormat:@"aaa"];
    _tm = a;
    a = nil;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Student"]) {
        NSLog(@" exsit ");
    }
    StudentModel *model = [[StudentModel alloc] initWithName:@"SS" andAge:@"20"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Student"];
    NSLog(@" %@ ",model);
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    UIImage *image = [UIImage imageNamed:@"image001"];
    imageV.image = [self getGrayImage:image];
//    [self.view addSubview:imageV];
    
    [SubStudentModel read];


}
- (void)btnclicked2{
    NSLog(@" ttt ");
    SecViewController *sec = [[SecViewController alloc] init];
    LCNavigationController *nv = (LCNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nv pushViewController:sec completion:^{
        
    }];
}


/**
*  将彩色图片变黑白
*
*  @param sourceImage 彩色图
*
*  @return 黑白图
*/
- (UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGBitmapByteOrderDefault);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:grayImageRef];
    CGContextRelease(context);
    CGImageRelease(grayImageRef);
    
    return grayImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
