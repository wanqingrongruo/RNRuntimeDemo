//
//  UIViewController+Dealloc.m
//  RNRuntimeDemo
//
//  Created by 婉卿容若 on 16/9/2.
//  Copyright © 2016年 婉卿容若. All rights reserved.
//

#import "UIViewController+Dealloc.h"
#import <objc/runtime.h>

@implementation UIViewController (Dealloc)

// 全局替换 UIViewController 的 dealloc 函数
// 在 load 函数中利用 runtime 交换两个方法的实现

+ (void)load
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        Method nativeDealloc = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc")) ;
        Method myDealloc = class_getInstanceMethod(self, @selector(my_dealloc)) ;
        method_exchangeImplementations(nativeDealloc, myDealloc) ;
    }) ;
}

- (void)my_dealloc
{
    NSLog(@"%@销毁了",self) ;
    [self my_dealloc] ;
}

@end
