//
//  Enemy.m
//  Endless Runner
//
//  Created by acp14stt on 09/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
    }
    return self;
}


- (void) animateSelf{}
- (void) deathAnimation{[super deathAnimation];}
@end
