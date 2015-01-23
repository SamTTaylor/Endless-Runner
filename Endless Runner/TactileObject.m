//
//  TactileObject.m
//  Endless Runner
//
//  Created by acp14stt on 05/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "TactileObject.h"

@implementation TactileObject
//Tactile object is the 2nd in the hierarchy, the main defining point of this class and all its subclasses is that they have a physicsbody for collision, but do no interact with the physics world e.g gravity & velocity

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        //Create physics body with same size as texture
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        //Cannot be rotated by force
        self.physicsBody.allowsRotation = false;
        //Will not interact with forces
        [self.physicsBody setDynamic:false];
        self.speed = 20;
    }
    return self;
}

//Moves entity to the right based on the speed int passed, repeatedly until cancelled
-(void)moveEntityRight:(int)speed{
    if ([self actionForKey:@"MovingRight"] == false) {//Stops overlapping loops
        SKAction* move = [SKAction moveByX:speed/40 y:0 duration:0.1];
        SKAction* loopMovement = [SKAction repeatActionForever:move];
        [self runAction:loopMovement withKey:@"MovingRight"];
    }
}
//Same as right, but left
-(void)moveEntityLeft:(int)speed{
    if ([self actionForKey:@"MovingLeft"] == false) {
        SKAction* move = [SKAction moveByX:-speed/40 y:0 duration:0.1];
        SKAction* loopMovement = [SKAction repeatActionForever:move];
        [self runAction:loopMovement withKey:@"MovingLeft"];
    }
}

//Cancels any looping actions that are moving the Tobj left or right
-(void)stopMovementActionsWithDirection:(int)d{
    switch (d) {
        case 0:
            //Been receiving some exceptions on these action removals so I guarded them
            if ([self actionForKey:@"MovingLeft"]) {
                [self removeActionForKey:@"MovingLeft"];
            }
            break;
        case 1:
            if ([self actionForKey:@"MovingRight"]) {
                [self removeActionForKey:@"MovingRight"];
            }
            break;
        default:
            break;
    }
}

//Removes light node from itself
-(void) removeLightNode{
    [self.light removeFromParent];
}

//Instantiates an applies a standardized light node to the node, meaning it will follow it around
-(void)addLightNode{
    self.light = [[SKLightNode alloc] init];
    self.light.categoryBitMask = 0x1 << 1;
    self.light.ambientColor = [UIColor whiteColor];
    self.light.lightColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:0.0 alpha:0.2];
    self.light.shadowColor = [[UIColor alloc] initWithRed:0.1 green:0.0 blue:0.0 alpha:1.0];
    [self addChild:self.light];
}

- (void) animateSelf{}//Animations and introduction are specified in the subclasses themselves
- (void) deathAnimation{}
- (void)introduction:(UIView*)inview{}
@end
