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
        node.physicsBody.contactTestBitMask = 2;
        node.physicsBody.categoryBitMask = 0;//player
        node.physicsBody.collisionBitMask = 2;
        node.physicsBody.allowsRotation = false;
    }
    return self;
}

- (void)collidedWithEntity{//Use for block animation later
    [self.node removeActionForKey:@"flash"];
    [self.node runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        self.node.color = [SKColor redColor];
    }], [SKAction waitForDuration:0.05], [SKAction runBlock:^{
        self.node.color = [SKColor blueColor];
    }], [SKAction waitForDuration:0.05]]] count:4]]] withKey:@"flash"];
}

@end
