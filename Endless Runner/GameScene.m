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
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-600, 0, self.frame.size.width+1200, self.frame.size.height)];
    self.physicsWorld.gravity = CGVectorMake(0.0, -10.0);
    self.view.showsNodeCount = YES;
    self.view.showsFPS = YES;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


@end
