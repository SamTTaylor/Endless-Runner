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

-(void)introduction:(UIView*)inview{
    [super introduction:inview];
    [ToastView showToastInParentView:inview withText:@"Mushrooms will reverse your movement!" withDuaration:5.0];
}

- (void) deathAnimation{
    [super deathAnimation];
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:16];
    for (int i = 1; i < 9; i++) {
        NSString *textureName = [NSString stringWithFormat:@"mushroom%d.png", i];
        SKTexture *texture =[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    SKTexture *texture =[SKTexture textureWithImageNamed:@"mushroom0.png"];
    [textures addObject:texture];
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add burst
        self.burstAnimation =[SKAction animateWithTextures:textures timePerFrame:3];
        [self runAction:[SKAction repeatAction:self.burstAnimation count:1]];
    }], [SKAction waitForDuration:20], [SKAction runBlock:^{
        
        [self removeFromParent];//remove once animation is complete
    }], [SKAction waitForDuration:1]]] count:1]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

@end
