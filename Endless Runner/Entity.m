//
//  Entity.m
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Entity.h"

@implementation Entity

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
