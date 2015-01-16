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
        [self setScale:0.6];
        self.physicsBody.categoryBitMask = 0x1 << 8;
    }
    return self;
}

-(void)introduction:(UIView*)inview{
    [super introduction:inview];
    [ToastView showToastInParentView:inview withText:@"Swipe bushes from the centre to cut them down!" withDuaration:5.0];
}

- (void) animateSelf{
    [super animateSelf];
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add Shrink
    }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        //Add Shrinks
    }], [SKAction waitForDuration:1]]] count:1]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

- (void) deathAnimation{
    [super deathAnimation];
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:16];
    for (int i = 1; i < 6; i++) {
        NSString *textureName = [NSString stringWithFormat:@"bush%d.png", i];
        SKTexture *texture =[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    
    SKTexture *texture =[SKTexture textureWithImageNamed:@"bush0.png"];
    [textures addObject:texture];
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add breakAnimation
        self.breakAnimation =[SKAction animateWithTextures:textures timePerFrame:3];
        [self runAction:[SKAction repeatAction:self.breakAnimation count:1]];
    }], [SKAction waitForDuration:20], [SKAction runBlock:^{
        [self removeFromParent];//remove once animation is complete
    }], [SKAction waitForDuration:1]]] count:1]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

@end
