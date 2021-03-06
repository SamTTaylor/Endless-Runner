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
    
    //Gravity on all worlds is consistent -10 downard
    self.physicsWorld.gravity = CGVectorMake(0.0, -10.0);
    
    //For performance monitoring
        //self.view.showsNodeCount = YES;
        //self.view.showsFPS = YES;
}

//Sets bounds for different scenes, split into categories using screen size
-(void)setBoundsWithCategory:(int)cat{
    CGFloat screenwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    switch (cat) {
        case 0://Main scene, uses screen bounds with elongated width
            self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-600, 0, screenwidth+1200, screenheight)];
            break;
        case 1://Pit scene, shrinks screen bounds to match pit background texture
            self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(screenwidth*0.08, screenheight*0.06, screenwidth*0.81, screenheight*0.8)];
            
            break;
        default:
            break;
    }

}

//Used to create a blocking node for platforms/blocks in levels that are not just square
-(void) createBarrier:(CGSize)size Position:(CGPoint)pos Scene:(GameScene*)scene Dynamic:(bool)d{
    //Create node using size passed
    SKSpriteNode *node = [[SKSpriteNode alloc] initWithColor:[UIColor colorWithRed:0.6 green:0.1 blue:0.1 alpha:1.0] size:CGSizeMake(size.width*5, size.height*5)];
    //Resizing the scale makes the nodes more slippery - which I doubt is intended but its useful
    [node setScale:0.2];
    
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    node.position = pos;
    node.shadowCastBitMask = 0x1 << 1; //All created nodes cast shadows
    node.physicsBody.dynamic = d; //All nodes defy gravity but some can be moved by force
    node.physicsBody.affectedByGravity = false;
    [node setZPosition:1];//All nodes appear in front of Background, but behind everything else
    [scene addChild:node];
}


//Fills pit scene with the required nodes
-(void) buildPitScene{
    //Bottom left/right blocks
    [self createBarrier:CGSizeMake(120, 60) Position:CGPointMake(self.size.width*0.16, self.size.height*0.12) Scene:self Dynamic:false];
    [self createBarrier:CGSizeMake(120, 60) Position:CGPointMake(self.size.width - self.size.width*0.18,self.size.height*0.12) Scene:self Dynamic:false];
    
    //Right/left blocks
    [self createBarrier:CGSizeMake(50, 400) Position:CGPointMake(self.size.width*0.19,self.size.height*0.613) Scene:self Dynamic:false];
    [self createBarrier:CGSizeMake(50, 400) Position:CGPointMake(self.size.width-self.size.width*0.22,self.size.height*0.613) Scene:self Dynamic:false];
    
    //Top block
    [self createBarrier:CGSizeMake(600, 30) Position:CGPointMake(self.size.width/2,self.size.height*0.9) Scene:self Dynamic:false];
    
    //Bottom left/right platforms
    [self createBarrier:CGSizeMake(200, 30) Position:CGPointMake(self.size.width*0.3,self.size.height*0.4) Scene:self Dynamic:false];
    [self createBarrier:CGSizeMake(144.5, 30) Position:CGPointMake(self.size.width-self.size.width*0.3,self.size.height*0.4) Scene:self Dynamic:true];
    
    //Top left of vertical platform
    [self createBarrier:CGSizeMake(200, 30) Position:CGPointMake(self.size.width-self.size.width*0.3,self.size.height*0.693) Scene:self Dynamic:false];
    
    //Vertical platform
    [self createBarrier:CGSizeMake(30, 250) Position:CGPointMake(self.size.width-self.size.width*0.4,self.size.height*0.543) Scene:self Dynamic:false];
    
    //Top right of vertical platform
    [self createBarrier:CGSizeMake(200, 30) Position:CGPointMake(self.size.width-self.size.width*0.483,self.size.height*0.693) Scene:self Dynamic:false];
    
    
    //This is a berry
    Berry *berry = [[Berry alloc] initWithTexture:[SKTexture textureWithImageNamed:@"berry"]];
    //Positioned in the "box" created by the barriers
    [berry setPosition:CGPointMake(self.size.width-self.size.width*0.31,self.size.height*0.45)];
    [berry setZPosition:19];
    [self addChild:berry];
    [berry introduction:self.view];
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


@end
