//
//  GameScene.h
//  Endless Runner
//

//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene 

@property SKSpriteNode* currentBackgroundImage;

-(void)setBoundsWithCategory:(int)cat;

@end
