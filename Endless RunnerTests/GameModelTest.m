//
//  GameModelTest.m
//  Endless Runner
//
//  Created by acq14jp on 23/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GameModel.h"
#import "GameViewController.h"
#import "MainMenuViewController.h"


@interface GameModelTest : XCTestCase

@property(nonatomic, strong) GameModel *model;
@property(nonatomic, strong) GameViewController *view;
@property(nonatomic, strong) LivingEntity *lent;
@property(nonatomic, strong) TactileObject *tact;
@property(nonatomic, strong) MainMenuViewController *mmvc;

@end

@implementation GameModelTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.model = [[GameModel alloc]init];
}

//>>>>>>>>>>>>>>>>>>>>TEST PLAYER, ENEMIES, OBSTACLES <<<<<<<<<<<<<<<<<<<<

//Initiate Player With Texture
-(void)testPlayer {
    self.model.player = [[Player alloc] initWithTexture:self.lent.nodetexture];
    XCTAssertNotNil(self.model.player);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
