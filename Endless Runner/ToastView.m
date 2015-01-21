//
//  ToastView.m
//
// Replicates Toast functionality in iOS

#import "ToastView.h"

@interface ToastView ()
@property (strong, nonatomic) UILabel *toastText;
@end
@implementation ToastView
@synthesize toastText = _toastText;

float const height = 50.0f;
float const toastborder = 10.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UILabel *)toastText
{
    if (!_toastText) {//If toast text has not yet been initialised then set it up
        _toastText = [[UILabel alloc] initWithFrame:CGRectMake(6.0, 6.0, self.frame.size.width - 15.0, self.frame.size.height - 15.0)];
        _toastText.textColor = [UIColor whiteColor];
        _toastText.numberOfLines = 2;
        _toastText.backgroundColor = [UIColor clearColor];
        _toastText.textAlignment = NSTextAlignmentCenter;
        
        
        _toastText.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
        [self addSubview:_toastText];
        
    }
    return _toastText;//And add it to the toasts
}

- (void)setText:(NSString *)text
//overrides regular set text method to set the toasts text instead of the toastview
{
    _text = text;
    self.toastText.text = text;
}

//Sets up a toast in defined view using defined string for defined length of time
+ (void)createToast: (UIView *)view text:(NSString *)text duration:(float)d
{
    
    //Display new toasts under existing toasts (if there are any)
    int existingtoasts = 0;
    for (UIView *subView in [view subviews]) {
        if ([subView isKindOfClass:[ToastView class]])
        {
            existingtoasts++;
        }
    }
    
    CGRect parentFrame = view.frame;
    
    float yPos = (70.0 + height * existingtoasts + toastborder * existingtoasts);
    
    CGRect selfFrame = CGRectMake(parentFrame.origin.x + 20.0, yPos, parentFrame.size.width - 40.0, height);
    ToastView *toast = [[ToastView alloc] initWithFrame:selfFrame];
    
    toast.layer.cornerRadius = 4.0;
    toast.text = text;
    toast.backgroundColor = [UIColor darkGrayColor];
    toast.alpha = 0.0f;
    
    
    
    [view addSubview:toast];
    
    [UIView animateWithDuration:0.4 animations:^{
        toast.alpha = 0.9f;
        toast.toastText.alpha = 0.9f;
    }completion:^(BOOL finished) {
        if(finished){
            
        }
    }];
    
    
    [toast performSelector:@selector(hideSelf) withObject:nil afterDelay:d];
    
}

- (void)hideSelf
{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.0;
        self.toastText.alpha = 0.0;
    }completion:^(BOOL finished) {
        if(finished){
            [self removeFromSuperview];
        }
    }];
}

@end
