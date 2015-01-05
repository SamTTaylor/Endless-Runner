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
        self.speed = 0.005;
    }
    return self;
}

-(void)moveNode:(SKNode*)node Repeat:(bool)r{
    //Sets up the ground sprites, makes them scroll passed in a loop
    if (r == true){
        SKAction* move = [SKAction moveByX:-self.groundtexture.size.width*2 y:0 duration:self.speed * self.groundtexture.size.width*2];
        SKAction* reset = [SKAction moveByX:self.groundtexture.size.width*2 y:0 duration:0];
        SKAction* loopMovement = [SKAction repeatActionForever:[SKAction sequence:@[move, reset]]];
        [node runAction:loopMovement];
    } else {
        CGFloat distance =  [UIScreen mainScreen].bounds.size.width + node.frame.size.width;
        SKAction* move = [SKAction moveByX:-distance y:0 duration:self.speed * distance];
        SKAction* remove = [SKAction removeFromParent];
        SKAction* Movement = [SKAction sequence:@[move, remove]];
        [node runAction:Movement];
    }
    
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
            [ent.node setPosition:CGPointMake(screenwidth+ent.node.frame.size.width/2, self.groundnode.frame.size.height+ent.node.frame.size.height/2)];
            [self moveNode:ent.node Repeat:NO];
            break;
        case 1://Bottom Left
            [ent.node setPosition:CGPointMake(ent.node.frame.size.width/2,self.groundnode.frame.size.height+ent.node.frame.size.height/2)];
            break;
        default:
            break;
    }
}

-(TactileObject*)newEnvironmentObjectWithImageNamed:(NSString*)name{
    TactileObject  *Tobj = [[TactileObject alloc] initWithNode:[SKSpriteNode spriteNodeWithImageNamed:name]];
    
    return Tobj;
}
@end
