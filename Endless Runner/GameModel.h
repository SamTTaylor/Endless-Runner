//
//  GameModel.h
//  Endless Runner
//
//  Created by acp14stt on 28/11/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "TactileObject.h"

@interface GameModel : NSObject

@property Player* player;
@property SKTexture* backgroundtexture;
@property SKTexture* groundtexture;
@property SKNode* groundnode;
@property float speed;

- (id)initWithPlayer;
- (void)moveNode:(SKNode*)node Repeat:(bool)r;
- (void)placePlayer;
- (void)impulseEntityRight:(Entity*)ent multiplier:(int)m;
- (void)impulseEntityLeft:(Entity*)ent multiplier:(int)m;
- (void)placeEntWithLoc:(int)loc Ent:(Entity*)ent;
- (void)jumpEntity:(Entity*)ent multiplier:(int)m;

-(TactileObject*)newEnvironmentObjectWithImageNamed:(NSString*)name;

@end
