//
//  Entity.m
//  Endless Runner
//
//  Created by acp14stt on 03/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Entity.h"

@implementation Entity

- (id)initWithNode:(SKSpriteNode*)node
{
    self = [super init];
    if (self) {
        //Initialization code
        self.node = node;
        self.direction = 1;
    }
    return self;
}

-(CGRect)collisionBoundingBox {
    return CGRectInset(self.node.frame, 2, 0);
}

@end
