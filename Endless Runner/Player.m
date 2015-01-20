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
        //Player collides with virtually everything in the game
        self.physicsBody.contactTestBitMask = 0x1 << 2 | 0x1 << 4 | 0x1 << 6 | 0x1 << 5 | 0x1 << 8 | 0x1 << 7 | 0x1 << 10 | 0x1 << 11 | 0x1 << 12;
        self.physicsBody.categoryBitMask = 0x1 << 1;//player
        self.physicsBody.collisionBitMask = 0x1 << 2 | 0x1 << 4 | 0x1 << 3 | 0x1 << 8 | 0x1 << 7 ;
        
        //Player cannot be rotated
        self.physicsBody.allowsRotation = false;
        self.lives = 3;//default lives
        [self setInvulnerable:false];//Player is instanciated vulnerable
        [self setSpeed:50];//Default speed
        [self setJumpcount:0];
        [self initialiseAnimation];//Player is animated upon instanciation
        [self jumpcheckTimerFire];
    }
    return self;
}

//Player animated while moving if not animated already
-(void)moveEntityLeft:(int)speed{
    [super moveEntityLeft:self.speed];
    if (self.animated == false)
        [self animateSelf];
}
-(void)moveEntityRight:(int)speed{
    [super moveEntityRight:self.speed];
    if (self.animated == false)
        [self animateSelf];
}

//Player has a condition on his jump: he is not allowed to jump if he is in a bog or has reached his jump limit
-(void)jumpEntity{

    if (self.inbog == false && self.jumpcount < 3) {
        CGFloat impulseX = 0.0f;
        CGFloat impulseY = self.speed * 100.0f;
        [self.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:self.position];
        self.jumpcount++;
    }

}

//For when the player can jump again
-(void)resetJumpCount{
    self.jumpcount = 0;
}


//Instanciates and fires the jump check timer to monitor jump limit resets
-(void)jumpcheckTimerFire{
    NSTimer *jumpchecktimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(jumpcheckFireMethod:) userInfo:nil repeats:YES];
    [jumpchecktimer fire];
}

//Resets the player's jump limit each time they rest
- (void)jumpcheckFireMethod:(NSTimer *)updatetimer{
    if (self.physicsBody.velocity.dy < 0.1 && self.physicsBody.velocity.dy > -0.1){
        [self resetJumpCount];
    }
}

//If a player is not invulnerable and has no followers protecting him, take a life and make him invulerable for a short duration
-(void) takeLife{
    if (self.invulnerable == false && self.gotfollower == false){
        self.lives--;
        self.invulnerable = true;
        [self runAction:
            [SKAction sequence:@[
            [SKAction waitForDuration:40],
            [SKAction runBlock:^{
                [self setInvulnerable:false];
            }]]]];
    } else {//Else take his follower away and make him invulnerable for a short duration
        self.gotfollower = false;
        [self.currentbutterfly removeFromParent];
        self.invulnerable = true;
        [self runAction:
         [SKAction sequence:@[
                              [SKAction waitForDuration:40],
                              [SKAction runBlock:^{
             [self setInvulnerable:false];
         }]]]];
    }
}

//remove all animations from the player
-(void) stopAnimation{
    [self setAnimated:false];
    [self removeAllActions];
}


//Initialises the players walk animation ahead of time, which is a loop back and forth through his 8 images in his atlas
-(void)initialiseAnimation{
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
}

//Sets the players walk animation in motion inside a block
-(void) animateSelf{
    [self setAnimated:true];
    SKAction *repeat = [SKAction repeatActionForever:self.walkAnimation];
    [self runAction:[SKAction runBlock:^{
        [self runAction:repeat];
    }]withKey:@"playeranimation"];
}


//When a player collides with a bog he is set to inbog for a short duration
- (void)collidedWithBog{
    [self removeActionForKey:@"bogcollision"];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        [self setInbog:true];
    }], [SKAction waitForDuration:40], [SKAction runBlock:^{
        [self setInbog:false];
    }], [SKAction waitForDuration:0.05]]] count:1]]] withKey:@"bogcollision"];
}


//When a player collides with a mushroom his inmushroom value is set to true, if it is already true it is set to false
- (void)collidedWithMushroom{
    
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

//Player flashes to indicate contact with an enemy
- (void)collidedWithEnemy{//Use for block animation later
    [self removeActionForKey:@"enemycollision"];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        [self setScale:0.0];
    }], [SKAction waitForDuration:0.20], [SKAction runBlock:^{
        [self setScale:1.0];
    }], [SKAction waitForDuration:0.05]]] count:1]]] withKey:@"enemycollision"];
}

//Specific positioning on the player for each costume to make it look realistic
-(CGPoint)assignCostumePosition{
    int arrayposition = [self.costumearray indexOfObjectIdenticalTo:self.costume];
    if (arrayposition < self.costumearray.count){
        switch (arrayposition) {
            case 1://Guard hat
                self.costumeposition = CGPointMake(self.position.x, self.position.y+45);
                break;
            case 2://Mining hat
                self.costumeposition = CGPointMake(self.position.x, self.position.y+40);
                break;
            case 3://Super Lenny
                self.costumeposition = CGPointMake(self.position.x-13, self.position.y);
                break;
            case 4://Christmas hat
                self.costumeposition = CGPointMake(self.position.x-13, self.position.y+42);
                break;
            case 5://Vampire Lenny
                self.costumeposition = CGPointMake(self.position.x, self.position.y);
                break;
            case 6://Lederhosen
                self.costumeposition = CGPointMake(self.position.x, self.position.y-8);
                break;
                
            default:
                break;
        }
    } else {
        return CGPointMake(0, 0);//dummy value, is handled by receiving methods
    }
    return self.costumeposition;
}

@end
