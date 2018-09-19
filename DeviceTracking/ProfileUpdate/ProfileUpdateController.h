//
//  ProfileUpdateController.h
//  DeviceTracking
//
//  Created by Punit on 30/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileUpdateController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *contactNum;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UILabel *userId;

@property(nonatomic,retain)NSString *message,*status,*userRegistrations;

@end
