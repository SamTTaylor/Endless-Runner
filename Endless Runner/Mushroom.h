//
//  Mushroom.h
//  Endless Runner
//
//  Created by acp14stt on 12/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "TactileObject.h"

@interface Mushroom : TactileObject

@property bool touched;//For reversing movement controls
@property SKAction *burstAnimation;


@end
