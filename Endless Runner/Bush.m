//
//  Bush.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Bush.h"

@implementation Bush

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        //Lethal impassable
        self.physicsBody.categoryBitMask = 0x1 << 8;
    }
    return self;
}

//Bush specific introduction
-(void)introduction:(UIView*)inview{
    [super introduction:inview];
    [ToastView createToast:inview text:@"Swipe bushes from the centre to cut them down!" duration:5.0];
}

//Animation block
- (void) animateSelf{
    [super animateSelf];
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add Animation
    }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        //Add Animation
    }], [SKAction waitForDuration:1]]] count:1]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

//Bush waits briefly before disappearing when killed
- (void) deathAnimation{
    [super deathAnimation];
    
    //Loop through frames for animation
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:16];
    for (int i = 1; i < 5; i++) {
        NSString *textureName = [NSString stringWithFormat:@"bush%d.png", i];
        SKTexture *texture =[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }

    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction runBlock:^{
        //Add cutAnimation
        self.cutAnimation =[SKAction animateWithTextures:textures timePerFrame:1.5];
        [self runAction:[SKAction sequence:@[
                self.cutAnimation,
                [SKAction runBlock:^{
                    [self removeFromParent];
        }]]]];
    }] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

@end
