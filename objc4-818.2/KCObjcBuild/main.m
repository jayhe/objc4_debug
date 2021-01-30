//
//  main.m
//  KCObjcBuild
//
//  Created by cooci on 2021/1/5.

// ⚠️编译调试不能过: 请你检查以下几小点⚠️
// ①: enable hardened runtime -> NO
// ②: build phase -> denpendenice -> objc
#import <Foundation/Foundation.h>
#define __APPLE_BLEACH_SDK__
#include "runtime.h"
#include "objc-internal.h"

#define HC_START_CASE(name) NSLog(@"😄😄😄😄%@ begin", name);\
{\

#define HC_END_CASE(name) NSLog(@"😄😄😄😄%@ end", name);\
}\

#define HC_CASE(name,case) \
HC_START_CASE(name) \
case \
HC_END_CASE(name)

uintptr_t testSubc(uintptr_t lhs, uintptr_t rhs, uintptr_t carryin, uintptr_t *carryout);
void subcTestCase(void);
void addcTestCase(void);
void assiciationTestCase(void);
void initializeTestCase(void);
void autoreleaseTestCase(void);
void autoreleaseTestCase1(void);
void weakUsageTestCase(void);
void stringTaggedPointerTestCase(void);

@protocol TestProtocol <NSObject>


@end

@interface TestClass : NSObject

+ (instancetype)testInstance;

@end

@implementation TestClass

//+ (void)initialize {
//    NSLog(@"call initialize: \n");
//    NSLog(@"%@", [NSThread callStackSymbols]);
//}

+ (instancetype)testInstance {
    return [self new];
}

+ (id)testUnretainObj {
    __unsafe_unretained NSObject *obj = [NSObject new];
    return obj;
}

+ (id)testReturnObj {
    return [NSObject new];
}

+ (id)testReturnTmpObj {
    NSObject *obj = [NSObject new];
    return obj;
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        //weakUsageTestCase();
        Protocol *testProtocol = @protocol(TestProtocol);
        // id obj = [[(Class)(testProtocol) alloc] init];
        //subcTestCase();
        //addcTestCase();
        //assiciationTestCase();
        //initializeTestCase();
        //autoreleaseTestCase();
        //autoreleaseTestCase1();
        stringTaggedPointerTestCase();
    }
    return 0;
}

void weakUsageTestCase(void) {
    NSObject *objc = [NSObject alloc];
    __weak typeof(objc) weakObj = objc;
    __weak typeof(objc) weakObj1 = objc;
    __weak typeof(objc) weakObj2 = objc;
    __weak typeof(objc) weakObj3 = objc;
    __weak typeof(objc) weakObj4 = objc;
    __weak typeof(objc) weakObj5 = objc;
    __weak typeof(objc) weakObj6 = objc;
    __weak typeof(objc) weakObj7 = objc;
    __weak typeof(objc) weakObj8 = objc;
    __weak typeof(objc) weakObj9 = objc;
}

void subcTestCase(void) {
    uintptr_t carryout;
    {
        uintptr_t left = 1;
        uintptr_t result = __builtin_subcl(left, 1, 0, &carryout);
        NSLog(@"case0: result = %lu carryout = %lu", result, carryout); // case0: result = 0 carryout = 0
    }
    {
        uintptr_t left = 2;
        uintptr_t result = __builtin_subcl(left, 1, 0, &carryout);
        NSLog(@"case1: result = %lu carryout = %lu", result, carryout); // case1: result = 1 carryout = 0
    }
    {
        uintptr_t left = 0;
        uintptr_t result = __builtin_subcl(left, 1, 0, &carryout);
        NSLog(@"case2: result = %lu carryout = %lu", result, carryout); // case2: result = 18446744073709551615 carryout = 1
    }
    {
        uintptr_t left = 0;
        uintptr_t result = __builtin_subcl(left, 5, 0, &carryout);
        NSLog(@"case3: result = %lu carryout = %lu", result, carryout); // case3: result = 18446744073709551611 carryout = 1
    }
}

