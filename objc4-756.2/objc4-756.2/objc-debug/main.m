//
//  main.m
//  objc-debug
//
//  Created by hc on 2019/10/9.
//

#import <Foundation/Foundation.h>
#import "TestLock.h"

static void testMethod(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        {
            NSObject *object = [[NSObject alloc] init];
            __weak typeof (object) weakObj = object; // objc_initWeak -- storeWeak<DontHaveOld, DoHaveNew, DoCrashIfDeallocating>(location, (objc_object*)newObj);
            __weak typeof (object) weakObj1 = object; // objc_initWeak -- storeWeak<DontHaveOld, DoHaveNew, DoCrashIfDeallocating>(location, (objc_object*)newObj);
            NSObject *object1 = [[NSObject alloc] init];
            weakObj1 = object1; // objc_storeWeak -- storeWeak<DoHaveOld, DoHaveNew, DoCrashIfDeallocating>(location, (objc_object *)newObj) -- weak_unregister_no_lock(&oldTable->weak_table, oldObj, location);
            NSLog(@"Hello, World! %@",object);
        }// 过了作用域对象释放的时候：objc_destroyWeak -- (void)storeWeak<DoHaveOld, DontHaveNew, DontCrashIfDeallocating>(location, nil) -- weak_unregister_no_lock(&oldTable->weak_table, oldObj, location);
        [TestLock new];
        //NSArray *array = [NSArray arrayWithObject:@"1"];
        //array[2];
    }
    return 0;
}

// #1    0x000000010002315d in ImageLoaderMachO::doModInitFunctions(ImageLoader::LinkContext const&) ()
__attribute__((constructor(1))) static void AttributeUsageConstructor(void) {
    NSLog(@"Excute before main");
}
// #1    0x000000010002315d in ImageLoaderMachO::doModInitFunctions(ImageLoader::LinkContext const&) ()

__attribute__((destructor)) static void AttributeUsageDestructor(void) {
    NSLog(@"Excute after main");
}
