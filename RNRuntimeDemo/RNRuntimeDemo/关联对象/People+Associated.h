//
//  People+Associated.h
//  RNRuntimeDemo
//
//  Created by 婉卿容若 on 16/8/31.
//  Copyright © 2016年 婉卿容若. All rights reserved.
//

#import "People.h"

typedef void (^CallBack)(); // 回调

@interface People (Associated)

@property (nonatomic,strong) NSString *newAblum ; // 新专辑
@property (nonatomic,copy) CallBack associatedCallBack ; // 回调

@end
