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
#import "TactileObject.h"

@interface GameModel : NSObject <SKPhysicsContactDelegate> {
    
    SKSpriteNode* _Enemy;
}

@property Player* player;
@property SKTexture* backgroundtexture;
@property SKTexture* groundtexture;
@property SKNode* groundnode;
@property float speed;
@property float tiltsensitivity;

- (id)initWithPlayer;
- (void)moveNodeWithGround:(SKNode*)node Repeat:(bool)r;
- (void)placePlayer;

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
