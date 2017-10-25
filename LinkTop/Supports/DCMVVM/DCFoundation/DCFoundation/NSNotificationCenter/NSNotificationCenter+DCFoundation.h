
#import <Foundation/Foundation.h>

@interface NSNotificationCenter (DCFoundation)

#if NS_BLOCKS_AVAILABLE
/*!
 *  @brief  简化的 addObserverForName:object:queue:usingBlock: 方法
 *
 *  @note   使用此方法接收的通知，block 方法中对事件处理的线程与通知发出时的线程相同，且于该线程中同步执行
 *
 *  @param name  通知名称
 *  @param block 接收到通知时执行的代码块
 *
 *  @return 充当观察者的对象，用于调用 removeObserver: 方法以注销
 */
- (id)addObserverForName:(NSString *)name usingBlock:(void (^)(NSNotification *noti))block;
#endif

@end
