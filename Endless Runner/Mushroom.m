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
    
    //Loop through frames for Animation
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:16];
    for (int i = 1; i < 8; i++) {
        NSString *textureName = [NSString stringWithFormat:@"mushroom%d.png", i];
        SKTexture *texture =[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction runBlock:^{
        //Add cutAnimation
        self.burstAnimation = [SKAction animateWithTextures:textures timePerFrame:1.5];
        [self runAction:[SKAction sequence:@[
            self.burstAnimation,
            [SKAction runBlock:^{
                [self removeFromParent];
        }]]]];
    }] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

@end
