//
//  Player.h
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivingEntity.h"

@interface Player : LivingEntity

@property bool inmushroom;
@property bool inbog;
@property int lives;
@property bool invulnerable;
@property SKAction *walkAnimation;
@property bool animated;

- (void)stopAnimation;
- (void)takeLife;
- (void)collidedWithBog;
- (void)collidedWithMushroom;
- (void)collidedWithEnemy;

@end
