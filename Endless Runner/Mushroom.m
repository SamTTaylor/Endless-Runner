//
//  Mushroom.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Mushroom.h"

@implementation Mushroom

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        [self setScale:0.2];
        self.physicsBody.categoryBitMask = 0x1 << 7;
    }
    return self;
}

//Mushroom specific introduction
-(void)introduction:(UIView*)inview{
    [super introduction:inview];
    [ToastView createToast:inview text:@"Mushrooms will reverse your movement!" duration:5.0];
}

//Mushrooms wait briefly before disappearing so they can explode
- (void) deathAnimation{
    [super deathAnimation];
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add burst
    }], [SKAction waitForDuration:20], [SKAction runBlock:^{
        //Add burst
        [self removeFromParent];//remove once animation is complete
    }], [SKAction waitForDuration:1]]] count:1]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

@end
