//
//  Entity.h
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Entity : NSObject

@property SKSpriteNode* node;
@property int direction;


- (id)initWithNode:(SKSpriteNode*)node;

@end
