//
//  Entity.m
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Entity.h"

@implementation Entity


//The game's objects are mostly contained inside a hierarchy of objects of which Entity is the highest.
//This allows the organised handling, assigning and overriding of properties and methods and generally makes life much easier

//The entity class itself just states that each entity must have an initWithTexture method which picks up and applies its own texture.
- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        
    }
    return self;
}

-(CGRect)collisionBoundingBox {
    return CGRectInset(self.frame, 2, 0);
}



@end
