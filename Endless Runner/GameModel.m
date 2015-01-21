//
//  GameModel.m
//  Endless Runner
//
//  Created by acp14stt on 28/11/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel
////>>>>>>>>>>>>>>>>>>>>INIT<<<<<<<<<<<<<<<<<<<<
- (id)initWithPlayer{
    self = [super init];
    if (self) {
        //Initialization code
        //Adds player node, fills enemy array with all available enemies, fills obstacle array, fills life array, sets difficulty values, score to 0, ground movement speed, and tilt sensitiviy, also asks player to start its walk animation
        self.player = [[Player alloc] initWithTexture:[SKTexture textureWithImageNamed:@"avatar0.png"]];
        [self populateEnemyArray];
        [self populateObstacleArray];
        [self populateLivesArray];
        [self setCurrentdifficulty:1];
        [self setDifficultyscore:0];
        [self setDifficultythreshold:30];
        [self setScore:0];
        [self setGroundspeed:20];
        [self setTiltsensitivity:0.08];
        [self.player animateSelf];
    }
    return self;
}

//For unlocking content
-(void)saveAchievement:(NSString*)achievement{
    NSUserDefaults *defaults =
    [NSUserDefaults standardUserDefaults];
    [defaults setBool:true forKey:achievement];
    [defaults synchronize];
}





//>>>>>>>>>>>>>>>>>>>>SCORE/DIFFICULTY<<<<<<<<<<<<<<<<<<<<
//Add any value to score
- (void) incrementScore:(int)i{
    self.score += i;
}
//Add any value to difficulty score
- (void) incrementDifficultyScore:(int)i{
    self.difficultyscore += i;
}
//Check if diffivulty score is passed the  threshold, if it is, raise current difficulty level and reset the score
- (void) updateDifficulty{
    //Don't do this if its more than 4 because there are currently only 5 levels of difficulty
    if(self.difficultyscore > self.difficultythreshold && self.currentdifficulty <= 4){
        self.currentdifficulty++;
        [self setDifficultyscore:0];
    }
}


//>>>>>>>>>>>>>>>>>>>>LIVES<<<<<<<<<<<<<<<<<<<<
//Fills life array with nodes equal the amount of player lives
- (void) populateLivesArray{
    self.lives = [[NSMutableArray alloc] init];
    for (int i=0; i<self.player.lives; i++) {
        [self addLife];
    }
}
//Adds or removes a life node from the array if it differs from the actual amount of lives the player has
- (void) updateLives{
    if (self.lives.count > self.player.lives){
        [self removeLife];
    } else if (self.lives.count < self.player.lives){
       [self addLife];
    }
}
//Removes 1 life from its parent and the Lives array, triggered by updateLives
- (void) removeLife{
    SKSpriteNode *life = self.lives.lastObject;
    [life removeFromParent];
    life = nil;
    [self.lives removeLastObject];
}
//Adds 1 life to the life array, triggered by updateLives
- (void) addLife{
    //Life nodes are represented by the Lenny Head texture, and placed at the top of the screen in front of the other life nodes
    SKSpriteNode *life = [[SKSpriteNode alloc] initWithImageNamed:@"kopf-animation"];
    life.position = CGPointMake(([UIScreen mainScreen].bounds.size.width/2 - (self.player.lives/2)*life.frame.size.width) + self.lives.count*life.frame.size.width, [UIScreen mainScreen].bounds.size.height - life.frame.size.height);
    [self.lives addObject:(life)];
}










//>>>>>>>>>>>>>>>>>>>>NODES<<<<<<<<<<<<<<<<<<<<
//Fills obstacle array with all 1 instance of each obstacle type, in order of their difficulty, and sets their difficulty levels using the array count as it is built, levels 1 - however many obstacles there are
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
//Same thing is done with all the enemies
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

