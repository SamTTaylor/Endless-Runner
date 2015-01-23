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

////>>>>>>>>>>>>>>>>>>>>PROPERTIES<<<<<<<<<<<<<<<<<<<<
@property Player* player;//Used to keep track of the player node
@property SKNode* groundnode;//Used to measure the height of the ground
@property float tiltsensitivity;
@property (strong) NSMutableArray *enemies; //Array of 1 instance of each spawnable enemy
@property (strong) NSMutableArray *obstacles;//Array of 1 instance of each spawnable obstacle
@property NSMutableArray *lives;//Array of life nodes to represent player lives
@property int score;//Current game score
@property int difficultyscore;//Score used to measure progress in current difficulty level
@property int difficultythreshold;//Used to progress to the next level when difficulty score = this value
@property int currentdifficulty;//Current difficulty level
@property int groundspeed;//Used to move nodes at the same speed as the ground

@property SKTexture *groundtexture; //Used to move nodes across the screen the correct distance

////>>>>>>>>>>>>>>>>>>>>METHODS<<<<<<<<<<<<<<<<<<<<
- (id)initWithPlayer;//Model should always be created with a Player node


- (void)saveAchievement:(NSString*)achievement;//Unlocks content from the User Defaults


- (void) incrementScore:(int)i; //Change score by any amount
- (void) incrementDifficultyScore:(int)i;//Used by the game controller to increment difficulty
- (void) updateDifficulty;//Used to increment the difficulty level when the score breaches the threshold



- (void)addLife;//Adds a life to the life node array
- (void)updateLives;//Moves the life node array 1 closer to the player's life number (if it is inaccurate)
- (void)removeLife;//Removes 1 life from the life node array

-(void) populateEnemyArray;//fill the Enemy Array with frames
-(void) populateObstacleArray;//fill the Obstacle Array with frames

- (TactileObject*) spawnRandomObstacle;//Creates and passes an instance of a random obstacle from the array
- (Enemy*) spawnRandomEnemy;//Creates and passes an instance of a random enemy from the array

//Objects that dont fit into an initial array
- (TactileObject*) spawnPit; //Creates and passes an instance of a Tactile Object with the Pit texture
- (Butterfly*) spawnButterfly; //Creates and passes an instance of a butterfly object
- (Haven*) spawnHaven; //Creates and passes an instance of a haven object




- (void)moveNodeWithGround:(SKNode*)node Repeat:(bool)r;//Move any node with the ground node across the screen
-(void)followPlayer:(SKSpriteNode*)node;//Have any node follow just behind the player
-(SKSpriteNode*)dressPlayer;

- (void)placePlayer:(int)scene; //Places a player in the appropriate starting position depending on the scene

- (void)placeEntWithLoc:(int)loc Ent:(Entity*)ent; //Places entity in a number of convenient locations



- (void)stopTactileObjectMovement:(TactileObject*)Tobj Direction:(int)d; //Triggers the relevant stop movement method in the target Tobj
- (void)moveTactileObjectRight:(TactileObject*)Tobj speed:(int)s; //Triggers the move right method in the target Tobj while defining the speed
- (void)moveTactileObjectLeft:(TactileObject*)Tobj speed:(int)s; //Same but left
- (void)impulseEntityRight:(LivingEntity*)Lent; //Triggers the impulse right method in any living entity
- (void)impulseEntityLeft:(LivingEntity*)Lent; //Same but left
- (void)jumpEntity:(LivingEntity*)Lent; //Triggers the jump method in any living entity
- (void)setFlying:(bool)f flappingfrequenct:(double)freq LivingEntity:(LivingEntity*)Lent; //Triggers flying in any living entity with flap frequency


-(void)saveDefaults;
- (void) populateLivesArray;

@end
