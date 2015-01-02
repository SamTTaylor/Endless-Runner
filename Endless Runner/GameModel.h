//
//  GameModel.h
//  Endless Runner
//
//  Created by acp14stt on 28/11/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface GameModel : NSObject

@property Player* player;
@property SKSpriteNode* backgroundnode;

- (id)initWithPlayer;

- (void)rotatePlayer;
- (void)impulseEntityRight:(Entity*)ent multiplier:(int)m;
- (void)impulseEntityLeft:(Entity*)ent multiplier:(int)m;
- (void)jumpEntity:(Entity*)ent multiplier:(int)m;

@end
