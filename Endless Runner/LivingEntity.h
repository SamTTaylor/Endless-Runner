//
//  LivingEntity.h
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Entity.h"
#import "TactileObject.h"

@interface LivingEntity : TactileObject //3rd in the hierarchy

@property bool flying; //All living entities can fly if they want
@property float myspeed;//All living entities can have their movement and jump speed adjusted

-(void)impulseEntityRight; //All living entities can be shoved left or right
-(void)impulseEntityLeft;
-(void)jumpEntity;//All living entities can jump
-(void) setFlying:(bool)f flappingfrequency:(double)flap; //All living entities can fly
@end
