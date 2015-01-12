//
//  Bird.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Bird.h"

@implementation Bird

- (id)initWithNode:(SKSpriteNode*)node
{
    self = [super initWithNode:node];
    if (self) {
        //Initialization code
        [self.node setScale:0.2];
        [self setFlying:YES flappingfrequency:0.4];
        node.physicsBody.contactTestBitMask = 0x1 << 1 | 0x1 << 3;
        node.physicsBody.categoryBitMask = 0x1 << 2;//enemy
        node.physicsBody.collisionBitMask = 0x1 << 1 | 0x1 << 3;
    }
    return self;
}

- (void) animateSelf{
    [super animateSelf];
    [self.node removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self.node runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add flap
    }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        //Add flap
    }], [SKAction waitForDuration:1]]] count:5]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

@end
