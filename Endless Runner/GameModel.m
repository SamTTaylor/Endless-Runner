//
//  GameModel.m
//  Endless Runner
//
//  Created by acp14stt on 28/11/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel

static const int playerCategory = 0;
static const int enemyCategory = 2;

- (id)initWithPlayer{
    self = [super init];
    if (self) {
        //Initialization code
        self.player = [[Player alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:@"avatar.gif"]];
        self.backgroundtexture = [SKTexture textureWithImageNamed:@"background"];
        self.groundtexture = [SKTexture textureWithImageNamed:@"ground"];
        [self populateEnemyArray];
        [self setCurrentdifficulty:1];
        [self setDifficultyscore:0];
        [self setDifficultythreshold:10];
        [self setScore:0];
        self.speed = 0.004;
        self.tiltsensitivity = 0.1;
        
    }
    return self;
}


- (void) incrementScore:(int)i{
    self.score += i;
}

- (void) incrementDifficultyScore:(int)i{
    self.score += i;
}

- (void) updateDifficultyThreshold{
    NSLog(@"%d", self.difficultyscore);
    if(self.difficultyscore <= self.difficultythreshold){
        [self setCurrentdifficulty:1];
    } else if(self.difficultyscore <= self.difficultythreshold*2){
        [self setCurrentdifficulty:2];
    } else if(self.difficultyscore<= self.difficultythreshold*3){
        [self setCurrentdifficulty:3];
    } else if(self.difficultyscore<= self.difficultythreshold*4){
        [self setCurrentdifficulty:4];
    } else{
        [self setCurrentdifficulty:5];
    }
}

- (void) populateEnemyArray{
    self.enemies = [[NSMutableArray alloc] init];
    Enemy* en = [[Fox alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:@"Fox"]];
    [self.enemies addObject:en];
    en = [[Bird alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:@"Bird"]];
    [self.enemies addObject:en];
    en = [[Beehive alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:@"Beehive"]];
    [self.enemies addObject:en];
    en = [[Frog alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:@"Frog"]];
    [self.enemies addObject:en];
    en = [[Wolf alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:@"Wolf"]];
    [self.enemies addObject:en];
    NSLog(@"%@", self.enemies[0]);

}



-(void)moveNodeWithGround:(SKNode*)node Repeat:(bool)r{
    //Sets up the ground sprites, makes them scroll passed in a loop
    if (r == true){
        SKAction* move = [SKAction moveByX:-self.groundtexture.size.width*2 y:0 duration:self.speed * self.groundtexture.size.width*2];
        SKAction* reset = [SKAction moveByX:self.groundtexture.size.width*2 y:0 duration:0];
        SKAction* loopMovement = [SKAction repeatActionForever:[SKAction sequence:@[move, reset]]];
        [node runAction:loopMovement];
    } else {
        CGFloat distance =  [UIScreen mainScreen].bounds.size.width + node.frame.size.width;
        SKAction* move = [SKAction moveByX:-distance y:0 duration:self.speed * distance];
        SKAction* remove = [SKAction removeFromParent];
        SKAction* Movement = [SKAction sequence:@[move, remove]];
        [node runAction:Movement];
    }
    
}


-(void)stopTactileObjectMovement:(TactileObject*)Tobj Direction:(int)d{
    [Tobj stopMovementActionsWithDirection:d];
}

-(void)moveTactileObjectRight:(TactileObject*)Tobj speed:(int)s{
    [Tobj moveEntityRight:s];
}

-(void)moveTactileObjectLeft:(TactileObject*)Tobj speed:(int)s{
    [Tobj moveEntityLeft:s];
}

-(void)impulseEntityRight:(LivingEntity*)Lent{
    [Lent impulseEntityRight];
}

-(void)impulseEntityLeft:(LivingEntity*)Lent{
    [Lent impulseEntityLeft];
}

-(void)jumpEntity:(LivingEntity*)Lent{
    
    [Lent jumpEntity];
}

- (void)setFlying:(bool)f flappingfrequenct:(double)freq LivingEntity:(LivingEntity*)Lent{
    [Lent setFlying:f flappingfrequency:freq];
}

-(void)placePlayer{
    //Bottom left
    [self.player.node setScale:0.2];
    [self placeEntWithLoc:1 Ent:self.player];
}

-(void)placeEntWithLoc:(int)loc Ent:(Entity*)ent{
    CGFloat screenwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    switch (loc) {
        case 0://Bottom Right
            [ent.node setPosition:CGPointMake(screenwidth+ent.node.frame.size.width/2, self.groundnode.frame.size.height+ent.node.frame.size.height/2)];
            [self moveNodeWithGround:ent.node Repeat:NO];
            break;
        case 1://Bottom Left
            [ent.node setPosition:CGPointMake(ent.node.frame.size.width/2,self.groundnode.frame.size.height+ent.node.frame.size.height/2)];
            break;
        case 2:
            [ent.node setPosition:CGPointMake(screenwidth+ent.node.frame.size.width/2,screenheight/2)];
            [self moveNodeWithGround:ent.node Repeat:NO];
            break;
        default:
            break;
    }
}

-(TactileObject*)newEnvironmentObjectWithImageNamed:(NSString*)name scale:(float)scale{
    TactileObject  *Tobj = [[TactileObject alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:name]];
    [Tobj.node setScale:scale];
    return Tobj;
}


- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKSpriteNode *firstNode, *secondNode;
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;
    
    if ((contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == enemyCategory) || (contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == enemyCategory) ){
        [self.player collidedWithEntity];
    }
}


@end
