//
//  Berry.m
//  Endless Runner
//
//  Created by acp14stt on 15/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Berry.h"

@implementation Berry

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        //Unique bit mask for interaction
        self.physicsBody.categoryBitMask = 0x1 << 11;
    }
    return self;
}

//Berry specific intro
-(void)introduction:(UIView*)inview{
    [super introduction:inview];
    [ToastView createToast:inview text:@"Find the berries!" duration:5.0];
}

//Berry disappears immediately when touched
- (void) deathAnimation{
    [super deathAnimation];
    [self removeFromParent];
}

@end
