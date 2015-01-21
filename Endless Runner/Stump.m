//
//  Stump.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Stump.h"

@implementation Stump

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        self.physicsBody.categoryBitMask = 0x1 << 4;
    }
    return self;
}

@end
