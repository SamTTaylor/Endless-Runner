//
//  GameScene.h
//  Endless Runner
//

//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Berry.h"

@interface GameScene : SKScene 

////>>>>>>>>>>>>>>>>>>>>METHODS<<<<<<<<<<<<<<<<<<<<
-(void)setBoundsWithCategory:(int)cat; //Set physics world to square
-(void) buildPitScene;//Builds pit challenge scene 
@end
