//
//  People.m
//  RNRuntimeDemo
//
//  Created by 婉卿容若 on 16/8/31.
//  Copyright © 2016年 婉卿容若. All rights reserved.
//

#import "People.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation People

- (instancetype) init
{
    self = [super init] ;
    
    if (self) {
        
        _name = @"许嵩" ;
    }
    
    return self ;
}

- (NSDictionary *) allProperties
{
    unsigned int count = 0 ;
    
    // 获取类的所有属性,如果没有属性 count 就为0
    objc_property_t *properties = class_copyPropertyList([self class], &count) ;
    NSMutableDictionary *resultDict = [@{} mutableCopy];
    
    for (NSUInteger i = 0; i < count; i++) {
        
        // 获取属性的名称和值
        const char *propertyName = property_getName(properties[i]) ;
        NSString *name = [NSString stringWithUTF8String:propertyName] ;
        
        id propertyValue = [self valueForKey:name] ;
        
        if (propertyValue) {
            resultDict[name] = propertyValue ;
        }else{
            resultDict[name] = @"value值不能为 nil" ;
        }
    }
    
    free(properties) ;// 这里的 properties 是一个数组指针,我们需要使用 free 函数来释放内存
    
    return resultDict ;
}

- (NSDictionary *) allIvars
{
    unsigned int count = 0 ;
    
    // 获取类的所有变量,如果没有属性 count 就为0
    Ivar *ivars = class_copyIvarList([self class], &count) ;
    NSMutableDictionary *resultDict = [@{} mutableCopy];
    
    for (NSUInteger i = 0; i < count; i++) {
        
        // 获取变量的名称和值
        const char *propertyName = ivar_getName(ivars[i]) ;
        NSString *name = [NSString stringWithUTF8String:propertyName] ;
        
        id ivarValue = [self valueForKey:name] ;
        
        if (ivarValue) {
            resultDict[name] = ivarValue ;
        }else{
            resultDict[name] = @"value值不能为 nil" ;
        }
    }
    
    free(ivars) ;// 这里的 ivars 是一个数组指针,我们需要使用 free 函数来释放内存
    
    return resultDict ;
}

- (NSDictionary *)allMethods
{
    unsigned int count = 0 ;
    
    // 获取类的所有方法,如果没有属性 count 就为0
    Method *methods = class_copyMethodList([self class], &count) ;
    NSMutableDictionary *resultDict = [@{} mutableCopy];
    
    for (NSUInteger i = 0; i < count; i++) {
        
        // 获取方法的名称
        SEL methodSel = method_getName(methods[i]) ;
        const char *methodName = sel_getName(methodSel) ;
        NSString *name = [NSString stringWithUTF8String:methodName] ;
        
        // 获取方法的参数列表
        int arguments = method_getNumberOfArguments(methods[i]) ;
        
        // 有两个默认参数
        resultDict[name] = @(arguments-2) ;
    }
    
    free(methods) ;// 这里的 methods 是一个数组指针,我们需要使用 free 函数来释放内存
    
    return resultDict ;

}

// 当我们调用

+ (BOOL) resolveInstanceMethod:(SEL)sel
{
    NSString *sel_string = NSStringFromSelector(sel) ;
    
    
    // 我们没有给People类声明sing方法，我们这里动态添加方法
    if ([sel_string isEqualToString:@"sing"]) {
        
        /**
         *  动态的给某个类添加方法
         *
         *  @param self  给哪个类添加方法
         *  @param sel   添加方法的方法编号（选择子）
         *  @param IMP   添加方法的函数实现(函数地址)
         *  @param types 函数的类型,(返回值+参数类型) v:void @:对象->self :表示SEL->_cmd
         */
        class_addMethod(self, sel, (IMP) singAction, "v@:") ;
        
        return true ;
    }
    
    
    return [super resolveInstanceMethod:sel] ;
}

void singAction(id self, SEL cmd)
{
    NSLog(@"%@ 唱歌啦!",((People *)self).name) ;
}

@end
