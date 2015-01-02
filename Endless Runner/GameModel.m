//
//  GameModel.m
//  Endless Runner
//
//  Created by acp14stt on 28/11/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel

- (id)initWithPlayer{
    self = [super init];
    if (self) {
        //Initialization code
        self.player = [[Player alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:@"avatar"]];
        self.backgroundnode = [SKSpriteNode spriteNodeWithImageNamed:@"bgforest"];
    }
    return self;
}

-(void)rotatePlayer{
    
    SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
    
    [self.player.node runAction:[SKAction repeatActionForever:action]];
}

-(void)movePlayer{
    SKAction *action = [SKAction moveBy:CGVectorMake(100, 0) duration:10];
    
    [self.player.node runAction:[SKAction repeatActionForever:action]];
}
@end
