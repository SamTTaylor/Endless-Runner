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
    //Let the tiltbool control mirror the current selection
    if (self.tiltbool == true){
        self.tiltcontrol.selectedSegmentIndex = 1;
    } else {
        self.tiltcontrol.selectedSegmentIndex = 0;
    }
    [self setbgPickerImage:self.currentbgimage];
    [self setavatarPickerImage:self.currentcostumeimage];
}

- (void)setbgPickerImage:(UIImage*)image{
    self.currentbgimage = image;
    image = [self scaleImage:image toSize:CGSizeMake(300, 160)];
    [self.bgimageview setImage:image];
}

- (void)setavatarPickerImage:(UIImage*)image{
    self.currentcostumeimage = image;
    image = [self scaleImage:image toSize:CGSizeMake(105, 130)];
    [self.avatarimageview setImage:image];
    
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
        [(MainMenuViewController*)self.navigationController.viewControllers[0] setBgimage:self.currentbgimage];
        [(MainMenuViewController*)self.navigationController.viewControllers[0] setCostumeimage:self.currentcostumeimage];
    }
}

-(IBAction)tiltcontrolMoved:(UISegmentedControl*)sender{
    self.tiltbool = sender.selectedSegmentIndex;
}
//Methods take care of movement, IBAction is too clumsy
-(IBAction)bgLeftPressed:(UIButton*)sender{
    int currentPos = [self.backgroundarray indexOfObject:self.currentbgimage];
    if (currentPos != 0){
        [self setbgPickerImage:self.backgroundarray[currentPos-1]];
    } else {
        [self setbgPickerImage:self.backgroundarray[self.backgroundarray.count-1]];
    }
}
-(IBAction)bgRightPressed:(UIButton*)sender{
    int currentPos = [self.backgroundarray indexOfObjectIdenticalTo:self.currentbgimage];
    if (currentPos < self.backgroundarray.count-1){
        [self setbgPickerImage:self.backgroundarray[currentPos+1]];
    } else {
        [self setbgPickerImage:self.backgroundarray[0]];
    }
}
-(IBAction)avatarLeftPressed:(UIButton*)sender{
    int currentPos = [self.costumearray indexOfObject:self.currentcostumeimage];
    if (currentPos != 0){
        [self setavatarPickerImage:self.costumearray[currentPos-1]];
    } else {
        [self setavatarPickerImage:self.costumearray[self.costumearray.count-1]];
    }
}
-(IBAction)avatarRightPressed:(UIButton*)sender{
    int currentPos = [self.costumearray indexOfObjectIdenticalTo:self.currentcostumeimage];
    if (currentPos < self.costumearray.count-1){
        [self setavatarPickerImage:self.costumearray[currentPos+1]];
    } else {
        [self setavatarPickerImage:self.costumearray[0]];
    }
}
@end
