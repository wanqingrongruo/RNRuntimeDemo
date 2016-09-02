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

#import "People.h"
#import "People+Associated.h"
#import "Bird.h"

#import "RNSecondViewController.h"

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
    
//    [self createPersonClass] ;
//    
//    [self useAssociation] ;
    
   
    [self dicAndModel] ;
    
//    RNSecondViewController *sec = [[RNSecondViewController alloc] init] ;
//    [self.navigationController pushViewController:sec animated:true] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"wowoowowo") ;
}

#pragma mark - 关联对象的运用

- (void) useAssociation
{
    People *vae = [[People alloc]init] ;
    vae.name = @"许嵩" ;
    vae.age = @30 ;
    [vae setValue:@(180) forKey:@"height"] ;
    [vae setValue:@"860514" forKey:@"Id"] ;
    vae.newAblum = @"青年晚报" ;
    vae.associatedCallBack = ^(){
       
        NSLog(@"许老师也开始写代码了") ;
    } ;
    
    
    NSLog(@"%@今年%@,身高%f,id为%@,最新专辑是%@",vae.name,vae.age,vae.height,vae.Id,vae.newAblum) ;
    vae.associatedCallBack() ;
    
    
    NSLog(@"所有属性:%@",[vae allProperties]) ;
    NSLog(@"===============================") ;
    NSLog(@"所有变量:%@",[vae  allIvars]) ;
    NSLog(@"===============================") ;
    NSLog(@"所有方法:%@",[vae  allMethods]) ;
    
   // [vae sing] ;
    
    Bird *b = [[Bird alloc] init] ;
    ((void (*)(id, SEL))objc_msgSend)((id)b, @selector(sing)) ;
    
}

- (void)dicAndModel
{
    NSDictionary *dict = @{
                           @"name" : @"苍井空",
                           @"age"  : @(18),
                           @"occupation" : @"老师",
                           @"nationality" : @"日本"
                           };
    
    // 字典转模型
    People *cangTeacher = [[People alloc] initWithDictionary:dict];
    NSLog(@"热烈欢迎，从%@远道而来的%@岁的%@%@",cangTeacher.nationality,cangTeacher.age,cangTeacher.name,cangTeacher.occupation);
    
    // 模型转字典
    NSDictionary *covertedDict = [cangTeacher coverToDictionary];
    NSLog(@"%@",covertedDict);

}

#pragma mark - 动态创建一个类

- (void) createPersonClass
{
    // 动态创建对象: 创建一个名为 Person 的类,它是 NSObject 的子类
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
    SEL eat = sel_registerName("eat:") ; // 注册 eat 方法
    class_addMethod(Person, eat, (IMP) eatFun, "v@:@") ;
    
    // 为该类添加成员变量
    class_addIvar(Person, "_name", sizeof(NSString*), log2(sizeof(NSString*)), @encode(NSString*)) ; // NSString
    class_addIvar(Person, "_age", sizeof(int), sizeof(int), @encode(int)) ; // int
    
    
    
    // 注册该类
    objc_registerClassPair(Person);
    
    // 创建一个实例对象
    id p = [[Person alloc] init] ;
    
    // KVC 动态改变对象的实例变量
    [p setValue:@"许嵩" forKey:@"name"] ;
    [p setValue:@29 forKey:@"age"] ;
    
    // 从类中获取成员变量并赋值
    Ivar ageIvar = class_getInstanceVariable(Person, "_age") ;
    object_setIvar(p, ageIvar, @30) ;
    
    // performSelector 是运行时负责去找方法的,在编译时不做任何校验
   //[p performSelector:@selector(eat)] ;
    
    // 调用 eat 方法,这么写好点(需要引入 <objc/message.h> )
    // 强制转换objc_msgSend函数类型为带三个参数且返回值为void函数，然后才能传三个参数
     ((void (*)(id, SEL, id))objc_msgSend)(p,eat, @"香蕉") ;
    
    p = nil ; // 当 Person 类或者它的子类的实例还存在,则不能调用 objc_disposeClassPair 这个方法.因此必须先销毁实例才能销毁类
    
    objc_disposeClassPair(Person) ; // 销毁类
}

#pragma Mark - event response

/**
 *  默认方法都有两个隐式参数 self 和 _cmd
 
 *
 *  @param self <#self description#>
 *  @param _cmd <#_cmd description#>
 *  @param food <#food description#>
 */
void eatFun(id self, SEL _cmd, NSString *food)
{
    
    NSLog(@"%@今年%@岁,正在吃%@",[self valueForKey:@"name"],object_getIvar(self, class_getInstanceVariable([self class], "_age")),food);
//    NSLog(@"This object is %p", self);
//    NSLog(@"Class is %@ ,and super is %@", [self class], [self superclass]);
//    
//    Class currentClass = [self class];
//    for (int i = 0; i < 5; i++)
//    {
//        NSLog(@"Folling the isa pointer %d times gives %p", i, currentClass);
//        currentClass = object_getClass(currentClass);
//    }
//    
//    NSLog(@"NSObject‘s class is %p", [NSObject class]);
//    NSLog(@"NSObject‘s metaClass is %p", [NSObject class]);
}

@end
