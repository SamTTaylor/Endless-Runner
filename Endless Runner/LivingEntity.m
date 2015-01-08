//
//  LivingEntity.m
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "LivingEntity.h"

@implementation LivingEntity

- (id)initWithNode:(SKSpriteNode*)node
{
    self = [super initWithNode:node];
    if (self) {
        //Initialization code
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.frame.size];
        self.speed = 50;
    }
    return self;
}

-(void)moveEntityRight{
    SKAction* move = [SKAction moveByX:self.speed y:0 duration:0.1];
    SKAction* loopMovement = [SKAction repeatActionForever:move];
    [self.node runAction:loopMovement withKey:@"MovingRight"];
    [super moveEntityRight];
}

-(void)moveEntityLeft{
    SKAction* move = [SKAction moveByX:-self.speed y:0 duration:0.1];
    SKAction* loopMovement = [SKAction repeatActionForever:move];
    [self.node runAction:loopMovement withKey:@"MovingLeft"];
    [super moveEntityLeft];
}

-(void)stopMovementActions{
    [self.node removeActionForKey:@"MovingLeft"];
    [self.node removeActionForKey:@"MovingRight"];
}

-(void)impulseEntityRight{
    CGFloat impulseX = self.speed*50.0f;
    CGFloat impulseY = 0.0f;
    [self.node.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:self.node.position];
}

-(void)impulseEntityLeft{
    CGFloat impulseX = self.speed*-50.0f;
    CGFloat impulseY = 0.0f;
    [self.node.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:self.node.position];
}

-(void)jumpEntity{
    CGFloat impulseX = 0.0f;
    CGFloat impulseY = self.speed * 100.0f;
    [self.node.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:self.node.position];
    
}



@end
