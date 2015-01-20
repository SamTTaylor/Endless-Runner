//
//  Butterfly.m
//  Endless Runner
//
//  Created by acp14stt on 16/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Butterfly.h"

@implementation Butterfly
- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        
        [self setScale:0.1];
         self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width/2, self.frame.size.height/2)];
        self.physicsBody.categoryBitMask = 0x1 << 12;
        self.physicsBody.contactTestBitMask = 0x1 << 13;
        self.physicsBody.affectedByGravity = false;
        self.physicsBody.allowsRotation = false;
    }
    return self;
}

-(void)introduction:(UIView*)inview{
    [super introduction:inview];
    [ToastView createToast:inview text:@"Catch the butterfly to keep it safe!" duration:5.0];
    [ToastView createToast:inview text:@"The butterfly will protect you from 1 lethal hit" duration:5.0];
}

@end
