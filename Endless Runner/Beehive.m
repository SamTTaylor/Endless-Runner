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
        [self setScale:0.3];
        [self.physicsBody setDynamic:false];
        self.physicsBody.categoryBitMask = 0x1 << 6;
    }
    return self;
}

-(void)introduction:(UIView*)inview{
    [super introduction:inview];
    [ToastView showToastInParentView:inview withText:@"Double Tap Beehives to break them!" withDuaration:5.0];
}

- (void) animateSelf{
    [super animateSelf];
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add Shrink
    }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        //Add Shrink
    }], [SKAction waitForDuration:1]]] count:5]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

- (void) deathAnimation{
    [super deathAnimation];
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:16];
    for (int i = 1; i < 8; i++) {
        NSString *textureName = [NSString stringWithFormat:@"beehive%d.png", i];
        SKTexture *texture =[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    SKTexture *texture =[SKTexture textureWithImageNamed:@"beehive0.png"];
    [textures addObject:texture];
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add explosion
        self.explodeAnimation =[SKAction animateWithTextures:textures timePerFrame:3];
    }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        //Add cut
        [self runAction:[SKAction repeatActionForever:self.explodeAnimation]];
        [self removeFromParent];//remove once animation is complete
    }], [SKAction waitForDuration:1]]] count:1]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}


@end
