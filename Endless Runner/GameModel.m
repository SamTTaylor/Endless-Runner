//
//  GameModel.m
//  Endless Runner
//
//  Created by acp14stt on 28/11/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel

- (id)initWithPlayer{
    self = [super init];
    if (self) {
        //Initialization code
        self.player = [[Player alloc] initWithTexture:[SKTexture textureWithImageNamed:@"avatar0.png"]];
        [self populateEnemyArray];
        [self populateObstacleArray];
        [self populateLivesArray];
        [self setCurrentdifficulty:1];
        [self setDifficultyscore:0];
        [self setDifficultythreshold:50];
        [self setScore:0];
        [self setGroundspeed:10];
        [self setSpeed:0.004];
        [self setTiltsensitivity:0.1];
        [self.player animateSelf];
    }
    return self;
}

- (void) incrementScore:(int)i{
    self.score += i;
}

- (void) incrementDifficultyScore:(int)i{
    self.difficultyscore += i;
}

- (void) updateDifficulty{
    if(self.difficultyscore > self.difficultythreshold && self.currentdifficulty <= 4){
        self.currentdifficulty++;
        [self setDifficultyscore:0];
    }
}

- (void) populateLivesArray{
    self.lives = [[NSMutableArray alloc] init];
    for (int i=0; i<self.player.lives; i++) {
        [self addLife];
    }
}

- (void) updateLives{
    if (self.lives.count > self.player.lives){
        [self removeLife];
    } else if (self.lives.count < self.player.lives){
       [self addLife];
    }
}

- (void) removeLife{
    SKSpriteNode *life = self.lives.lastObject;
    [life removeFromParent];
    life = nil;
    [self.lives removeLastObject];
}
- (void) addLife{
    SKSpriteNode *life = [[SKSpriteNode alloc] initWithImageNamed:@"kopf-animation"];
    [life setScale:0.2];
    life.position = CGPointMake(([UIScreen mainScreen].bounds.size.width/2 - (self.player.lives/2)*life.frame.size.width) + self.lives.count*life.frame.size.width, [UIScreen mainScreen].bounds.size.height - life.frame.size.height);
    [self.lives addObject:(life)];
}

- (void) populateObstacleArray{
    self.obstacles = [[NSMutableArray alloc] init];
    TactileObject* Tobj = [[Stump alloc] initWithTexture:[SKTexture textureWithImageNamed:@"Stump"]];
    [self.obstacles addObject:Tobj];
    [Tobj setDifficultylevel:self.obstacles.count];
    Tobj = [[Bog alloc] initWithTexture:[SKTexture textureWithImageNamed:@"Bog"]];
    [self.obstacles addObject:Tobj];
    [Tobj setDifficultylevel:self.obstacles.count];
    Tobj = [[Spikes alloc] initWithTexture:[SKTexture textureWithImageNamed:@"Spikes"]];
    [self.obstacles addObject:Tobj];
    [Tobj setDifficultylevel:self.obstacles.count];
    Tobj = [[Mushroom alloc] initWithTexture:[SKTexture textureWithImageNamed:@"Mushroom"]];
    [self.obstacles addObject:Tobj];
    [Tobj setDifficultylevel:self.obstacles.count];
    Tobj = [[Bush alloc] initWithTexture:[SKTexture textureWithImageNamed:@"Bush"]];
    [self.obstacles addObject:Tobj];
    [Tobj setDifficultylevel:self.obstacles.count];
}

- (void) populateEnemyArray{
    self.enemies = [[NSMutableArray alloc] init];
    Enemy* en = [[Fox alloc] initWithTexture:[SKTexture textureWithImageNamed:@"Fox"]];
    [self.enemies addObject:en];
    [en setDifficultylevel:self.enemies.count];
    en = [[Bird alloc] initWithTexture:[SKTexture textureWithImageNamed:@"Bird"]];
    [self.enemies addObject:en];
    [en setDifficultylevel:self.enemies.count];
    en = [[Beehive alloc] initWithTexture:[SKTexture textureWithImageNamed:@"Beehive"]];
    [self.enemies addObject:en];
    [en setDifficultylevel:self.enemies.count];
    en = [[Frog alloc] initWithTexture:[SKTexture textureWithImageNamed:@"Frog"]];
    [self.enemies addObject:en];
    [en setDifficultylevel:self.enemies.count];
    en = [[Wolf alloc] initWithTexture:[SKTexture textureWithImageNamed:@"Wolf"]];
    [self.enemies addObject:en];
    [en setDifficultylevel:self.enemies.count];

}



