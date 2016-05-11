//
//  CalculatorViewController.h
//  SwissPlanner
//
//  Created by User on 4/12/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UIView *textDisplayView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerLevel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerPartnerLevel;
@property (weak, nonatomic) IBOutlet UIView *pickerViewPrepayment;
@property (weak, nonatomic) UIView *pickerPrepayment;
@property (weak, nonatomic) IBOutlet UILabel *euroSign;

@end
