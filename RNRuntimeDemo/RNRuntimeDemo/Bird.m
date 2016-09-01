//
//  Bird.m
//  RNRuntimeDemo
//
//  Created by 婉卿容若 on 16/9/1.
//  Copyright © 2016年 婉卿容若. All rights reserved.
//

#import "Bird.h"
#import "People.h"

@implementation Bird

// 第一步: 我们不动态添加方法,返回 NO, 进入第二步.....我们一般在声明了方法但没有实现的情况下,在这步解析中给对象添加方法

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return NO ;
}

// 第二步: 指定备选对象来响应 aSelector
// 当有备选对象响应,消息处理;没有则进入第三步
- (id)forwardingTargetForSelector:(SEL)aSelector
{
//    // 情况一: 有备选备选响应
//    People *p = [[People alloc] init] ;
//    
//    return p ;
    
    // 情况二: 无备选对象响应
    return nil ;
}

// 第三步: 返回方法签名,进入第四步,,,如果返回 nil, 则消息无法处理

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    
    // 情况一 : 返回签名
    if ([NSStringFromSelector(aSelector) isEqualToString:@"sing"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"] ;
    }
    
    return [super methodSignatureForSelector:aSelector] ;
//    
//    // 情况二 : 返回 nil
//    return  nil ;
}

// 第四步: 通过 aInvacation 对象做各种不同的处理,例如修改方法实现,修改响应对象等等

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
//    // 1: we change the object which is called
//    People *p = [[People alloc] init] ;
//    p.name = @"hahhahahah" ;
//    [anInvocation invokeWithTarget:p] ;
    
    // 2: we change the impelement of the method
    [anInvocation setSelector:@selector(dance)] ;
    [anInvocation invokeWithTarget:self] ; // 这里我们还要指定哪个对象来实现....如果指定的方法是别的类的,对该类进行声明...我们这里用的是自己类的方法,所以用 self
   // [anInvocation invoke] ; // invoke 方法默认调用的对象是 self,与 [anInvocation invokeWithTarget:self] ; 作用相同
}


// 消息无法处理时进入这里,,如果没有实现这个方法则程序 crash
- (void) doesNotRecognizeSelector:(SEL)aSelector
{
 
    NSLog(@"没有找到该方法!!!!") ;
}

- (void)dance
{
    NSLog(@"你竟然跳舞了!!!") ;
}

@end
