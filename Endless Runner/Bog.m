//
//  Bog.m
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Bog.h"

@implementation Bog

- (id)initWithTexture:(SKTexture *)nodetexture
{
    self = [super initWithTexture:nodetexture];
    if (self) {
        //Initialization code
        //Bog has specific category mask so player can get stuck in it
        
        [self animateSelf];
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 20)];
        self.physicsBody.categoryBitMask = 0x1 << 5;
        self.physicsBody.dynamic = false;
    }
    return self;
}

//Bog specific introduction
-(void)introduction:(UIView*)inview{
    [super introduction:inview];
    [ToastView createToast:inview text:@"Bogs will stop you jumping!" duration:5.0];
}

//Bog animation sequence
- (void) animateSelf{
    [super animateSelf];
    //Loop through frames for animation
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:16];
    for (int i = 1; i < 6; i++) {
        NSString *textureName = [NSString stringWithFormat:@"bog%d.png", i];
        SKTexture *texture =[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    SKTexture *texture =[SKTexture textureWithImageNamed:@"bog0.png"];
    [textures addObject:texture];
    
    [self removeActionForKey:[NSString stringWithFormat:@"animate %@", self.class]];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        //Add Bubbles
        self.bubbleAnimation =[SKAction animateWithTextures:textures timePerFrame:3];
    }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        //Add Bubbles
        [self runAction:[SKAction repeatActionForever:self.bubbleAnimation]];
    }], [SKAction waitForDuration:1]]] count:5]]] withKey:[NSString stringWithFormat:@"animate %@", self.class]];
}

@end
