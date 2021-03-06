//
//  Haven.m
//  Endless Runner
//
//  Created by acp14stt on 16/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Haven.h"

@implementation Haven
- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        //Unique physical attributes set for collision handling & real world presence
        self.physicsBody.categoryBitMask = 0x1 << 13;
        self.physicsBody.contactTestBitMask = 0x1 << 12;
    }
    return self;
}

//Butterfly specific introductions
-(void)introduction:(UIView*)inview{
    [super introduction:inview];
    [ToastView createToast:inview text:@"Return the butterfly to the Haven!" duration:5.0];
}

@end


