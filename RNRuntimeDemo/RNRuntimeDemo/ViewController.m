//
//  ViewController.m
//  RNRuntimeDemo
//
//  Created by 婉卿容若 on 16/8/30.
//  Copyright © 2016年 婉卿容若. All rights reserved.
//

#import "ViewController.h"

//#if TARGET_IPHONE_SIMULATOR
//#import <objc/objc-runtime>
//#esle
//#import <objc/runtime.h>
//#import <objc/message.h>
//#endif
#import <objc/runtime.h>
#import <objc/message.h>

typedef NS_ENUM(NSInteger, ModuleType){
    ModuleTypeAssociateObject = 0, // 关联对象
    ModuleTypeMethodSwizzling = 1, // 方法交换
    ModuleTypeArchieve = 2,        // 归档
    ModuleTypeDictionaryToModel = 3 // 字典转模型
};

@interface ViewController ()

@property (nonatomic,copy) NSArray *datas ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createPersonClass] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 动态创建一个类

- (void) createPersonClass
{
    // 创建一个名为 Person 的类,它是 NSObject 的子类
    Class Person = objc_allocateClassPair([NSObject class], "Person", 0) ;
    
    
    /**
     *  为该类添加一个 eat 的方法 class_addMethod(Class cls, SEL name, IMP imp, const char *types)
     *
     *  @param cls    被添加方法的类
     *  @param name   可以理解为方法名,貌似可以随便起名
     *  @param imp    实现这个方法的函数
     *  @param types  一个定义该函数的返回值类型和参数类型的字符串
     *
     */
    // 关于参数二与参数三
    // 参数二是方法的声明,参数三是方法的实现,,实例对象调用方法(参数二)执行参数三里面的内容
    
    // 关于最后一个参数的解释
    // "v@:@"
    // v -> 表示 void, 如果是 i 则表示 int
    // @ -> 表示参数 id (self)
    // : -> 表示 SEL(_cmd)
    // @ -> 表示 id(str) ,当没有参数时不写,当多个参数是就写多个
    SEL eat = sel_registerName("eat: day:") ;
    class_addMethod(Person, eat, (IMP) eatFun, "v@:@@");
    
    
    // 注册该类
    objc_registerClassPair(Person);
    
    // 创建一个实例对象
    id p = [[Person alloc] init] ;
    
    // performSelector 是运行时负责去找方法的,在编译时不做任何校验
   //[p performSelector:@selector(eat)] ;
    
    
     ((void (*)(id, SEL, id))objc_msgSend)(p,eat, @"香蕉") ;
}

#pragma Mark - event response

/**
 *  默认方法都有两个隐式参数 self 和 _cmd
 
 *
 *  @param self <#self description#>
 *  @param _cmd <#_cmd description#>
 *  @param food <#food description#>
 */
void eatFun(id self, SEL _cmd, NSString *food, NSString *day)
{
    NSLog(@"This object is %p", self);
    NSLog(@"Class is %@ ,and super is %@", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 0; i < 5; i++)
    {
        NSLog(@"Folling the isa pointer %d times gives %p", i, currentClass);
        currentClass = object_getClass(currentClass);
    }
    
    NSLog(@"NSObject‘s class is %p", [NSObject class]);
    NSLog(@"NSObject‘s metaClass is %p", [NSObject class]);
}

@end
