//
//  SettingsViewController.m
//  Endless Runner
//
//  Created by acp14stt on 02/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "SettingsViewController.h"
#import "MainMenuViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.tiltbool == true){
        self.tiltcontrol.selectedSegmentIndex = 1;
    } else {
        self.tiltcontrol.selectedSegmentIndex = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (![[self.navigationController viewControllers] containsObject:self]) {
        [(MainMenuViewController*)self.navigationController.viewControllers[0] setTiltbool:self.tiltbool];
    }
}


-(IBAction)tiltcontrolMoved:(UISegmentedControl*)sender{
    self.tiltbool = sender.selectedSegmentIndex;
}

@end
