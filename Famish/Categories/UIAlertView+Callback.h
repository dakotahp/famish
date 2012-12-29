//  http://www.wannabegeek.com/?p=96
//

#import <StoreKit/StoreKit.h>

@interface UIAlertView (BlockExtensions) <UIAlertViewDelegate>

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
    completionBlock:(void (^)(NSUInteger buttonIndex, UIAlertView *alertView))block
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end