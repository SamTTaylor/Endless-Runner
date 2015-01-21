//
//  Beehive.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Beehive.h"

@implementation Beehive

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        [self.physicsBody setDynamic:false];
        self.physicsBody.categoryBitMask = 0x1 << 6;
        [self animateSelf];//start animation
    }
    return self;
}

//Beehive intro
-(void)introduction:(UIView*)inview{
    [super introduction:inview];
    [ToastView createToast:inview text:@"Double Tap Beehives to break them!" duration:5.0];
}

//Animate bees buzzAnimation
- (void) animateSelf{
    [super animateSelf];
    
    //Loop through frames for animations
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:16];
    for (int i = 8; i < 14; i++) {
        NSString *textureName = [NSString stringWithFormat:@"beehive%d.png", i];
        SKTexture *texture =[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    SKTexture *texture =[SKTexture textureWithImageNamed:@"beehive8.png"];
    [textures addObject:texture];
    
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add bees buzzAnimation
        self.buzzAnimation =[SKAction animateWithTextures:textures timePerFrame:3];
    }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        //Add bees buzzAnimation
        [self runAction:[SKAction repeatActionForever:self.buzzAnimation]];
    }], [SKAction waitForDuration:1]]] count:5]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

//Beehive waits for a short duration then removes itself when killed
- (void) deathAnimation{
    [super deathAnimation];
    
    //Loop through frames for animations
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:16];
    for (int i = 1; i < 7; i++) {
        NSString *textureName = [NSString stringWithFormat:@"beehive%d.png", i];
        SKTexture *texture =[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction runBlock:^{
        //Add explodeAnimation
        self.explodeAnimation = [SKAction animateWithTextures:textures timePerFrame:1.5];
        [self runAction:[SKAction sequence:@[
            self.explodeAnimation,
            [SKAction runBlock:^{
            [self removeFromParent];
        }]]]];
        
    }] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}


@end
