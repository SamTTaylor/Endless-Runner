//
//  Enemy.m
//  Endless Runner
//
//  Created by acp14stt on 09/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

- (id)initWithNode:(SKSpriteNode*)node
{
    self = [super initWithNode:node];
    if (self) {
        //Initialization code
        node.physicsBody.contactTestBitMask = 0;
        node.physicsBody.categoryBitMask = 2;//enemy
        node.physicsBody.collisionBitMask = 0;
    }
    return self;
}


@end