- (TactileObject*) spawnRandomObstacle{
    int i = arc4random()%self.currentdifficulty;
    TactileObject* Tobj = [[TactileObject alloc] init];
    Tobj = self.obstacles[i];
    int loc;
    TactileObject* spawn = [[Tobj.class alloc] initWithTexture:Tobj.texture];
    loc = 0;
    [self placeEntWithLoc:loc Ent:spawn];
    NSString *strClass = NSStringFromClass(spawn.class);
    if ([strClass  isEqual: @"Stump"]) {
        [spawn setPosition:CGPointMake(spawn.position.x, spawn.position.y+40)];
    } else if ([strClass  isEqual: @"Bog"]) {
        [spawn setPosition:CGPointMake(spawn.position.x, spawn.position.y)];
    } else if ([strClass  isEqual: @"Spikes"]) {
        [spawn setPosition:CGPointMake(spawn.position.x, spawn.position.y+40)];
    } else if ([strClass  isEqual: @"Mushroom"]) {
        [spawn setPosition:CGPointMake(spawn.position.x, spawn.position.y+40)];
    } else if ([strClass  isEqual: @"Bush"]) {
        [spawn setPosition:CGPointMake(spawn.position.x, spawn.position.y+40)];
    }
    return spawn;
}

- (Enemy*) spawnRandomEnemy{
    int i = arc4random()%self.currentdifficulty;
    Enemy* en = [[Enemy alloc] init];
    en = self.enemies[i];
    int loc;
    NSString *strClass = NSStringFromClass(en.class);
    Enemy* spawn = [[en.class alloc] initWithTexture:en.texture];
    if([strClass  isEqual: @"Bird" ]){
        loc = 2;
    } else if([strClass  isEqual: @"Beehive" ]){
        loc = 3;
    } else {
        loc = 0;
    }
    [self placeEntWithLoc:loc Ent:spawn];
    return spawn;
}

- (TactileObject*) spawnPit{
    TactileObject* pit = [[TactileObject alloc] initWithTexture:[SKTexture textureWithImageNamed:@"level1-pit"]];
    [pit setScale:0.4];
    [pit setXScale:0.6];
    [self placeEntWithLoc:0 Ent:pit];
    pit.physicsBody.categoryBitMask = 0x1 << 10;
    [pit setPosition:CGPointMake(pit.position.x, pit.position.y+5)];
    return pit;
}







-(void)moveNodeWithGround:(SKNode*)node Repeat:(bool)r{
    //Sets up the ground sprites, makes them scroll passed in a loop
    CGFloat distance =  [UIScreen mainScreen].bounds.size.width*1.5;
    if (r == true){
        SKAction* move = [SKAction moveByX:-self.groundtexture.size.width y:0 duration:self.groundspeed];
        SKAction* reset = [SKAction moveByX:self.groundtexture.size.width y:0 duration:0];
        SKAction* loopMovement = [SKAction repeatActionForever:[SKAction sequence:@[move, reset]]];
        
        [node runAction:[SKAction runBlock:^{
            [node runAction:loopMovement];
        }]];
        
    } else {
        
        SKAction* move = [SKAction moveByX:-distance y:0 duration:self.groundspeed*10.35];
        SKAction* remove = [SKAction removeFromParent];
        SKAction* Movement = [SKAction sequence:@[move, remove]];
        
        [node runAction:[SKAction runBlock:^{
            [node runAction:Movement];
        }]];
        
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
    [self.player setScale:0.2];
    [self placeEntWithLoc:1 Ent:self.player];
}


-(void)placeEntWithLoc:(int)loc Ent:(Entity*)ent{
    CGFloat screenwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    switch (loc) {
        case 0://Bottom Right
            [ent setPosition:CGPointMake(screenwidth+ent.frame.size.width/2, self.groundnode.frame.size.height+ent.frame.size.height/2)];
            [self moveNodeWithGround:ent Repeat:NO];
            break;
        case 1://Bottom Left
            [ent setPosition:CGPointMake(ent.frame.size.width/2,self.groundnode.frame.size.height+ent.frame.size.height/2)];
            break;
        case 2://Middle right
            [ent setPosition:CGPointMake(screenwidth+ent.frame.size.width/2,screenheight/2)];
            [self moveNodeWithGround:ent Repeat:NO];
            break;
        case 3://75% right
            [ent setPosition:CGPointMake(screenwidth+ent.frame.size.width/2,screenheight/4)];
            [self moveNodeWithGround:ent Repeat:NO];
            break;
        default:
            break;
    }
}

-(TactileObject*)newEnvironmentObjectWithImageNamed:(NSString*)name scale:(float)scale{
    TactileObject  *Tobj = [[TactileObject alloc] initWithTexture:[SKTexture textureWithImageNamed:name]];
    [Tobj setScale:scale];
    return Tobj;
}


@end
