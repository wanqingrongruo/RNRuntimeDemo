//
//  People.h
//  RNRuntimeDemo
//
//  Created by 婉卿容若 on 16/8/31.
//  Copyright © 2016年 婉卿容若. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface People : NSObject
{
    NSString *_ocupation ;
    NSString *_nationality ;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) float height;
@property (nonatomic, copy) NSString *Id;

- (NSDictionary *)allProperties ; // 所有属性

- (NSDictionary *)allIvars ; // 所有变量

- (NSDictionary *)allMethods ; // 所有方法

- (void) sing ; //  有这个方法,但没有这个方法的实现..当我们调用这个方法时,,利用 runtime,在消息解析resolveInstanceMethod这步给类添加方法,并实现

@end
