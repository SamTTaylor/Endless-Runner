//
//  HighScoreViewController.m
//  Wiggly Wormhole
//
//  Created by acp14stt on 05/11/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "HighScoresViewController.h"

@interface HighScoresViewController ()

@end

@implementation HighScoresViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.highscores = [[NSMutableArray alloc] initWithArray:ad.highscores];//Initialise the local highscores array with the one from the app delegate
    
    UITableView *tableView = self.highscoretable;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    self.highscoretable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//Ensures the table is no longer than the array
    int width =self.view.bounds.size.width/4;
    int height =self.view.bounds.size.height*0.64;
    [self.highscoretable setFrame:CGRectMake(self.view.bounds.size.width/2-width/2, 200, width, height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 1 section
-(NSInteger)numberOfSectionsInTableView:
(UITableView *)sender {
    return 1;//Only 1 section
}
//5 rows
-(NSInteger)tableView:(UITableView *)sender
numberOfRowsInSection:(NSInteger)section {
    return [self.highscores count];//Number of rows equal to the number of highscore entries
}

//Cell population
-(UITableViewCell *)tableView:(UITableView *)sender
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myIdentifier = @"myIdentifier";
    UITableViewCell *cell = [sender
                             dequeueReusableCellWithIdentifier:myIdentifier];
    //A cell is initialised for each row if one did not previously exist
    if (cell==nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:myIdentifier];
    }
    
    //Cell text is set to the corresponding index of the sorted highscore arrays
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.highscores objectAtIndex:indexPath.row]];
    
    cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:22];
    return cell;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
