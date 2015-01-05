//
//  GameScene.m
//  Endless Runner
//
//  Created by acp14stt on 25/11/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    //self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-100, 0, self.frame.size.width+200, self.frame.size.height)];
    [self.physicsWorld setContactDelegate:self];
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


@end
