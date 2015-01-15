//
//  TactileObject.h
//  Endless Runner
//
//  Created by acp14stt on 05/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Entity.h"
#import "ToastView.h"

@interface TactileObject : Entity

@property int difficultylevel;
@property SKLightNode* light;

-(void)moveEntityLeft:(int)speed;
-(void)moveEntityRight:(int)speed;
-(void)stopMovementActionsWithDirection:(int)d;

- (void)animateSelf;
- (void)deathAnimation;
- (void)introduction:(UIView*)inview;

-(void) addLightNode;
-(void) removeLightNode;

@end
