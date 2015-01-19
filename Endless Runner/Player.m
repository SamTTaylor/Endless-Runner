//
//  Player.m
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        self.physicsBody.contactTestBitMask = 0x1 << 2 | 0x1 << 4 | 0x1 << 6 | 0x1 << 5 | 0x1 << 8 | 0x1 << 7;
        self.physicsBody.categoryBitMask = 0x1 << 1;//player
        self.physicsBody.collisionBitMask = 0x1 << 2 | 0x1 << 4 | 0x1 << 3 | 0x1 << 8 | 0x1 << 7;
        self.physicsBody.allowsRotation = false;
        self.lives = 3;
        self.dead = false;
        [self setInvulnerable:false];
        [self setSpeed:50];
    }
    return self;
}

-(void)jumpEntity{
    
    //remove walk animation
    [self removeActionForKey:@"avatar"];
     
     //add jumpAnimation
     NSMutableArray *textures = [NSMutableArray arrayWithCapacity:16];
    SKTexture *texture =[SKTexture textureWithImageNamed:@"avatar8.png"];
    //[textures addObject:texture];
    [textures addObject:texture];
     
     self.jumpAnimation =[SKAction animateWithTextures:textures timePerFrame:3];
    [self runAction:[SKAction repeatAction:self.jumpAnimation count:10]];
    
    if (self.inbog == false) {
        CGFloat impulseX = 0.0f;
        CGFloat impulseY = self.speed * 100.0f;
        [self.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:self.position];
    }
    
}

-(void) takeLife{
    if (self.invulnerable == false){
        self.lives--;
        self.invulnerable = true;
        [self runAction:
            [SKAction sequence:@[
            [SKAction waitForDuration:40],
            [SKAction runBlock:^{
                [self setInvulnerable:false];
            }]]]];
    }
    if (self.lives == 0){
        self.dead = true;
    }
}

-(void) animateSelf{
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:16];
    for (int i = 1; i < 8; i++) {
        NSString *textureName = [NSString stringWithFormat:@"avatar%d.png", i];
        SKTexture *texture =[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    SKTexture *texture =[SKTexture textureWithImageNamed:@"avatar0.png"];
    [textures addObject:texture];
    [textures addObject:texture];
    for (int i = 7; i > 0; i--) {
        NSString *textureName = [NSString stringWithFormat:@"avatar%d.png", i];
        SKTexture *texture =[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    
    self.walkAnimation =[SKAction animateWithTextures:textures timePerFrame:3];
    SKAction *repeat = [SKAction repeatActionForever:self.walkAnimation];
    [self runAction:[SKAction runBlock:^{
        [self runAction:repeat];
    }] withKey:@"avatar"];
}

- (void)collidedWithBog{
    [self removeActionForKey:@"bogcollision"];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        [self setInbog:true];
    }], [SKAction waitForDuration:40], [SKAction runBlock:^{
        [self setInbog:false];
    }], [SKAction waitForDuration:0.05]]] count:1]]] withKey:@"bogcollision"];
}

- (void)collidedWithMushroom{//Use for block animation later
    
    if (self.inmushroom == true){
        [self setInmushroom:false];
    } else {
        [self setInmushroom:true];
    }
    [self removeActionForKey:@"mushroomcollision"];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add animation
    }], [SKAction waitForDuration:20], [SKAction runBlock:^{
        //Add animation
    }], [SKAction waitForDuration:0.05]]] count:1]]] withKey:@"mushroomcollision"];
}

- (void)collidedWithEnemy{//Use for block animation later
    [self removeActionForKey:@"enemycollision"];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        
    }], [SKAction waitForDuration:0.20], [SKAction runBlock:^{
        
    }], [SKAction waitForDuration:0.05]]] count:1]]] withKey:@"enemycollision"];
}

@end
