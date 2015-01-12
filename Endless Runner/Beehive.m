//
//  Beehive.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Beehive.h"

@implementation Beehive
- (id)initWithNode:(SKSpriteNode*)node
{
    self = [super initWithNode:node];
    if (self) {
        //Initialization code
        [self.node setScale:0.3];
        [node.physicsBody setDynamic:false];
        node.physicsBody.categoryBitMask = 0x1 << 6;
    }
    return self;
}

- (void) animateSelf{
    [super animateSelf];
    [self.node removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self.node runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add Shrink
    }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        //Add Shrink
    }], [SKAction waitForDuration:1]]] count:5]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

- (void) deathAnimation{
    [super deathAnimation];
    [self.node removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self.node runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add cut
    }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        //Add cut
    }], [SKAction waitForDuration:1]]] count:5]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

@end
