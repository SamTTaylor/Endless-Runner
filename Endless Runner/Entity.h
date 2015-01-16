//
//  Entity.h
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


@interface Entity : SKSpriteNode //Top of the custom hierarchy

//>>>>>>>>>>>>>>>>>>>>PROPERTIES<<<<<<<<<<<<<<<<<<<<
@property SKTexture* nodetexture; //All entities in the game's hierarchy must have a texture

//>>>>>>>>>>>>>>>>>>>>METHODS<<<<<<<<<<<<<<<<<<<<
- (id)initWithTexture:(SKTexture *)nodetexture;
- (CGRect)collisionBoundingBox;

@end
