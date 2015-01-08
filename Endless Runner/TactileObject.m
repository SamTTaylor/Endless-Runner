//
//  TactileObject.m
//  Endless Runner
//
//  Created by acp14stt on 05/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "TactileObject.h"

@implementation TactileObject

- (id)initWithNode:(SKSpriteNode*)node
{
    self = [super initWithNode:node];
    if (self) {
        //Initialization code
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.frame.size];
    }
    return self;
}

-(void)moveEntityRight{
    SKAction* move = [SKAction moveByX:20 y:0 duration:0.1];
    SKAction* loopMovement = [SKAction repeatActionForever:move];
    [self.node runAction:loopMovement withKey:@"MovingRight"];

}

-(void)moveEntityLeft{
    SKAction* move = [SKAction moveByX:-20 y:0 duration:0.1];
    SKAction* loopMovement = [SKAction repeatActionForever:move];
    [self.node runAction:loopMovement withKey:@"MovingLeft"];
}

-(void)stopMovementActions{
    [self.node removeActionForKey:@"MovingLeft"];
    [self.node removeActionForKey:@"MovingRight"];
}

@end
