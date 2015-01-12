//
//  TactileObject.h
//  Endless Runner
//
//  Created by acp14stt on 05/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Entity.h"

@interface TactileObject : Entity

-(void)moveEntityLeft:(int)speed;
-(void)moveEntityRight:(int)speed;
-(void)stopMovementActionsWithDirection:(int)d;

@end