//Each obstacle needs to be positioned precisely to sit on the ground, as they are not dynamic. This method chooses one at random based on the current difficulty, instanciates it from the array, positions and returns it
- (TactileObject*) spawnRandomObstacle{
    int i = arc4random()%self.currentdifficulty;
    TactileObject* Tobj = [[TactileObject alloc] init];
    Tobj = self.obstacles[i];
    int loc;
    TactileObject* spawn = [[Tobj.class alloc] initWithTexture:Tobj.texture];
    loc = 0;
    [self placeEntWithLoc:loc Ent:spawn];//Places node and sets it moving with the ground, will be discussed later
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

//Enemies do not have to be positioned so precisely but things like birds and beehives need to be spawned in the air
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

//Returns an instance of a Tobj node with the Pit texture, bit mask is set here as there is no "Pit" class to set it on initialisation
- (TactileObject*) spawnPit{
    TactileObject* pit = [[TactileObject alloc] initWithTexture:[SKTexture textureWithImageNamed:@"level1-pit"]];
    [self placeEntWithLoc:0 Ent:pit];
    pit.physicsBody.categoryBitMask = 0x1 << 10;
    [pit setPosition:CGPointMake(pit.position.x, pit.position.y+5)];//Slightly repositioned to look right
    return pit;
}
//Returns an instance of a Butterfly, location#2
- (Butterfly*) spawnButterfly{
    Butterfly* butterfly = [[Butterfly alloc] initWithTexture:[SKTexture textureWithImageNamed:@"Butterfly"]];
    [self placeEntWithLoc:2 Ent:butterfly];
    return butterfly;
}
//Returns an instance of a Haven
- (Haven*) spawnHaven{
    Haven* haven = [[Haven alloc] initWithTexture:[SKTexture textureWithImageNamed:@"Haven"]];
    [self placeEntWithLoc:2 Ent:haven];
    return haven;
}










////>>>>>>>>>>>>>>>>>>>>NODE MOVEMENT<<<<<<<<<<<<<<<<<<<<
-(void)moveNodeWithGround:(SKNode*)node Repeat:(bool)r{
    //Sets up the ground sprites, makes them scroll passed based on the groundtexture size
    CGFloat distance =  self.groundtexture.size.width;
    if (r == true){//If you want you can reset it after a loop and have it scroll by again!
        SKAction* move = [SKAction moveByX:-distance y:0 duration:self.groundspeed/4];
        SKAction* reset = [SKAction moveByX:distance y:0 duration:0];
        SKAction* loopMovement = [SKAction repeatActionForever:[SKAction sequence:@[move, reset]]];
        
        [node runAction:[SKAction runBlock:^{
            [node runAction:loopMovement];
        }]];
        
    } else {
        //Or you can just delete it
        SKAction* move = [SKAction moveByX:-distance*2 y:0 duration:self.groundspeed*10];//make sure nodes are well off screen before removal
        SKAction* remove = [SKAction removeFromParent];
        SKAction* Movement = [SKAction sequence:@[move, remove]];
        
        [node runAction:[SKAction runBlock:^{
            [node runAction:Movement withKey:@"movingwithground"];//Key set so you can stop this action if need be
        }]];
        
    }
}

//Makes the node follow the player by applying a velocity towards the player's current location over and over again every second, maintaining the target. Target is actually just to the top left of the player so as not to obscure either node.
-(void)followPlayer:(SKSpriteNode*)node{
    [node removeActionForKey:@"movingwithground"];//Moving with ground action is removed to stop conflict of movement
    [node removeActionForKey:@"followingplayer"];
    [node runAction:[SKAction repeatActionForever:
                     [SKAction sequence:@[
                                          [SKAction runBlock:^{
                         [node.physicsBody setVelocity:CGVectorMake(((self.player.position.x-self.player.frame.size.width*1.5) - node.position.x), ((self.player.position.y+(self.player.position.y/2)) -node.position.y) )];
                     }]
                                          ,[SKAction waitForDuration:1.0]]]]withKey:@"followingplayer"];
}

//Applies players current costume to player
-(SKSpriteNode*)dressPlayer{
   SKSpriteNode* node = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImage:self.player.costume]];
    [node setScale:0.2];
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.frame.size];
    node.physicsBody.ContactTestBitMask = 0x1 << 9;
    
    node.position = [self.player assignCostumePosition];
    [node setZPosition:self.player.zPosition+1];//Brings costume in front of player
    return node;
}


//These methods aren't required but it just makes it a little less verbose and a little more structured

//Stop Tobj moving left or right by calling it's method
-(void)stopTactileObjectMovement:(TactileObject*)Tobj Direction:(int)d{
    [Tobj stopMovementActionsWithDirection:d];
}
//Move Tobj right by calling its method, speed can be altered
-(void)moveTactileObjectRight:(TactileObject*)Tobj speed:(int)s{
    [Tobj moveEntityRight:s];
}
//Left, too
-(void)moveTactileObjectLeft:(TactileObject*)Tobj speed:(int)s{
    [Tobj moveEntityLeft:s];
}
//Impulse Living Entity right using its method
-(void)impulseEntityRight:(LivingEntity*)Lent{
    [Lent impulseEntityRight];
}
//Left, too
-(void)impulseEntityLeft:(LivingEntity*)Lent{
    [Lent impulseEntityLeft];
}
//Jump Entity using its method
-(void)jumpEntity:(LivingEntity*)Lent{
    [Lent jumpEntity];
}
//Sets any Living Entity so that it bobs up and down across screen as it moves, using actual physics none of this cheap "moveByY" stuff
- (void)setFlying:(bool)f flappingfrequenct:(double)freq LivingEntity:(LivingEntity*)Lent{
    [Lent setFlying:f flappingfrequency:freq];
}












//>>>>>>>>>>>>>>>>>>>>NODE PLACEMENT<<<<<<<<<<<<<<<<<<<<
//Puts hte player in the right starting position for each scene

-(void)placePlayer:(int)scene{
    switch (scene) {
        case 0://Fun fact: This is also used to reset player position if he runs off screen left in the main level
            //Bottom left (Main level)
            [self placeEntWithLoc:1 Ent:self.player];
            break;
        case 1:
            //Top left-ish (Pit level)
            [self.player setPosition:CGPointMake(self.player.size.width*2, [UIScreen mainScreen].bounds.size.height-self.player.size.height*3)];
            break;
        default:
            break;
    }

}

//Places any entity in various re-used positions in the game
-(void)placeEntWithLoc:(int)loc Ent:(Entity*)ent{
    CGFloat screenwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    switch (loc) {
        case 0://Bottom Right, used for walking objects.
            [ent setPosition:CGPointMake(screenwidth+ent.frame.size.width/2, self.groundnode.frame.size.height+ent.frame.size.height/2)];
            [self moveNodeWithGround:ent Repeat:NO];
            break;
        case 1://Bottom Left, used for the player, no "MoveNodeWithGround" because it would just immediately run it off screen.
            [ent setPosition:CGPointMake(ent.frame.size.width/2,self.groundnode.frame.size.height+ent.frame.size.height/2)];
            break;
        case 2://Middle right, used for flying objects
            [ent setPosition:CGPointMake(screenwidth+ent.frame.size.width/2,screenheight/2)];
            [self moveNodeWithGround:ent Repeat:NO];
            break;
        case 3://75% right, used for low flying objects
            [ent setPosition:CGPointMake(screenwidth+ent.frame.size.width/2,screenheight/4)];
            [self moveNodeWithGround:ent Repeat:NO];
            break;
        default:
            break;
    }
}


-(void)loadDefaults{};

-(void)saveDefaults:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:true forKey:@"key"];
    [defaults synchronize];
}


@end
