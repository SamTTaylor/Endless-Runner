//
//  HighScoresViewControllerTest.m
//  Endless Runner
//
//  Created by acq14jp on 21/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HighScoresViewController.h"
#import "AppDelegate.h"

@interface HighScoresViewControllerTest : XCTestCase

@property (nonatomic, strong) HighScoresViewController *hsvc;
@property (nonatomic, strong) AppDelegate *app;
@property (nonatomic, strong) GameViewController *view;

@end

@implementation HighScoresViewControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.hsvc = [[HighScoresViewController alloc] init];
    self.app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)testHighScoreArray {
    [self.view saveScoreWithName:@"Jennifer" Score:10000 Facebook:NO];
    XCTAssertNotNil(self.app.highscores);
    bool highscoresaved;
    NSUInteger scoreIndex = [self.app.highscores indexOfObject: @"Jennifer"];
    if (scoreIndex == nan) {
        highscoresaved = false;
    } else {
        highscoresaved = true;
    }
    XCTAssertTrue(highscoresaved);
}


/*- (void)saveScoreWithName:(NSString*)name Score:(int)s Facebook:(bool)f{
 AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 NSMutableArray* maad = [[NSMutableArray alloc]initWithArray:ad.highscores];
 bool replaced = false;
 for (int i = 0; i < maad.count; i++){
 NSArray *delimitedarray = [[maad objectAtIndex:i] componentsSeparatedByString:@":  "];
 if ([(NSNumber *)delimitedarray.lastObject intValue] <= s){
 [maad insertObject:[NSString stringWithFormat:@"%@:  %i", name, s] atIndex:i];
 replaced = true;
 break;
 }
 }
 ad.highscores = [maad copy]; //Copies the local mutable array into the highscores array
 
 //Now write highscores array to plist
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];
 [ad.highscores writeToFile:[documentsDirectory stringByAppendingPathComponent:@"LennyHighScores.plist"] atomically:YES];
 
 if (f == true){//If share on facebook is selected the method is triggered
 [self ShareScoreonFacebook];
 }
 }*/

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
