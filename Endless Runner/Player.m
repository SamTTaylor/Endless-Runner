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
        node.physicsBody.contactTestBitMask = 0x1 << 2 | 0x1 << 4 | 0x1 << 6 | 0x1 << 5 | 0x1 << 8 | 0x1 << 7;
        node.physicsBody.categoryBitMask = 0x1 << 1;//player
        node.physicsBody.collisionBitMask = 0x1 << 2 | 0x1 << 4 | 0x1 << 3 | 0x1 << 8 | 0x1 << 7;
        node.physicsBody.allowsRotation = false;
        self.lives = 3;
        
    }
    return self;
}

-(void)jumpEntity{
    if (self.inbog == false) {
        CGFloat impulseX = 0.0f;
        CGFloat impulseY = self.speed * 100.0f;
        [self.node.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:self.node.position];
        [self setLives:3];
    }
    
}

- (void)collidedWithBog{
    [self.node removeActionForKey:@"bogcollision"];
    [self.node runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        [self setInbog:true];
    }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        [self setInbog:false];
    }], [SKAction waitForDuration:0.05]]] count:1]]] withKey:@"bogcollision"];
}

- (void)collidedWithMushroom{//Use for block animation later

    [self.node removeActionForKey:@"mushroomcollision"];
    [self.node runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        [self setInmushroom:true];
    }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        [self setInmushroom:false];
    }], [SKAction waitForDuration:0.05]]] count:1]]] withKey:@"mushroomcollision"];
}

- (void)collidedWithEnemy{//Use for block animation later
    [self.node removeActionForKey:@"enemycollision"];
    [self.node runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        [self jumpEntity];
    }], [SKAction waitForDuration:0.05], [SKAction runBlock:^{
        [self jumpEntity];
    }], [SKAction waitForDuration:0.05]]] count:4]]] withKey:@"enemycollision"];
}

@end
