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
        self.backgroundtexture = [SKTexture textureWithImageNamed:@"bgforest"];
        self.groundtexture = [SKTexture textureWithImageNamed:@"grass"];
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
    [self placeEntWithLoc:1 Ent:self.player];
}

-(void)placeEntWithLoc:(int)loc Ent:(Entity*)ent{
    CGFloat screenwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    switch (loc) {
        case 0://Bottom Right
            [ent.node setPosition:CGPointMake(screenwidth-(ent.node.frame.size.width/2) , screenheight/2)];
            break;
        case 1://Bottom Left
            [ent.node setPosition:CGPointMake(ent.node.frame.size.width/2,screenheight/2)];
            break;
        
            
        default:
            break;
    }
}

-(TactileObject*)newEnvironmentObject{
    TactileObject  *Tobj = [[TactileObject alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:@"rock"]];
    Tobj.node.yScale = 0.5;
    Tobj.node.xScale = 0.5;
    return Tobj;
}
@end
