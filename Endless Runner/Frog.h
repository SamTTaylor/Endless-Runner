//
//  Frog.h
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "Enemy.h"


@interface Frog : Enemy

@property TactileObject *tongue;

-(void)addTongue;//Initialises tongue node and sets it moving

@end
