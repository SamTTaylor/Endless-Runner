//
//  Player.h
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivingEntity.h"
#import "Butterfly.h"

@interface Player : LivingEntity

//>>>>>>>>>>>>>>>>>>>>PROPERTIES<<<<<<<<<<<<<<<<<<<<
@property int jumpcount;
@property bool inmushroom;//Used to reverse movement direction while affected by a mushroom
@property bool inbog;//Used to stop jumping while in a bog
@property int lives;//Used to monitor player lives
@property bool invulnerable;//Used to stop enemy overcollision causing excessive loss of life
@property SKAction *walkAnimation;//Used to animate player walk
@property SKAction *jumpAnimation;//Used to animate player jump
@property SKAction *injuredAnimation;//Used to animate when player loses one life
@property bool animated;//Used to start and stop animation
@property bool gotfollower;//Used to limit follower count to 1
@property Butterfly* currentbutterfly;//Used to reference current butterfly follower
@property UIImage* costume; //Player's current costume image
@property CGPoint costumeposition; //Costumes current position in player image
@property NSMutableArray* costumearray; //Passed array containing all costumes for player to choose from


//>>>>>>>>>>>>>>>>>>>>METHODS<<<<<<<<<<<<<<<<<<<<
- (void)resetJumpCount; //Resets player jumping
- (void)stopAnimation;//used to stop walking animation
- (void)takeLife;//Used to try and take 1 life from the player
- (void)collidedWithBog;//Used to trigger bog effecs
- (void)collidedWithMushroom;//Mushroom effects
- (void)collidedWithEnemy;//enemy effects
- (CGPoint)assignCostumePosition;


@end
