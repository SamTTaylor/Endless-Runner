//
//  Wolf.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Wolf.h"

@implementation Wolf


- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        [self setScale:0.3];
        self.physicsBody.allowsRotation = false;
        self.physicsBody.contactTestBitMask = 0x1 << 1 | 0x1 << 3;
        self.physicsBody.categoryBitMask = 0x1 << 2;//enemy
        self.physicsBody.collisionBitMask = 0x1 << 1 | 0x1 << 3;
    }
    return self;
}

- (void) animateSelf{
    [super animateSelf];
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:16];
    for (int i = 1; i < 5; i++) {
        NSString *textureName = [NSString stringWithFormat:@"wolf%d.png", i];
        SKTexture *texture =[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    SKTexture *texture =[SKTexture textureWithImageNamed:@"wolf0.png"];
    [textures addObject:texture];
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[
        [SKAction waitForDuration:10],
        [SKAction runBlock:^{
            [self setSpeed:40];
            [self impulseEntityLeft];
            [self moveEntityLeft:0];
            //Add pounce animation
            self.jumpAnimation =[SKAction animateWithTextures:textures timePerFrame:3];
            [self runAction:[SKAction repeatAction:self.jumpAnimation count:1]];
        }],
        [SKAction waitForDuration:0.5]]] count:1]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

@end
