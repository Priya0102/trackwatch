//
//  SignUpViewController.m
//  DeviceTracking
//
//  Created by Punit on 09/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import "SignUpViewController.h"
#import "Base.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _usernameView.clipsToBounds = YES;
    _usernameView.layer.cornerRadius = 22;
    
    _passwordView.clipsToBounds = YES;
    _passwordView.layer.cornerRadius = 22;
    
    _emailView.clipsToBounds = YES;
    _emailView.layer.cornerRadius = 22;
    
    _contactView.clipsToBounds = YES;
    _contactView.layer.cornerRadius = 22;
    
    _addressView.clipsToBounds = YES;
    _addressView.layer.cornerRadius = 22;
    
    _signUpBtn.clipsToBounds = YES;
    _signUpBtn.layer.cornerRadius = 20;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewDidAppear:(BOOL)animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(BOOL)checkPassword:(UITextField *)textField
{
    int numberofCharacters = 0;
    NSLog(@"number of characters=%d",numberofCharacters);
    BOOL lowerCaseLetter = false,upperCaseLetter = false,digit = false,specialCharacter = 0;
    if([textField.text length] >= 8)
    {
        for (int i = 0; i < [textField.text length]; i++)
        {
            unichar c = [textField.text characterAtIndex:i];
            if(!lowerCaseLetter)
            {
                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!upperCaseLetter)
            {
                upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!digit)
            {
                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
            if(!specialCharacter)
            {
                specialCharacter = [[NSCharacterSet symbolCharacterSet] characterIsMember:c];
            }
        }
        
        if(specialCharacter && digit && lowerCaseLetter && upperCaseLetter)
        {
            return true;
        }
        else
        {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please ensure that you have at least one lower case letter, one upper case letter, one digit and one special character." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alertView dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            [alertView addAction:ok];
            [self presentViewController:alertView animated:YES completion:nil];
            return false;
        }
        
    }
    else
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password must be between 4 and 12 digits long and include at least one numeric digit." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [self presentViewController:alertView animated:YES completion:nil];
        
       
        return false;
    }
    
    return true;
    
}

- (IBAction)createAccountBtnClicked:(id)sender {
    
    [self requestRegistrationdata];
}

-(void)requestRegistrationdata{
    
    NSDictionary *data = @{
                            @"username":self.usernameTxtFld.text ,
                            @"address":self.addressTxtFld.text ,
                            @"email":self.emailTxtFld.text ,
                            @"contactNumber":self.contactTxtFld.text ,
                            @"password": self.passwordTxtFld.text
                            };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:signUp]]];

    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:nil timeoutInterval:60];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    
    NSLog(@"Return resistration String%@",retStr);
    
    
    NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"response data:%@",maindic);
    
    self.status=[maindic objectForKey:@"status"];
    self.message=[maindic objectForKey:@"message"];
    self.username=[maindic objectForKey:@"username"];
    
    
    NSLog(@"status==%@& message=%@ username==%@",self.status,self.message,self.username);
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        
    }];
    if ([self.status isEqual:@"1"]) {
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Success" message:@"Registered successfully" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                          
                             }];
        
        [alertView addAction:ok];
     
        [self presentViewController:alertView animated:YES completion:nil];
        
        
    }
    else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Alert" message:self.message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    
}


@end
