//
//  PersonalInfoViewController.h
//  DeviceTracking
//
//  Created by Punit on 20/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *contactNum;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)saveBtnClicked:(id)sender;

@property(nonatomic,retain)NSString *status,*message,*genderTypeStr;
@end
