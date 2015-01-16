//
//  GameModel.h
//  Endless Runner
//
//  Created by acp14stt on 28/11/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Enemy.h"
#import "Fox.h"
#import "Bird.h"
#import "Beehive.h"
#import "Frog.h"
#import "Wolf.h"
#import "TactileObject.h"
#import "Stump.h"
#import "Bog.h"
#import "Spikes.h"
#import "Mushroom.h"
#import "Bush.h"
#import "Berry.h"
#import "Butterfly.h"
#import "Haven.h"

@interface GameModel : NSObject 

@property Player* player;
@property SKNode* groundnode;
@property float speed;
@property float tiltsensitivity;
@property NSMutableArray *enemies;
@property NSMutableArray *obstacles;
@property NSMutableArray *lives;
@property int score;
@property int difficultyscore;
@property int difficultythreshold;
@property int currentdifficulty;
@property int groundspeed;


@property SKTexture *groundtexture;
@property SKTexture *backgroundtexture;

- (id)initWithPlayer;

- (void) incrementScore:(int)i;
- (void) incrementDifficultyScore:(int)i;
- (void) updateDifficulty;

- (void)addLife;
- (void)updateLives;
- (void)removeLife;

- (TactileObject*) spawnRandomObstacle;
- (Enemy*) spawnRandomEnemy;

//Objects that dont fit into an initial array
- (TactileObject*) spawnPit;
- (Butterfly*) spawnButterfly;

- (Haven*) spawnHaven;

- (void)moveNodeWithGround:(SKNode*)node Repeat:(bool)r;
- (void)placePlayer:(int)scene;

- (void)placeEntWithLoc:(int)loc Ent:(Entity*)ent;



- (void)stopTactileObjectMovement:(TactileObject*)Tobj Direction:(int)d;
- (void)moveTactileObjectRight:(TactileObject*)Tobj speed:(int)s;
- (void)moveTactileObjectLeft:(TactileObject*)Tobj speed:(int)s;
- (void)impulseEntityRight:(LivingEntity*)Lent;
- (void)impulseEntityLeft:(LivingEntity*)Lent;
- (void)jumpEntity:(LivingEntity*)Lent;
- (void)setFlying:(bool)f flappingfrequenct:(double)freq LivingEntity:(LivingEntity*)Lent;

-(TactileObject*)newEnvironmentObjectWithImageNamed:(NSString*)name scale:(float)scale;

@end
