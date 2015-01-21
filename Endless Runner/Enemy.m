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
//The reason bit masks are not set in this class and inherited automatically is that when they are set here you cannot override them in other classes, or set them outside of initialisation. I think its buggy



//Dummy methods for inheritance 
- (void) animateSelf{}
- (void) deathAnimation{[super deathAnimation];}
@end
