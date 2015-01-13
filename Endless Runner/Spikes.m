//
//  Spikes.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Spikes.h"

@implementation Spikes

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        [self setScale:0.3];
        self.physicsBody.categoryBitMask = 0x1 << 8;
    }
    return self;
}

@end
