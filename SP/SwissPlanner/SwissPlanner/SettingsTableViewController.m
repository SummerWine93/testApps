//
//  SettingsTableViewController.m
//  SwissPlanner
//
//  Created by User on 5/24/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SWRevealViewController.h"


@interface SettingsTableViewController () {
	NSDictionary *settingsCategories;
	NSMutableDictionary *settings;
	NSArray *bonusPointsArray;
	BOOL checkBoxSelected;
}

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// setting navigation bar
	UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
																   style:UIBarButtonItemStylePlain
																  target:self
																  action:nil];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
	
	// adding navigation capabilities
	self.navigationItem.leftBarButtonItem = menuButton;
	SWRevealViewController *revealViewController = self.revealViewController;
	if ( revealViewController )
	{
		[self.navigationItem.leftBarButtonItem setTarget: self.revealViewController];
		[self.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
		[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	}
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
	
	bonusPointsArray = [NSArray arrayWithObjects:@0, @0, @100, @300, @1000, @2500, @5000, @10000, @25000, @50000, @100000, @200000, nil];
	
	// setting the checkbox
	[_checkbox setBackgroundImage:[UIImage imageNamed:@"notselectedcheckbox.png"]
						 forState:UIControlStateNormal];
	[_checkbox setBackgroundImage:[UIImage imageNamed:@"selectedcheckbox.png"]
						 forState:UIControlStateSelected];
	[_checkbox setBackgroundImage:[UIImage imageNamed:@"selectedcheckbox.png"]
						 forState:UIControlStateHighlighted];
	_checkbox.adjustsImageWhenHighlighted=YES;
	
	[_nameLabel addRegx:@"^.{1,50}$" withMsg:@"User name characters limit should be come between 1-50"];
	//[_nameLabel addRegx:@"[A-Za-z]|{1,50}" withMsg:@"Only alpha numeric characters are allowed."];
	
	[_pointsLabel addRegx:@"^([0-9]|[1-9][0-9]|[1-9][0-9][0-9]||[1-9][0-9][0-9][0-9]|[1-9][0-9][0-9][0-9][0-9]|1[1-9][0-9][0-9][0-9][0-9]|200000)$" withMsg:@"Only numeric characters in range from 0-200000 are allowed."];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.nameLabel setHighlighted:YES];
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.nameLabel.text = [defaults objectForKey:@"userName"];
    self.pointsLabel.text = [[defaults objectForKey:@"userPoints"] stringValue];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    // before rotation
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        // during rotation
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    } completion:^(id  _Nonnull context) {
        // after rotation
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - Text field delegate methods

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	if ([(TextFieldValidator *)textField validate]) {
		return YES;
	}
	return NO;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return NO;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    // Store the user data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.nameLabel.text forKey:@"userName"];
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if ([self.pointsLabel.text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        NSInteger points = [[f numberFromString:self.pointsLabel.text] integerValue];
		NSInteger maxPoints = [[bonusPointsArray objectAtIndex:([bonusPointsArray count]-1)] integerValue];
		[defaults setObject:[NSNumber numberWithInteger:((points < maxPoints)?points:maxPoints)] forKey:@"userPoints"];
		for (int i=0; i<[bonusPointsArray count]-1; i++) {
			if ([[bonusPointsArray objectAtIndex:i+1] integerValue] >= points) {
				
				if (points == [[bonusPointsArray objectAtIndex:i+1] integerValue]) {
					NSInteger pointsLeft = ([bonusPointsArray count]==i+2)?0:([[bonusPointsArray objectAtIndex:i+2] integerValue] - points);
					[defaults setObject:[NSNumber numberWithInteger:pointsLeft] forKey:@"pointsLeft"];
					[defaults setObject:[NSNumber numberWithInteger:i+1] forKey:@"userLevel"];
				} else {
					NSInteger pointsLeft = ([[bonusPointsArray objectAtIndex:i+1] integerValue] - points);
					[defaults setObject:[NSNumber numberWithInteger:pointsLeft] forKey:@"pointsLeft"];
					[defaults setObject:[NSNumber numberWithInteger:i] forKey:@"userLevel"];
				}
                break;
			}
		}
		
    } else {
        [defaults setObject:[NSNumber numberWithInteger:0] forKey:@"userPoints"];
        self.pointsLabel.text = @"The points value must be a number";
    }
	if (checkBoxSelected) {
		[defaults setObject:[NSNumber numberWithBool:checkBoxSelected] forKey:@"isInLeadershipProgram"];
	}
    
    [defaults synchronize];
}

#pragma mark - Checkbox methods

- (IBAction)isInProgramButtonClicked:(id)sender {
	checkBoxSelected = !checkBoxSelected; /* Toggle */
	[_checkbox setSelected:checkBoxSelected];
	
}


@end
