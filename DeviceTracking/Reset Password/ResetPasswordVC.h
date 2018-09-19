//
//  ResetPasswordVC.h
//  DeviceTracking
//
//  Created by Punit on 23/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tokenTxtfld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *confirmTxtFld;

@property(nonatomic,retain)NSString *message,*status;
@end
