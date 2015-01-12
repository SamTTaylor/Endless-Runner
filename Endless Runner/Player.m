//
//  Player.m
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)initWithNode:(SKSpriteNode*)node
{
    self = [super initWithNode:node];
    if (self) {
        //Initialization code
        node.physicsBody.contactTestBitMask = 0x1 << 2 | 0x1 << 4 | 0x1 << 6 | 0x1 << 5;
        node.physicsBody.categoryBitMask = 0x1 << 1;//player
        node.physicsBody.collisionBitMask = 0x1 << 2 | 0x1 << 4 | 0x1 << 3;
        node.physicsBody.allowsRotation = false;
        
    }
    return self;
}

- (void)collidedWithEntity{//Use for block animation later
    [self.node removeActionForKey:@"playercollision"];
    [self.node runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        [self jumpEntity];
    }], [SKAction waitForDuration:0.05], [SKAction runBlock:^{
        [self jumpEntity];
    }], [SKAction waitForDuration:0.05]]] count:4]]] withKey:@"playercollision"];
}

@end
