//
//  People+Associated.m
//  RNRuntimeDemo
//
//  Created by 婉卿容若 on 16/8/31.
//  Copyright © 2016年 婉卿容若. All rights reserved.
//

#import "People+Associated.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation People (Associated)

// 添加属性

- (void) setNewAblum:(NSString *)newAblum
{
    // 设置关联属性
    // 第一个入参: 关联对象
    // 第二个入参: key 值,唯一并且是常量(static char),,我们这里选择子作为 key
    // 第三个入参: 关联类型  OBJC_ASSOCIATION_RETAIN_NONATOMIC 与 (nonatomic,strong) 对应
    /*
     * OBJC_ASSOCIATION_ASSIGN = (assign) or (unsafe_unretained)
     * OBJC_ASSOCIATION_RETAIN_NONATOMIC = (nonatomic,strong)
     * OBJC_ASSOCIATION_COPY_NONATOMIC = (nonatomic,copy)
     * OBJC_ASSOCIATION_RETAIN = (atomic,strong)
     * OBJC_ASSOCIATION_COPY = (atomic,copy)
     */
    objc_setAssociatedObject(self, @selector(newAblum), newAblum, OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
}

- (NSString *)newAblum
{
    // get 关联对象
    return objc_getAssociatedObject(self, @selector(newAblum)) ;
}

// 添加回调 -- 实际开发过程中使用的更多

- (void) setAssociatedCallBack:(CallBack)associatedCallBack
{
    objc_setAssociatedObject(self, @selector(associatedCallBack), associatedCallBack, OBJC_ASSOCIATION_COPY_NONATOMIC) ;
}

- (CallBack)associatedCallBack
{
    return objc_getAssociatedObject(self, @selector(associatedCallBack)) ;
}


@end
