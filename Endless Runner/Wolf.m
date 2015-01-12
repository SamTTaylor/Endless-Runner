//
//  Wolf.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Wolf.h"

@implementation Wolf

- (id)initWithNode:(SKSpriteNode*)node
{
    self = [super initWithNode:node];
    if (self) {
        //Initialization code
        [self.node setScale:0.3];
        [self setSpeed:100];
        node.physicsBody.allowsRotation = false;
    }
    return self;
}

- (void) animateSelf{
    [super animateSelf];
    [self.node removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self.node runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //[self impulseEntityLeft];
        //Add pounce animation
    }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        [self impulseEntityLeft];
        [self moveEntityLeft:0];
        //Add pounce animation
    }], [SKAction waitForDuration:1]]] count:5]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

@end
