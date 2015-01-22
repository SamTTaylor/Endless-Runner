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
    self.bglocked.hidden = true;
    self.costumelocked.hidden = true;

}

//Scales and sets the BG UIImageView to the defined image
- (void)setbgPickerImage:(UIImage*)image{
    
    if ([self checkContentAvailable:image] == false && image != self.backgroundarray[0]) {//If content is locked, say so (default bg  cannot be locked)
        self.bglocked.hidden = false;
    } else {
        self.bglocked.hidden = true;
    }
    
    //Sets b
    self.currentbgimage = image;
    image = [self scaleImage:image toSize:CGSizeMake(300, 160)];
    [self.bgimageview setImage:image];
}

//Does the same with the costume picker
- (void)setavatarPickerImage:(UIImage*)image{
    if ([self checkContentAvailable:image] == false && image != self.costumearray[0]) {
        self.costumelocked.hidden = false;
    } else {
        self.costumelocked.hidden = true;
    }
    
    self.currentcostumeimage = image;
    image = [self scaleImage:image toSize:CGSizeMake(105, 130)];
    [self.avatarimageview setImage:image];
    
}


//Scales any image to a defined size
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


//When view is left, relevant  properties in the MainMenuViewController are set to what was chosen in this session
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //If selected content is locked, default options are chosen
    if (![[self.navigationController viewControllers] containsObject:self]) {
        if (self.costumelocked.hidden == false) {
            self.currentcostumeimage = [UIImage imageNamed:@"avatar.gif"];
        }
        if (self.bglocked.hidden == false) {
            self.currentbgimage = [UIImage imageNamed:@"background"];
        }
        [(MainMenuViewController*)self.navigationController.viewControllers[0] setTiltbool:self.tiltbool];
        [(MainMenuViewController*)self.navigationController.viewControllers[0] setBgimageindex:(int)[self.backgroundarray indexOfObject:self.currentbgimage]];
        [(MainMenuViewController*)self.navigationController.viewControllers[0] setCostumeimageindex:(int)[self.costumearray indexOfObject:self.currentcostumeimage]];
    }
}

//Checks with the main menu view controller for any defined unlockable content, and returns whether it is unlocked or not
-(bool)checkContentAvailable:(UIImage*)content{
    bool unlocked;
    if ([self.backgroundarray containsObject:content]) {
        switch ([self.backgroundarray indexOfObjectIdenticalTo:content]) {
            case 1:
               unlocked = [(MainMenuViewController*)self.navigationController.viewControllers[0] england] ? YES : NO;
                return unlocked;
                break;
            case 2:
                unlocked = [(MainMenuViewController*)self.navigationController.viewControllers[0] austria] ? YES : NO;
                return unlocked;
                break;
                
            default:
                break;
        }
    }
    if ([self.costumearray containsObject:content]) {
        switch ([self.costumearray indexOfObjectIdenticalTo:content]) {
            case 1:
                unlocked = [(MainMenuViewController*)self.navigationController.viewControllers[0] england] ? YES : NO;
                return unlocked;
                break;
            case 2:
                unlocked = [(MainMenuViewController*)self.navigationController.viewControllers[0] pit] ? YES : NO;
                return unlocked;
                break;
            case 3:
                unlocked = [(MainMenuViewController*)self.navigationController.viewControllers[0] superlenny] ? true : false;
                return unlocked;
                break;
            case 4:
                unlocked = [(MainMenuViewController*)self.navigationController.viewControllers[0] christmas] ? YES : NO;
                return unlocked;
                break;
            case 5:
                unlocked = [(MainMenuViewController*)self.navigationController.viewControllers[0] halloween] ? YES : NO;
                return unlocked;
                break;
            case 6:
                unlocked = [(MainMenuViewController*)self.navigationController.viewControllers[0] austria] ? YES : NO;
                return unlocked;
                break;

            default:
                break;
        }
    }
    return false;
}




//Sets tiltbool to represent what has been selected in the tilt control
-(IBAction)tiltcontrolMoved:(UISegmentedControl*)sender{
    self.tiltbool = sender.selectedSegmentIndex;
}

//Moves down/wraps around the bg array and requests the image be presented
-(IBAction)bgLeftPressed:(UIButton*)sender{
    int currentPos = (int)[self.backgroundarray indexOfObject:self.currentbgimage];
    if (currentPos != 0){
        [self setbgPickerImage:self.backgroundarray[currentPos-1]];
    } else {
        [self setbgPickerImage:self.backgroundarray[self.backgroundarray.count-1]];
    }
}
//Moves up/wraps around the bg array and requests the image be presented
-(IBAction)bgRightPressed:(UIButton*)sender{
    int currentPos = (int)[self.backgroundarray indexOfObjectIdenticalTo:self.currentbgimage];
    if (currentPos < self.backgroundarray.count-1){
        [self setbgPickerImage:self.backgroundarray[currentPos+1]];
    } else {
        [self setbgPickerImage:self.backgroundarray[0]];
    }
}
//Moves down/wraps around the costume array and requests the image be presented
-(IBAction)avatarLeftPressed:(UIButton*)sender{
    int currentPos = (int)[self.costumearray indexOfObject:self.currentcostumeimage];
    if (currentPos != 0){
        [self setavatarPickerImage:self.costumearray[currentPos-1]];
    } else {
        [self setavatarPickerImage:self.costumearray[self.costumearray.count-1]];
    }
}
//Moves down/wraps around the costume array and requests the image be presented
-(IBAction)avatarRightPressed:(UIButton*)sender{
    int currentPos = (int)[self.costumearray indexOfObjectIdenticalTo:self.currentcostumeimage];
    if (currentPos < self.costumearray.count-1){
        [self setavatarPickerImage:self.costumearray[currentPos+1]];
    } else {
        [self setavatarPickerImage:self.costumearray[0]];
    }
}



@end
