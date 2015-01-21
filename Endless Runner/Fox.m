//
//  Fox.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Fox.h"

@implementation Fox

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        [self setScale:0.2];
        [self setSpeed:20];
        //Enemy, touch ground and players
        self.physicsBody.allowsRotation = false;
        self.physicsBody.contactTestBitMask = 0x1 << 1 | 0x1 << 3;
        self.physicsBody.categoryBitMask = 0x1 << 2;//enemy
        self.physicsBody.collisionBitMask = 0x1 << 1 | 0x1 << 3;
        
        [self animateSelf];
    }
    return self;
}


//Fox jumps left and right periodically
- (void) animateSelf{
    [super animateSelf];
    
    //Loop through frames for animation
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:16];
    for (int i = 1; i < 5; i++) {
        NSString *textureName = [NSString stringWithFormat:@"fox%d.png", i];
        SKTexture *texture =[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        self.xScale = -0.2;
        [self jumpEntity];
        [self setSpeed:40];
        [self impulseEntityRight];
        [self setSpeed:20];
        self.runAnimation = [SKAction animateWithTextures:textures timePerFrame:3];
    }], [SKAction waitForDuration:20], [SKAction runBlock:^{
        self.xScale = 0.2;
        [self jumpEntity];
        [self setSpeed:40];
        [self impulseEntityLeft];
        [self setSpeed:20];
        [self runAction:[SKAction repeatActionForever:self.runAnimation]];
    }], [SKAction waitForDuration:20]]] count:5]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

@end
