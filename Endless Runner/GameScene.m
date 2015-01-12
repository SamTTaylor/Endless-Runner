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
    CGFloat screenwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-600, 0, screenwidth+1200, screenheight)];
    self.physicsWorld.gravity = CGVectorMake(0.0, -10.0);
    self.view.showsNodeCount = YES;
    self.view.showsFPS = YES;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


@end
