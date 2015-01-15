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

    self.physicsWorld.gravity = CGVectorMake(0.0, -10.0);
    self.view.showsNodeCount = YES;
    self.view.showsFPS = YES;
}

-(void)setBoundsWithCategory:(int)cat{
    CGFloat screenwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    switch (cat) {
        case 0:
            self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-600, 0, screenwidth+1200, screenheight)];
            break;
        case 1:
            self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, screenwidth, screenheight)];
            break;
            
        default:
            break;
    }

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


@end
