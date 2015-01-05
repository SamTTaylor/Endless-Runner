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

-(void)impulseEntityRight:(Entity*)ent multiplier:(int)m{
    CGFloat impulseX = m*50.0f;
    CGFloat impulseY = 0.0f;
    [ent.node.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:ent.node.position];
}

-(void)impulseEntityLeft:(Entity*)ent multiplier:(int)m{
    CGFloat impulseX = m*-50.0f;
    CGFloat impulseY = 0.0f;
    [ent.node.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:ent.node.position];
}

-(void)jumpEntity:(Entity*)ent multiplier:(int)m{
    CGFloat impulseX = 0.0f;
    CGFloat impulseY = m * 50.0f;
    [ent.node.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:ent.node.position];
    
}

-(void)placePlayer{
    //Bottom left
    self.player.node.yScale = 0.5;
    self.player.node.xScale = -0.5;
    [self.player.node setPosition:CGPointMake(self.player.node.frame.size.width/2, self.player.node.frame.size.height)];
}
-(TactileObject*)newEnvironmentObjectWithX:(int)x WithY:(int)y{
    TactileObject  *Tobj = [[TactileObject alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:@"rock"]];
    Tobj.node.yScale = 0.5;
    Tobj.node.xScale = 0.5;
      [Tobj.node setPosition:CGPointMake(x, y)];
    
    return Tobj;
}
@end
