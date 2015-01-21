//
//  Frog.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Frog.h"
#import "GameScene.h"

@implementation Frog

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        [self setScale:0.2];
        [self setXScale:-0.2];
        self.physicsBody.allowsRotation = false;
        self.physicsBody.contactTestBitMask = 0x1 << 1 | 0x1 << 3;
        self.physicsBody.categoryBitMask = 0x1 << 2;//enemy
        self.physicsBody.collisionBitMask = 0x1 << 1 | 0x1 << 3;

    }
    return self;
}

//Frog specific intro
-(void)introduction:(UIView*)inview{
    [super introduction:inview];
    [ToastView createToast:inview text:@"Dodge the frog's tongue attack!" duration:5.0];
}

//Add tongue and run self animations
- (void) animateSelf{
    [super animateSelf];
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        if (self.tongue.parent != self.parent) {
            [self addTongue];
        }
    }], [SKAction waitForDuration:2]]] count:5]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

//creates tongue node, positions it and sets it moving as required
-(void)addTongue{
    self.tongue = [[TactileObject alloc] initWithTexture:[SKTexture textureWithImageNamed:@"frog-tongue"]];
    //Tongue is seen as an enemy in game for collision purposes
    self.tongue.physicsBody.categoryBitMask = 0x1 << 2;
    self.tongue.physicsBody.allowsRotation = false;
    
    //Makes sure tongue is behind regular nodes (default is 0)
    self.tongue.zPosition = -1;
    //Rotates tongue to the right position
    [self.tongue runAction:[SKAction rotateByAngle:90.2 duration:0]];
    [((GameScene*)self.parent) addChild:self.tongue];//Add tongue to the frogs scene
    
    
    //Manually set tongue moving with ground, this is not ideal but given that the rest of the game moves without influencing the physics bodies (In order to achieve consistent speeds), it is the only way I can think of doing this inside the Frog class
    SKAction* move = [SKAction moveByX:-[UIScreen mainScreen].bounds.size.width*1.5 y:0 duration:10*10.35];
    SKAction* remove = [SKAction removeFromParent];
    SKAction* Movement = [SKAction sequence:@[move, remove]];
    
    [self.tongue runAction:[SKAction runBlock:^{
        [self.tongue runAction:Movement withKey:@"movingwithground"];//Key set so you can stop this action if need be
    }]];
    
    //Set tongue "inside" the frog
    self.tongue.position = CGPointMake(self.position.x+40, self.position.y-22);
    
    //Set tongue shooting back and forth (forth and back)
    SKAction* forth = [SKAction moveBy:CGVectorMake(-95, +115) duration:10.0];
    SKAction* back = [SKAction moveBy:CGVectorMake(+95, -115) duration:10.0];
    SKAction* forthandback = [SKAction repeatAction: [SKAction sequence:@[forth, back]] count:5];
    
    [self.tongue runAction:[SKAction runBlock:^{
        [self.tongue runAction:forthandback withKey:@"forthandback"];//Key set so you can stop this action if need be
    }]];
}

@end
