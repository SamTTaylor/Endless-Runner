//
//  Spikes.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Spikes.h"

@implementation Spikes

- (id)initWithNode:(SKSpriteNode*)node
{
    self = [super initWithNode:node];
    if (self) {
        //Initialization code
        [self.node setScale:0.3];
        node.physicsBody.categoryBitMask = 0x1 << 8;
    }
    return self;
}
@end
