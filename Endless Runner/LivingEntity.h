//
//  LivingEntity.h
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Entity.h"

@interface LivingEntity : Entity

@property int health;
@property bool flying; 


- (id)initWithNode:(SKSpriteNode*)node;

@end
