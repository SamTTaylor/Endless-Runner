//
//  Bog.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Bog.h"

@implementation Bog

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        [self setScale:0.6];
        //Bog has specific category mask so player can get stuck in it
        self.physicsBody.categoryBitMask = 0x1 << 5;
    }
    return self;
}

//Bog specific introduction
-(void)introduction:(UIView*)inview{
    [super introduction:inview];
    [ToastView createToast:inview text:@"Bogs will stop you jumping!" duration:5.0];
}

//Bog animation sequence
- (void) animateSelf{
    [super animateSelf];
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add Animation
    }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        //Add Animation
    }], [SKAction waitForDuration:1]]] count:5]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

@end
