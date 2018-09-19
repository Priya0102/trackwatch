//
//  SOSViewController.h
//  DeviceTracking
//
//  Created by Punit on 04/09/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOSViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *sosBtn;
@property (weak, nonatomic) IBOutlet UIButton *sosBtnClicked;
@property (weak, nonatomic) IBOutlet UIView *addSOSNumView;
@property (weak, nonatomic) IBOutlet UITextField *sosNumone;
@property (weak, nonatomic) IBOutlet UITextField *sosNumtwo;
@property (weak, nonatomic) IBOutlet UITextField *sosNumThree;

- (IBAction)saveBtnClicked:(id)sender;
- (IBAction)dismissBtnClicked:(id)sender;



@end
