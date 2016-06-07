//
//  TestingViewController.m
//  SwissPlanner
//
//  Created by User on 4/13/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "TestingViewController.h"
#import "SWRevealViewController.h"

#import "PlatformTypeChecker.h"
#import "TestBaseHelper.h"

@interface TestingViewController () {
    NSUserDefaults *defaults;
    TestBaseHelper *testBaseHelper;
}

@end

@implementation TestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background(testing)"]];
    [self updateViewBackground];
	
	// setting navigation bar
	UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
																   style:UIBarButtonItemStylePlain
																  target:self
																  action:nil];
	self.navigationItem.leftBarButtonItem = menuButton;
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(186/255.0)
																			 green:(134/255.0)
																			  blue:(111/255.0)
																			 alpha:1]];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	
	// setting slide menu view controller
	SWRevealViewController *revealViewController = self.revealViewController;
	if ( revealViewController )
	{
		[self.navigationItem.leftBarButtonItem setTarget: self.revealViewController];
		[self.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
		[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	}
    
    for (UIView * view in self.roundedCorners) {
        view.layer.cornerRadius = 15;
    }
    defaults = [NSUserDefaults standardUserDefaults];
    testBaseHelper = [[TestBaseHelper alloc] init];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    // before rotation
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        // during rotation
        [self updateViewBackground];
    } completion:^(id  _Nonnull context) {
        
        // after rotation
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSInteger questionsNumber = [testBaseHelper getNumberOfQuestions];
	NSString *bestTestResult = ([defaults objectForKey:@"bestTestResult"])? [[defaults objectForKey:@"bestTestResult"] stringValue] : @"None";
    NSString *lastTestResult = ([defaults objectForKey:@"lastTestResult"])?[[defaults objectForKey:@"lastTestResult"] stringValue] : @"None";
    self.resultLabel.text = [NSString stringWithFormat:@"BEST TEST TESULT\n%@ of %d\n\nLAST TEST TESULT\n%@ of %d", bestTestResult, questionsNumber, lastTestResult, questionsNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateViewBackground {
    NSString *platform = [PlatformTypeChecker platformType];
    if ([platform isEqualToString:@"iPhone 6"]||[platform isEqualToString:@"iPhone 6S"]/*||[platform isEqualToString:@"Simulator"]*/) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background(gifts)_iphone6"]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_iphone6"] forBarMetrics:UIBarMetricsDefault];
    } else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background(gifts)"]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
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
