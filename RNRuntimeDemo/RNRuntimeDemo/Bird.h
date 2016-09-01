//
//  Bird.h
//  RNRuntimeDemo
//
//  Created by 婉卿容若 on 16/9/1.
//  Copyright © 2016年 婉卿容若. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bird : NSObject

@property (nonatomic,copy) NSString *name ;


// 我们不给小鸟声明 sing 方法,但是我们会调用 sing 方法,,在消息解析步骤中,将 sing 方法替换成 People 的 sing 方法

@end
