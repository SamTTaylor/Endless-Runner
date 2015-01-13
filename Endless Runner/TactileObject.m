//
//  TactileObject.m
//  Endless Runner
//
//  Created by acp14stt on 05/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "TactileObject.h"

@implementation TactileObject


- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.allowsRotation = false;
        [self.physicsBody setDynamic:false];
        self.speed = 20;
    }
    return self;
}


-(void)moveEntityRight:(int)speed{
    if ([self actionForKey:@"MovingRight"] == false) {
        SKAction* move = [SKAction moveByX:speed/40 y:0 duration:0.1];
        SKAction* loopMovement = [SKAction repeatActionForever:move];
        [self runAction:loopMovement withKey:@"MovingRight"];
    }
}

-(void)moveEntityLeft:(int)speed{
    if ([self actionForKey:@"MovingLeft"] == false) {
        SKAction* move = [SKAction moveByX:-speed/40 y:0 duration:0.1];
        SKAction* loopMovement = [SKAction repeatActionForever:move];
        [self runAction:loopMovement withKey:@"MovingLeft"];
    }
}

-(void)stopMovementActionsWithDirection:(int)d{
    switch (d) {
        case 0:
            [self removeActionForKey:@"MovingLeft"];
            break;
        case 1:
            [self removeActionForKey:@"MovingRight"];
            break;
        default:
            break;
    }
}

- (void) animateSelf{
    
}

- (void) deathAnimation{
    
}

@end
