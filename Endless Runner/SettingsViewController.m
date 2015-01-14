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
    [self setbgPickerImage];
    [self setavatarPickerImage];
}

- (void)setbgPickerImage{
    UIImage *bg =[UIImage imageNamed:self.bgimagestring];
    bg = [self scaleImage:bg toSize:CGSizeMake(300, 160)];
    [self.bgimageview setImage:bg];
}

- (void)setavatarPickerImage{
    UIImage *avatar =[UIImage imageNamed:self.avatarimagestring];
    avatar = [self scaleImage:avatar toSize:CGSizeMake(144, 160)];
    [self.avatarimageview setImage:avatar];
}

-(UIImage*) scaleImage: (UIImage*)image toSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
        [(MainMenuViewController*)self.navigationController.viewControllers[0] setBgimagestring:self.bgimagestring];
    }
}


-(IBAction)tiltcontrolMoved:(UISegmentedControl*)sender{
    self.tiltbool = sender.selectedSegmentIndex;
}

@end
