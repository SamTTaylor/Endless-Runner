//
//  ToastView.h
//  Endless Runner
//
//Replicates Toast functionality in iOS

#import <UIKit/UIKit.h>

@interface ToastView : UIView

@property (strong, nonatomic) NSString *text;

+ (void)createToast: (UIView *)view text:(NSString *)text duration:(float)d;

@end