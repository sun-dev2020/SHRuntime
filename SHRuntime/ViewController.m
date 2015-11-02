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

@interface ViewController ()

@end

static void *libHandle = NULL;
@implementation ViewController

- (void)btnclicked{
    NSLog(@" btn clicked ");
    [DymicLog sayHelloToSomeone:@"hello"];
    DymicLog *obj = [[DymicLog alloc] init];
    [obj running];
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
}
- (void)btnclicked2{
    NSLog(@" ttt ");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
