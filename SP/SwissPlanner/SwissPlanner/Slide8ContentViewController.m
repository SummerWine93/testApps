//
//  Slide8ContentViewController.m
//  SwissPlanner
//
//  Created by User on 4/28/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "Slide8ContentViewController.h"

@interface Slide8ContentViewController ()

@end

@implementation Slide8ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.yourCellsRows = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:8], nil];
	self.partnerCellsRows = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:11], nil];
}

- (void) setSpecificViews {
    self.headerBlockLabel.text = NSLocalizedString(@"education.slide8.header", nil);
    
    self.contentBlock1Label.text = NSLocalizedString(@"education.slide8.block1.header", nil);
    self.headerContentBlock2Label.text = NSLocalizedString(@"education.slide8.block2.header", nil);
    self.headerContentBlock3Label.text = NSLocalizedString(@"education.slide8.block3.header", nil);
    
    self.contentBlock2Label.text = NSLocalizedString(@"education.slide8.block2.content", nil);
    self.contentBlock3Label.text = NSLocalizedString(@"education.slide8.block3.content", nil);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
