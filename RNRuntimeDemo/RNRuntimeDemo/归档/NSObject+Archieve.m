//
//  NSObject+Archieve.m
//  RNRuntimeDemo
//
//  Created by 婉卿容若 on 16/9/2.
//  Copyright © 2016年 婉卿容若. All rights reserved.
//

#import "NSObject+Archieve.h"
#import <objc/runtime.h>


@implementation NSObject (Archieve)

- (void)setIgnoredIvarNames:(NSArray *)ignoredIvarNames
{
    objc_setAssociatedObject(self, @selector(ignoredIvarNames),ignoredIvarNames, OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
}

- (NSArray *)ignoredIvarNames
{
    return  objc_getAssociatedObject(self, @selector(ignoredIvarNames)) ;
}

- (void)encode:(NSCoder *)aCoder
{
    unsigned int outCount = 0 ;
    Ivar *ivars = class_copyIvarList([self class], &outCount) ;
    for (unsigned int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i] ;
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)] ;
        if ([self.ignoredIvarNames containsObject:key]) {
            continue ;
        }
        
        id value = [self valueForKey:key] ;
        [aCoder encodeObject:value forKey:key] ;
    }
    
    free(ivars) ;
}

- (void)decode:(NSCoder *)aDecoder
{
    unsigned int outCount = 0 ;
    Ivar *ivars = class_copyIvarList([self class], &outCount) ;
    for (unsigned int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i] ;
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)] ;
        if ([self.ignoredIvarNames containsObject:key]) {
            continue ;
        }
        
        id value = [aDecoder decodeObjectForKey:key] ;
        [self setValue:value forKey:key] ;
    }
    
    free(ivars) ;

}


@end
