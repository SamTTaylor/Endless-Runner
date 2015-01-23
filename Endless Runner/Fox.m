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
        [self setMyspeed:5];
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
    [self runAction:[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        self.xScale = -1.0;
        [self setMyspeed:5];
        [self jumpEntity];
        [self setMyspeed:1.3];
        [self impulseEntityRight];
        [self setMyspeed:5];
        self.runAnimation = [SKAction animateWithTextures:textures timePerFrame:1];
    }], [SKAction waitForDuration:20], [SKAction runBlock:^{
        self.xScale = 1.0;
        [self jumpEntity];
        [self setMyspeed:1.3];
        [self impulseEntityLeft];
        [self setMyspeed:5];
        [self runAction:[SKAction repeatActionForever:self.runAnimation]];
    }], [SKAction waitForDuration:20]]] count:5] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

@end
