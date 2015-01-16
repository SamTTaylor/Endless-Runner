//
//  TactileObject.h
//  Endless Runner
//
//  Created by acp14stt on 05/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Entity.h"
#import "ToastView.h"

@interface TactileObject : Entity //2nd in the hierarchy


@property int difficultylevel;//Tactile objects can be assigned a difficulty level for being instantiated at certain times in game
@property SKLightNode* light; //All Tactile objects have a light node ready for instantiation and reference

-(void)moveEntityLeft:(int)speed; //All tactile objects can be moved left or right at any speed
-(void)moveEntityRight:(int)speed;
-(void)stopMovementActionsWithDirection:(int)d;//They can also be stopped moving left or right

- (void) animateSelf;//All tactile objects can have a default animation that can be called
- (void) deathAnimation;//All tactile objects can have a death animation that can be called
- (void)introduction:(UIView*)inview;//All tactile objects can have a specific introduction toast

-(void) addLightNode;//used to add/remove the objects light node at any time
-(void) removeLightNode;

@end