uintptr_t testSubc(uintptr_t lhs, uintptr_t rhs, uintptr_t carryin, uintptr_t *carryout) {
    return __builtin_subcl(lhs, rhs, carryin, carryout);
}

void addcTestCase(void) {
    // unsigned long uintptr_t
    uintptr_t borrowed = (1ULL<<7);
    uintptr_t right = (1ULL<<56) * (borrowed - 1);
    uintptr_t overflow;
    {
        uintptr_t left = 1ULL<<63;
        uintptr_t result = __builtin_addcl(left, right, 0, &overflow);
        NSLog(@"case0: result = %lu overflow = %lu", result, overflow); // case0: result = 18374686479671623680 overflow = 0
    }
    {
        uintptr_t left = NSUIntegerMax - 1;
        uintptr_t result = __builtin_addcl(left, right, 0, &overflow);
        NSLog(@"case1: result = %lu overflow = %lu", result, overflow); // case1: result = 9151314442816847870 overflow = 1
    }
}

void assiciationTestCase(void) {
    static char *kAssociationKey;
    static char *kAssociationKey1;
    NSObject *holderObj = [NSObject new];
    NSString *associationObj = @"test";
    objc_setAssociatedObject(holderObj, &kAssociationKey, associationObj, 1); // OBJC_ASSOCIATION_RETAIN_NONATOMIC
    objc_setAssociatedObject(holderObj, &kAssociationKey, @"changed", 1);
    objc_getAssociatedObject(holderObj, &kAssociationKey);
//    NSObject *holderObj1 = [NSObject new];
//    NSString *associationObj1 = @"test1";
//    objc_setAssociatedObject(holderObj1, &kAssociationKey1, associationObj1, 01401); // OBJC_ASSOCIATION_RETAIN
//    objc_getAssociatedObject(holderObj1, &kAssociationKey1);
}

void initializeTestCase(void) {
    HC_CASE(@"case1",
            [TestClass initialize]; // 这里会调用2次initialize
            );
    HC_CASE(@"case2",
            Class cls = object_getClass(TestClass.class); // class会调用 objc_opt_class
            void(*initializeImp)(id, SEL) = class_getMethodImplementation(cls, @selector(initialize)); // lookUpImpOrNil
            initializeImp(cls, @selector(initialize));
            );
}

void autoreleaseTestCase(void) {
    TestClass *test = [TestClass testInstance];
}

void autoreleaseTestCase1(void) {
    __unsafe_unretained id testObj = [TestClass testInstance];
}

void stringTaggedPointerTestCase(void) {
    NSString *test = [NSString stringWithFormat:@"%c", 'y'];
    NSLog(@"%p value:0x%lx %@ %@", test, _objc_getTaggedPointerValue((__bridge const void *)test), test, object_getClass(test));
    // 0xaf548e8076289e35 value:0x791 y NSTaggedPointerString
    NSString *test1 = [NSString stringWithFormat:@"%c%c", 'y', 'y'].copy;
    NSLog(@"%p value:0x%lx %@ %@", test1, _objc_getTaggedPointerValue((__bridge const void *)test1), test1, object_getClass(test1));
    // 0xaf548e8076519e05 value:0x79792 yy NSTaggedPointerString
    NSString *test2 = [NSString stringWithFormat:@"%@", @"11111111111"];
    NSLog(@"%p value:0x%lx %@ %@", test2, _objc_getTaggedPointerValue((__bridge const void *)test2), test2, object_getClass(test2));
    // 0xd48a793d99533995 value:0x7bdef7bdef7bdeb 11111111111 NSTaggedPointerString
    NSString *test3 = [NSString stringWithFormat:@"%@", @"yyyyyyyyy"]; // y对于的ASCII是0x79 == 0111 1001 如果用ASCII来编码那么64位已经不够了，系统内部做了特殊的编码处理
    NSLog(@"%p value:0x%lx %@ %@", test3, _objc_getTaggedPointerValue((__bridge const void *)test3), test3, object_getClass(test3));
    // 0xa4dfc14b2e783555 value:0x259659659659659 yyyyyyyyy NSTaggedPointerString
}
