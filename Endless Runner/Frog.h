//
//  Frog.h
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Enemy.h"


@interface Frog : Enemy

@property int tonguelength;
@property TactileObject *tongue;

-(void)addTongue;

@end
