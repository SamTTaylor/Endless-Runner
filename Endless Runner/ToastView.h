//
//  ToastView.h
//  Endless Runner
//
//Taken from Stack Overflow to replicate Toast functionality in iOS

#import <UIKit/UIKit.h>

@interface ToastView : UIView

@property (strong, nonatomic) NSString *text;

+ (void)showToastInParentView: (UIView *)parentView withText:(NSString *)text withDuaration:(float)duration;

@end
