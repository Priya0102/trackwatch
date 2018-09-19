//
//  DeviceOrderViewController.h
//  DeviceTracking
//
//  Created by Punit on 09/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceOrderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *firstnameView;
@property (weak, nonatomic) IBOutlet UIView *lastnameView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UIView *address1View;
@property (weak, nonatomic) IBOutlet UIView *address2View;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UIView *countryView;
@property (weak, nonatomic) IBOutlet UIView *pincodeView;
@property (weak, nonatomic) IBOutlet UIView *numOfDeviceView;
@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIButton *placeOrderBtn;

@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *firstnameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *address1TxtFld;
@property (weak, nonatomic) IBOutlet UITextField *address2TxtFld;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *numberOfDevicesTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *cityTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *stateTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *countryTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *pinCodeTxtFld;

@property (nonatomic,strong) NSString *message,*status,*orderId;

@end
