//
//  LivingEntity.h
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Entity.h"
#import "TactileObject.h"

@interface LivingEntity : TactileObject

@property int health;
@property bool flying; 
@property int speed;

- (id)initWithNode:(SKSpriteNode*)node;

-(void)impulseEntityRight;
-(void)impulseEntityLeft;
-(void)jumpEntity;

@end
