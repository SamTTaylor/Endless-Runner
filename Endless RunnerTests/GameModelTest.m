//
//  GameModelTest.m
//  Endless Runner
//
//  Created by acq14jp on 21/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GameModel.h"
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

//Initiate Enemies Array and populate with Enemies
-(void)testEnemiesArray {
    self.model.enemies = [[NSMutableArray alloc] init];
    XCTAssertNotNil(self.model.enemies);
    [self.model populateEnemyArray];
    XCTAssertEqual(self.model.enemies.count, 5);
}

-(void)testEnemies {
    self.model.enemies = [[NSMutableArray alloc] init];
    XCTAssertNotNil(self.model.enemies);
    [self.model populateEnemyArray];
    XCTAssertEqual(self.model.enemies.count, 5);
}

//Initiate Obstacle Array and populate with Obstacles
-(void)testObstacleArray {
    self.model.obstacles = [[NSMutableArray alloc] init];
    XCTAssertNotNil(self.model.obstacles);
    [self.model populateObstacleArray];
    XCTAssertEqual(self.model.obstacles.count, 5);
}

//>>>>>>>>>>>>>>>>>>>>TEST LIVES, SCORE, DIFFICULTY<<<<<<<<<<<<<<<<<<<<

//Initiate Lives Array and Test adding and removing lives
-(void)testLives {
    self.model.lives = [[NSMutableArray alloc] init];
    [self.model populateLivesArray];
    XCTAssertNotNil(self.model.lives);
    [self.model addLife];
    [self.model addLife];
    [self.model addLife];
    [self.model removeLife];
    XCTAssertEqual(self.model.lives.count, 2);
}

//Score is 0 at the start of the game
-(void)testScore {
    XCTAssertEqual(self.model.score, 0);
    //score can be set to any value
    [self.model setScore:5];
    XCTAssertEqual(self.model.score, 5);
    //score can be incremented by any value
    [self.model incrementScore:1];
    XCTAssertEqual(self.model.score, 6);
}

//Difficulty Score is used to increment the difficulty based on the score
-(void)testDifficultyScore {
    XCTAssertEqual(self.model.difficultyscore, 0);
    //can be incremented by any value
    [self.model incrementDifficultyScore:1];
    XCTAssertEqual(self.model.difficultyscore, 1);
}

//past the difficutly threshold the difficulty will be incremented
-(void)testDifficultyThreshold {
    XCTAssertEqual(self.model.difficultythreshold, 0);
    [self.model setDifficultythreshold:30];
    XCTAssertEqual(self.model.difficultythreshold, 30);
}

//Current difficulty starts at 0
-(void)testCurrentDifficulty {
    XCTAssertEqual(self.model.currentdifficulty, 0);
    //can be set to any value
    [self.model setCurrentdifficulty:1];
    XCTAssertEqual(self.model.currentdifficulty, 1);
}

//Ground Speed 0 at the start
-(void)testGroundSpeed {
    //can be set to any given value
    [self.model setGroundspeed:20];
    XCTAssertEqual(self.model.groundspeed, 20);
}

//>>>>>>>>>>>>>>>>>>>>TEST UNLOCKABLES<<<<<<<<<<<<<<<<<<<<

-(void)saveAchievementBasedOnLocation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.mmvc.austria = [defaults boolForKey:@"austria"];
    self.mmvc.Country = @"Austria";
    if ([defaults boolForKey:@"austria"] && [self.mmvc.Country isEqualToString:@"Austria"]) {
        [self.model saveAchievement:@"austria"];
    }
    bool savedachievement;
    NSNumber* key = [[NSUserDefaults standardUserDefaults] objectForKey:@"austria"];
    if (key == nil) {
        savedachievement = false;
    } else {
        savedachievement = true;
    }
    XCTAssertTrue(savedachievement);
}

-(void)saveAchievementBasedOnScore {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.mmvc.superlenny = [defaults boolForKey:@"superlenny"];
    if ([defaults boolForKey:@"superlenny"] == false) {
        [self.model saveAchievement:@"superlenny"];
    }
    bool savedachievement;
    NSNumber* key = [[NSUserDefaults standardUserDefaults] objectForKey:@"superlenny"];
    if (key == nil) {
        savedachievement = false;
    } else {
        savedachievement = true;
    }
    XCTAssertTrue(savedachievement);
}

-(void)saveAchievementBasedOnEvent {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.mmvc.halloween = [defaults boolForKey:@"halloween"];
    if ([defaults boolForKey:@"halloween"]) {
        [self.model saveAchievement:@"halloween"];
    }
    bool savedachievement;
    NSNumber* key = [[NSUserDefaults standardUserDefaults] objectForKey:@"halloween"];
    if (key == nil) {
        savedachievement = false;
    } else {
        savedachievement = true;
    }
    XCTAssertTrue(savedachievement);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [self.model populateEnemyArray];
        [self.model populateObstacleArray];
    }];
}

@end
