//
//  BlockTest.m
//  objc-debug
//
//  Created by hechao on 2019/3/1.
//

#import "TestLock.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface TestLock ()


@end

@implementation TestLock

+ (void)load {
    
}
// objc-sync.m
- (instancetype)init {
    self = [super init];
    if (self) {
        @synchronized (self) {
            NSLog(@"xxx0");
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized (self) {
                NSLog(@"xxx1");
            }
        });
    }
    
    return self;
}

@end
