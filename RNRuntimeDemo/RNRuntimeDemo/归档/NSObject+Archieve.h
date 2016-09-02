//
//  NSObject+Archieve.h
//  RNRuntimeDemo
//
//  Created by 婉卿容若 on 16/9/2.
//  Copyright © 2016年 婉卿容若. All rights reserved.
//

#import <Foundation/Foundation.h>

// 批量归档

@interface NSObject (Archieve)

@property (nonatomic, strong) NSArray *ignoredIvarNames ; // 这个数组中的成员变量将会被忽略: 不进行归档

// 归档
- (void)encode:(NSCoder *)aCoder ;

// 接档
- (void)decode:(NSCoder *)aDecoder ;



@end
