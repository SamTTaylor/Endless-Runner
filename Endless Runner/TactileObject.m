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
    if (self.moving == false) {
        SKAction* move = [SKAction moveByX:20 y:0 duration:0.1];
        SKAction* loopMovement = [SKAction repeatActionForever:move];
        [self.node runAction:loopMovement withKey:@"MovingRight"];
        self.moving = true;
    }
}

-(void)moveEntityLeft{
    if (self.moving == false) {
        SKAction* move = [SKAction moveByX:-20 y:0 duration:0.1];
        SKAction* loopMovement = [SKAction repeatActionForever:move];
        [self.node runAction:loopMovement withKey:@"MovingLeft"];
        self.moving = true;
    }
}

-(void)stopMovementActionsWithDirection:(int)d{
    switch (d) {
        case 0:
            [self.node removeActionForKey:@"MovingLeft"];
            self.moving = false;
            break;
        case 1:
            [self.node removeActionForKey:@"MovingRight"];
            self.moving = false;
            break;
        default:
            break;
    }
}

@end
