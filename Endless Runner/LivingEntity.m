//
//  LivingEntity.m
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "LivingEntity.h"

@implementation LivingEntity
//

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.speed = 20;
        
    }
    return self;
}

//Living entities refer to their own speed when moving, it cannot be defined with each command
-(void)moveEntityRight:(int)speed{
        [super moveEntityRight:self.speed];
}
-(void)moveEntityLeft:(int)speed{
        [super moveEntityLeft:self.speed];
}


//Living entities can be impulsed left, right or up, the strength also depends on their speed
-(void)impulseEntityRight{
    CGFloat impulseX = self.speed*50.0f;
    CGFloat impulseY = 0.0f;
    [self.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:self.position];
}
-(void)impulseEntityLeft{
    CGFloat impulseX = self.speed*-50.0f;
    CGFloat impulseY = 0.0f;
    [self.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:self.position];
}
-(void)jumpEntity{
    CGFloat impulseX = 0.0f;
    CGFloat impulseY = self.speed * 100.0f;
    [self.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:self.position];
    
}



//This instantiates and triggers the flying timer using the flap frequency set. If flying is being set to false then nothing happens.
- (void) setFlying:(bool)f flappingfrequency:(double)flap{
    if (f == true) {
        self.flying = true;
        self.physicsBody.density = 0.9;
        NSTimer* flighttimer = [NSTimer scheduledTimerWithTimeInterval:flap target:self selector:@selector(flighttimerFireMethod:) userInfo:nil repeats:YES];
        [flighttimer fire];
    } else {
        self.flying = false;
    }
}
//This will cause any living entity to bob up and down, using its own downward velocity at the of the tick to calculate how hard the upward impulse needs to be, if the flight timer tries to make the entity flap while its flying is disabled, it is invalidated.
- (void)flighttimerFireMethod:(NSTimer *)flighttimer{
    if(self.flying == true){
        float prevspeed = self.speed;
        if (self.physicsBody.velocity.dy < 0 && self.position.y < [UIScreen mainScreen].bounds.size.height/2){
          self.speed = -(self.physicsBody.velocity.dy/10);
          [self jumpEntity];
        }
        self.speed = prevspeed;
    } else {
        [flighttimer invalidate];
    }
}

@end
