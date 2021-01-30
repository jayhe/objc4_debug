//
//  TestLoad.m
//  KCObjcBuild
//
//  Created by 贺超 on 2021/1/12.
//

#import "TestLoad.h"

@implementation TestLoad

+ (void)load {
    NSLog(@"%s", __FUNCTION__);
}

- (void)doSth {
    NSLog(@"%s", __FUNCTION__);
}

@end

@interface TestLoad (Test0)

@end

@implementation TestLoad(Test0)

+ (void)load {
    NSLog(@"%s", __FUNCTION__);
}

@end

@interface TestLoad (Test1)

@end

@implementation TestLoad(Test1)

+ (void)load {
    NSLog(@"%s", __FUNCTION__);
}

@end

@interface TestLoad (Test2)

@end

@implementation TestLoad(Test2)

+ (void)load {
    NSLog(@"%s", __FUNCTION__);
}

@end
