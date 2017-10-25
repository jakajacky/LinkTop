
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, DCPropertyAssignedType) {
  DCPropertyAssignedTypeUnknown,
  DCPropertyAssignedTypeWeak,
  DCPropertyAssignedTypeRetain,
  DCPropertyAssignedTypeCopy,
  DCPropertyAssignedTypeStrong = DCPropertyAssignedTypeRetain
};

@interface DCProperty : NSObject

@property (nonatomic)        BOOL                    isAtomic;     // Default is YES.
@property (nonatomic)        BOOL                    isReadonly;   // Default is NO.
@property (nonatomic)        DCPropertyAssignedType  assignedType; // Default is DCPropertyAssignedTypeUnknown.
@property (nonatomic,strong) NSString               *customGetter;
@property (nonatomic,strong) NSString               *customSetter;
@property (nonatomic,strong) NSString               *type;
@property (nonatomic,strong) NSString               *name;

/**
 *  @brief  返回是否为确定的实例类型
 *  @discussion  只有该 DCProperty 的类型为明确的 Objective-C 对象时，该值为 YES。
 *               例如：NSString *、NSArray *、SomeClass *等，即为确定的实例类型；
 *               而int *、char *、block、id等皆不是。
 */
@property (nonatomic) BOOL isExplicitInstance;

/**
 *  @brief  使用 objc_property_t 实例化 DCProperty 对象
 */
- (instancetype)initWithObjcProperty:(objc_property_t)p;

/**
 *  @brief  返回该属性是否为 DCObject 的子类
 */
- (BOOL)isSubclassOfDCObject;

@end
