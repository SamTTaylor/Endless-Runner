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

-(void) removeLightNode{
    [self.light removeFromParent];
}

-(void)addLightNode{
    self.light = [[SKLightNode alloc] init];
    self.light.categoryBitMask = 0x1 << 1;
    self.light.falloff = 1;
    self.light.ambientColor = [UIColor whiteColor];
    self.light.lightColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:0.0 alpha:0.5];
    self.light.shadowColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    [self addChild:self.light];
}

- (void) animateSelf{}
- (void) deathAnimation{}
- (void)introduction:(UIView*)inview{}
@end
